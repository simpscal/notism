---
name: dev
description: Dev — implement one user story and open a PR to the sprint feature branch. Usage: /dev [issue-number]
tools: Read, Glob, Grep, Bash, Agent(backend, frontend, devops), mcp__github__issue_read, mcp__github__list_issues, mcp__github__add_issue_comment, mcp__github__update_pull_request
---

# Dev Orchestrator

## Workflow

### Step 1 — Acquire ONE Ticket

`$ARGUMENTS` is the issue number (optional — omit to auto-pick).

**If ISSUE_NUMBER provided:** Use `fetch_issue($ARGUMENTS)` from the tracker adapter.

**If auto-pick:** Use `list_issues` filtered by `technical-design` label to identify the active sprint milestone. Then use `list_issues(milestone_id)` (all open issues in the sprint, no label filter) and filter client-side for `tl-reviewed` + no `in-progress` label + no unmet dependencies per the TDD's Story Dependencies section. If none found, report "No unassigned tickets available" and stop.

Read the issue in full and identify its `skill:` label(s). Use `update_labels(issue_id, add: [in-progress], remove: [])` from the tracker adapter.

Implement **one story per invocation** — do not batch.

### Step 2 — Read the TDD

Use `list_issues(milestone_id, labels: [technical-design])` to find the TDD issue. Use `fetch_issue` to read it in full — problem statement, proposed solution, architecture alignment, story dependencies, and risks. Build a sprint-wide mental model: which stories depend on which, what shared infrastructure exists, and what patterns the TL has prescribed.

### Step 3 — Gather All Story Context in Parallel

In a single batch, fetch all context needed for dispatch. Fire these simultaneously (they are all independent once the ticket is selected):

1. **Issue body + comments** — the ticket already fetched in Step 1 (hold it)
2. **TDD** — `list_issues(milestone_id, labels: [technical-design])` to find it, then `fetch_issue(tdd_number)` to read full content. Extract: problem statement, proposed solution, architecture alignment, story dependencies, risks.
3. **Design Instructions** (frontend only) — from the `## Design Instructions` comment already in the issue's comment list from Step 1. Extract the full body if present.
4. **Story Amendment** — scan issue body (from Step 1) for `## Story Amendment` section. If present, extract the `### Updated Acceptance Criteria` list.
5. **Existing PR** — if issue has label `story-updated`, scan comments for `## Implementation Complete`, extract PR number(s), then `fetch_pr(pr_number)` to get branch name.

After all fetches complete:

**Determine remaining work:** Scan the `## Acceptance Criteria` checklist in the issue body and, if present, the `### Updated Acceptance Criteria` list in `## Story Amendment`. Build two lists:
- **Done** — items marked `- [x]`
- **Remaining** — items marked `- [ ]`

If the Remaining list is empty and no `## Story Amendment` adds new unchecked items, stop and report: "All acceptance criteria for story #N are already complete. Nothing left to implement."

### Step 4 — Dispatch to Skill Subagent

Inspect the ticket's `skill:` label(s) and invoke the matching subagent(s) using the Agent tool.

**If the skill label is missing or unrecognised:** Stop and report: "No skill label found on ticket — run `/tl` to annotate the story first."

Pass the following context to every subagent invocation. **All context is passed directly — do NOT instruct subagents to fetch issues, read project.md, or re-read the TDD:**

- **Ticket**: full issue body, notes, issue number; remaining ACs (unchecked `- [ ]` items only — do not re-implement already-checked `- [x]` items)
- **TL Annotation**: skill, complexity, scope, key decisions, AC-to-design mapping (from issue comments gathered in Step 3)
- **TDD**: full content gathered in Step 3 — verbatim
- **Design instructions**: full content from `## Design Instructions` comment (frontend only, gathered in Step 3)
- **Story Amendment**: the `## Story Amendment` section from the issue body, or "None". If present, prepend: "IMPORTANT: This story has been amended. The Story Amendment supersedes the original ACs for any items listed — implement the amended versions only."
- **Existing PR**: PR number and branch name if found in Step 3, or "None". If present, prepend: "IMPORTANT: This story was previously implemented. Do NOT create a new branch or PR. Check out the existing branch, apply the amendment changes as additional commits, and push to the existing PR."
- **Git**: sprint branch name, story branch name, main branch name
- **Project config**: use the values loaded in Step 0 from project.md — do NOT read project.md or the tracker adapter inside the subagent

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
## Implementation Complete

- PR #<pr-number>

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
