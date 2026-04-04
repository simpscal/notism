---
name: dev
description: Dev — implement one user story and open a PR to the sprint feature branch. Usage: /dev [issue-number]
tools: Read, Glob, Grep, Bash, Agent(backend, frontend, devops), mcp__github__issue_read, mcp__github__list_issues, mcp__github__add_issue_comment, mcp__github__update_pull_request
---

# Dev Orchestrator

## Plan Mode Guard

If a `Plan mode is active` system-reminder is present in the conversation context, **do not perform any write operations** in this run. Do not call `create_issue`, `create_milestone`, `create_branch`, `create_pr`, `post_comment`, `post_pr_comment`, `update_labels`, or `submit_review`. Instead, complete all read and analysis steps normally and output the final artefact directly in the conversation. Then stop without writing to the tracker or codebase.

## Workflow

### Step 0 — Read Project Config

Read `.claude/project.md`. Extract and hold in memory: tracker adapter path, repo, codebase paths, tech stack details, architecture doc locations, labels, git branch patterns, main branch name, and test/lint commands. Then read the tracker adapter file — all issue tracker operations use the operations it defines. No hardcoded values.

### Step 1 — Acquire ONE Ticket

`$ARGUMENTS` is the issue number (optional — omit to auto-pick).

**If ISSUE_NUMBER provided:** Use `fetch_issue($ARGUMENTS)` from the tracker adapter.

**If auto-pick:** Use `list_issues` filtered by `technical-design` label to identify the active sprint milestone. Then use `list_issues(milestone_id, labels: [tl-reviewed])` and pick the first open, unassigned result with no unmet dependencies per the TDD's Story Dependencies section. If none found, report "No unassigned tickets available" and stop.

Read the issue in full and identify its `skill:` label(s). Use `update_labels(issue_id, add: [in-progress], remove: [])` from the tracker adapter.

Implement **one story per invocation** — do not batch.

### Step 2 — Read the TDD

Use `list_issues(milestone_id, labels: [technical-design])` to find the TDD issue. Use `fetch_issue` to read it in full — problem statement, proposed solution, architecture alignment, story dependencies, and risks. Build a sprint-wide mental model: which stories depend on which, what shared infrastructure exists, and what patterns the TL has prescribed.

### Step 3 — Fetch Story Context

Read:
- The full issue body (description + ACs + notes) — already fetched in Step 1
- The `## Technical Lead Annotation` comment on the issue (use `fetch_issue` which returns comments)
- The TDD sections referenced in the annotation

**If any skill label is `skill:frontend`:** Check for a `## Design Instructions` comment on the issue (posted by the designer). If found, read it in full — this is the primary source for UI implementation guidance.

**Check for story amendment:** If the issue body contains a `## Story Amendment` section, read it in full. Every AC listed under `### Updated Acceptance Criteria` supersedes the matching AC in the original issue body. ACs not mentioned remain in force from the original.

**Check for existing PR:** If the issue has label `story-updated`, scan comments for any `## Implementation Complete` comment. If found, extract the PR number(s). Use `fetch_pr(<pr-number>)` from the tracker adapter to read each PR and obtain its branch name. These are the **continuation branches** — pass them to the subagent instead of generating new branch names.

**Determine remaining work:** Scan the `## Acceptance Criteria` checklist in the issue body and, if present, the `### Updated Acceptance Criteria` list in `## Story Amendment`. Build two lists:
- **Done** — items marked `- [x]`
- **Remaining** — items marked `- [ ]`

If the Remaining list is empty and no `## Story Amendment` adds new unchecked items, stop and report: "All acceptance criteria for story #N are already complete. Nothing left to implement."

### Step 4 — Dispatch to Skill Subagent

Inspect the ticket's `skill:` label(s) and invoke the matching subagent(s) using the Agent tool.

**If the skill label is missing or unrecognised:** Stop and report: "No skill label found on ticket — run `/tl` to annotate the story first."

Pass the following context to every subagent invocation:
- Ticket: full issue body, notes, issue number; remaining ACs (unchecked `- [ ]` items only — do not re-implement already-checked `- [x]` items)
- TL Annotation: skill, complexity, scope, key decisions, AC-to-design mapping
- TDD: full content
- Design instructions: full content (frontend only)
- Story Amendment: the `## Story Amendment` section from the issue body, or "None". If present, prepend: "IMPORTANT: This story has been amended. The Story Amendment supersedes the original ACs for any items listed — implement the amended versions only."
- Existing PR: PR number and branch name if found in Step 3, or "None". If present, prepend: "IMPORTANT: This story was previously implemented. Do NOT create a new branch or PR. Check out the existing branch, apply the amendment changes as additional commits, and push to the existing PR."
- Git: sprint branch name, story branch name, main branch name
- Project config: codebase paths, architecture doc paths, test/lint commands, tracker adapter path

**Story branch naming** (only when no existing PR):
- Single-skill story: `feature/issue-{N}-{short-description}` (from config pattern)
- Multi-skill story: append a skill suffix — `feature/issue-{N}-{short-description}-backend` and `feature/issue-{N}-{short-description}-frontend`

Each subagent always creates its own branch and opens its own PR — **unless** an existing PR was found, in which case it pushes to the existing branch instead.

| Skill label | Subagent(s) | Execution |
|-------------|-------------|-----------|
| `skill:backend` only | `backend` | single |
| `skill:frontend` only | `frontend` | single |
| `skill:devops` only | `devops` | single |
| `skill:backend` + `skill:frontend` | `backend` + `frontend` | **parallel** |

**Multi-skill stories:** Invoke `backend` and `frontend` simultaneously using the Agent tool in a single message. Do not wait for one before starting the other.

If any subagent reports a blocker, use `post_comment(ISSUE_NUMBER)` from the tracker adapter to post the blocker on the issue, then halt.

### Step 5 — Notify

**If an existing PR was found in Step 3** — the `## Implementation Complete` comment already exists on the issue. Skip this step entirely.

**Otherwise**, once all subagents have completed, use `post_comment(ISSUE_NUMBER, body)` from the tracker adapter:

```
## Implementation Complete — PR #<pr-number>

---
> ⏸ Human gate: Review the PR diff. When approved, merge into the sprint branch.
```

For multi-skill stories with two PRs, list both:

```
## Implementation Complete

- Backend: PR #<pr-number>
- Frontend: PR #<pr-number>

---
> ⏸ Human gate: Review both PR diffs. When approved, merge into the sprint branch.
```

## Constraints

- Implement strictly within the scope of the ACs — no extras, no refactors beyond what the story requires
- Do not merge the PR
- If a blocker is found, comment on the issue and stop — do not guess
- PR must always target the sprint feature branch, never main directly
