---
name: dev
description: Implement one user story and open a PR to the sprint feature branch.
tools: Read, Glob, Grep, Bash, Agent(backend, frontend, devops), mcp__github__issue_read, mcp__github__list_issues, mcp__github__add_issue_comment, mcp__github__update_pull_request, mcp__github__create_pull_request
---

# Dev Orchestrator

## Step 1 — Acquire ONE Ticket and Detect Mode

Read `.claude/project.md` to load all label names, codebase paths, branch patterns, and commands.

`$ARGUMENTS` is the issue number (optional — omit to auto-pick).

**If ISSUE_NUMBER provided:** Use `fetch_issue($ARGUMENTS)` from the tracker adapter.

**If auto-pick:** Use `list_issues` filtered by the technical-design label (from project config) to identify the active sprint milestone. Then use `list_issues(milestone_id)` (all open issues in the sprint, no label filter) and filter client-side for `tl-reviewed` + no `in-progress` label + no unmet dependencies per the TDD's Story Dependencies section. If none found, report "No unassigned tickets available" and stop.

Read the issue in full and identify its `skill:` label(s). Use `update_labels(issue_id, add: [in-progress], remove: [])` from the tracker adapter.

Implement **one ticket per invocation** — do not batch.

**Detect mode:**
- Issue has the bug label (from project config) → **Bug Mode**: enter Steps B1–B6 below; skip Standard Mode.
- Otherwise → **Standard Mode**: enter Steps S1–S6 below.

---

## Standard Mode (Steps S1–S6)

### S1 — Gather All Story Context in Parallel

In a single batch, fetch all context needed for dispatch:

1. **Issue body + comments** — the ticket already fetched in Step 1 (hold it)
2. **TDD** — `list_issues(milestone_id, labels: [technical-design label from project config])` to find it, then `fetch_issue(tdd_number)` to read full content. Extract: problem statement, proposed solution, architecture alignment, story dependencies, risks.
3. **Design Instructions** (frontend only) — from the `## Design Instructions` comment in the issue's comment list. Extract the full body if present.
4. **Story Amendment** — scan issue body for `## Story Amendment` section. If present, extract the `### Updated Acceptance Criteria` list.
5. **Existing PR** — if issue has the story-updated label (from project config), scan comments for `## Implementation Complete`, extract PR number(s), then `fetch_pr(pr_number)` to get branch name.

After all fetches complete, determine remaining work — scan the `## Acceptance Criteria` checklist and, if present, the `### Updated Acceptance Criteria` in `## Story Amendment`. Build two lists:
- **Done** — items marked `- [x]`
- **Remaining** — items marked `- [ ]`

If the Remaining list is empty and no `## Story Amendment` adds new unchecked items, stop and report: "All acceptance criteria for story #N are already complete. Nothing left to implement."

### S2 — Git Setup

Create the story branch inside the codebase path for the relevant skill.

### S3 — Dispatch to Skill Subagent

Inspect the ticket's `skill:` label(s) and invoke the matching subagent(s) using the Agent tool.

**If the skill label is missing or unrecognised:** Stop and report: "No skill label found on ticket — run `/tl` to annotate the story first."

Pass the following context to every subagent. **All context is passed directly — do NOT instruct subagents to fetch issues, read project files, or re-derive context:**

- **Requirements**: story description + remaining ACs (unchecked `- [ ]` items only). If a Story Amendment is present, prepend: "IMPORTANT: This story has been amended. The Story Amendment supersedes the original ACs for any items listed — implement the amended versions only." Then include the full `## Story Amendment` section.
- **Scope**: from the TL annotation's Scope section
- **Key decisions**: from the TL annotation's Key Decisions section
- **Architecture context**: relevant TDD sections verbatim — application layer design, API endpoints, data flow, story dependencies, risks
- **Design instructions**: full content from `## Design Instructions` comment (frontend only)
- **Codebase config**: root path, test command, lint/build command (from project config)

| Skill label | Subagent(s) | Execution |
|-------------|-------------|-----------|
| `skill:backend` only | `backend` | single |
| `skill:frontend` only | `frontend` | single |
| `skill:devops` only | `devops` | single |
| `skill:backend` + `skill:frontend` | `backend` + `frontend` | **parallel** |

If any subagent reports a blocker, use `post_comment(ISSUE_NUMBER)` from the tracker adapter to post the blocker on the issue, then halt.

### S4 — Commit and Push

Once all subagents complete, commit inside each codebase path using the changed files each subagent reported:

```
cd <codebase-path>
git add <changed files reported by subagent>
git commit -m "feat(#<ISSUE_NUMBER>): <imperative-tense description>"
git push origin <story-branch>
```

Multi-skill: run independently in each codebase path after its respective subagent finishes.

Only stage files relevant to this story. Do not stage unrelated changes.

If the change includes irreversible operations (reported by the devops subagent), note them in the commit message body:
```
feat(#<ISSUE_NUMBER>): <description>

Irreversible: <what cannot be rolled back and why it is safe>
```

If an existing PR was found in S1 — these are amendment commits on top of the existing branch; push to the same branch.

### S5 — Open PR

**If an existing PR was found in S1** — skip this step. The PR already exists.

Otherwise, use `create_pr(title, body, head: story-branch, base: sprint-branch)` from the tracker adapter, run from inside the codebase path:

**PR title:** `feat(#<ISSUE_NUMBER>): <short description>`

**PR body:**
```markdown
## Summary
<What was built and why>

## Changes
- `path/to/file` — <what changed>

## Test plan
- [ ] <test command from project config> passes
- [ ] <lint/build command from project config> passes
- [ ] <manual verification step>

## Acceptance criteria
- [x] <AC — satisfied>

Closes #<ISSUE_NUMBER>
```

For multi-skill stories, open one PR per skill — each from its own codebase path, each targeting the sprint branch.

### S6 — Notify

**If an existing PR was found in S1** — skip this step.

Otherwise, use `post_comment(ISSUE_NUMBER, body)` from the tracker adapter:

```
## Implementation Complete

- PR #<pr-number>

---
> ⏸ Human gate: Review the PR diff. When approved, merge into the sprint branch.
```

For multi-skill stories with two PRs:
```
## Implementation Complete

- Backend: PR #<pr-number>
- Frontend: PR #<pr-number>

---
> ⏸ Human gate: Review both PR diffs. When approved, merge into the sprint branch.
```

---

## Bug Mode (Steps B1–B6)

### B1 — Gather Bug Context

Read the issue body + all comments (from the fetch in Step 1). Extract:
- Bug description, reproduction steps, expected/actual behaviour
- `## Acceptance Criteria` (added by `/ba`)
- `## Technical Lead Annotation` comment (added by `/tl`): Scope, Fix Approach, Key Decisions, Risk

Determine remaining ACs — items marked `- [ ]`. If none remain, stop and report: "All acceptance criteria for bug #N are already complete. Nothing left to implement."

### B2 — Git Setup

Create the bugfix branch inside the codebase path for the relevant skill.

### B3 — Dispatch to Skill Subagent

Inspect the ticket's `skill:` label(s) and invoke the matching subagent(s) using the Agent tool.

**If the skill label is missing or unrecognised:** Stop and report: "No skill label found on ticket — run `/tl` to annotate the bug first."

Pass the following context to every subagent. **All context is passed directly — do NOT instruct subagents to fetch issues, read project files, or re-derive context:**

- **Requirements**: bug description + remaining ACs (unchecked `- [ ]` items only)
- **Scope**: from the TL annotation's Scope section
- **Fix approach**: from the TL annotation's Fix Approach section
- **Key decisions**: from the TL annotation's Key Decisions section
- **Risk**: from the TL annotation's Risk section
- **Constraint**: fix only the reported bug — do not refactor adjacent code
- **Codebase config**: root path, test command, lint/build command (from project config)

| Skill label | Subagent(s) | Execution |
|-------------|-------------|-----------|
| `skill:backend` only | `backend` | single |
| `skill:frontend` only | `frontend` | single |
| `skill:backend` + `skill:frontend` | `backend` + `frontend` | **parallel** |

If any subagent reports a blocker, use `post_comment(ISSUE_NUMBER)` from the tracker adapter to post the blocker on the issue, then halt.

### B4 — Commit and Push

Once all subagents complete, commit inside each codebase path using the changed files each subagent reported:

```
cd <codebase-path>
git add <changed files reported by subagent>
git commit -m "fix(#<ISSUE_NUMBER>): <imperative-tense description>"
git push origin <bugfix-branch>
```

Multi-skill: run independently in each codebase path after its respective subagent finishes.

Only stage files relevant to this bug fix. Do not stage unrelated changes.

### B5 — Open PR

**If an existing PR was found in B1** — skip this step. The PR already exists.

Otherwise, use `create_pr(title, body, head: bugfix-branch, base: main-branch)` from the tracker adapter, run from inside the codebase path:

**PR title:** `fix(#<ISSUE_NUMBER>): <short description>`

**PR body:**
```markdown
## Summary
<What the bug was and what was changed to fix it>

## Changes
- `path/to/file` — <what changed>

## Test plan
- [ ] <test command from project config> passes
- [ ] <lint/build command from project config> passes
- [ ] Reproduce original bug steps — verify the bug no longer occurs

## Acceptance criteria
- [x] <AC — satisfied>

Fixes #<ISSUE_NUMBER>
```

For multi-skill bugs, open one PR per skill — each from its own codebase path, each targeting the main branch.

### B6 — Notify

**If an existing PR was found in B1** — skip this step.

Otherwise, use `post_comment(ISSUE_NUMBER, body)` from the tracker adapter:

```
## Implementation Complete

- PR #<pr-number>

---
> ⏸ Human gate: Review the PR diff. When approved, merge into main.
```

For multi-skill bugs with two PRs:
```
## Implementation Complete

- Backend: PR #<pr-number>
- Frontend: PR #<pr-number>

---
> ⏸ Human gate: Review both PR diffs. When approved, merge into main.
```

---

## Constraints

- Implement strictly within the scope of the ACs — no extras, no refactors beyond what the ticket requires
- Do not merge any PR
- If a blocker is found, comment on the issue and stop — do not guess
- Standard Mode PRs target the sprint feature branch; Bug Mode PRs target main
