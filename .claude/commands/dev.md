---
name: dev
description: Implement one user story. Modes: standard (fresh implementation), change (delta implementation after a story AC, design, or technical update).
tools: Read, Glob, Grep, Bash, Agent(backend, frontend, devops), mcp__github__issue_read, mcp__github__list_issues, mcp__github__add_issue_comment, mcp__github__update_pull_request, mcp__github__create_pull_request
---

# Dev Orchestrator

## Step 1 — Parse Mode and Acquire Ticket

Read `.claude/project.md` to load all label names, codebase paths, branch patterns, and commands.

The **first word** of `$ARGUMENTS` determines the mode:

| First word | Mode | Remaining argument |
|---|---|---|
| `standard` | Standard | `<issue_number>` (required) |
| `change` | Change | `<issue_number>` (required) |

`fetch_issue(issue_number)` from the tracker adapter. Read the issue in full and identify its `skill:` label(s). `update_labels(issue_id, add: [in-progress], remove: [])`.

Implement **one ticket per invocation** — do not batch.

---

## Standard Mode (S1–S6)

### S1 — Gather All Story Context in Parallel

In a single batch, fetch all context needed for dispatch:

1. **Issue body + comments** — the ticket already fetched in Step 1 (hold it)
2. **TDD** — `list_issues(milestone_id, labels: [technical-design label from project config])` to find it, then `fetch_issue(tdd_number)` to read full content. Extract: problem statement, proposed solution, architecture alignment, story dependencies, risks.
3. **Design Instructions** (frontend only) — `list_issues(milestone_id, labels: [design-reviewed])` to find the design instructions issue. `fetch_issue` it in full — the document covers the entire sprint's UI design and gives the subagent necessary feature-wide context.

### S2 — Git Setup

Apply the **Story branch setup → No existing PR** strategy inside the codebase path for the relevant skill.

### S3 — Dispatch to Skill Subagent

Inspect the ticket's `skill:` label(s) and invoke the matching subagent(s) using the Agent tool.

**If the skill label is missing or unrecognised:** Stop and report: "No skill label found on ticket — run `/tl` to annotate the story first."

Pass the following context to every subagent. **All context is passed directly — do NOT instruct subagents to fetch issues, read project files, or re-derive context:**

- **Requirements**: story description + full `## Acceptance Criteria` section
- **Scope**: from the TL annotation's Scope section
- **Key decisions**: from the TL annotation's Key Decisions section
- **Architecture context**: relevant TDD sections verbatim — application layer design, API endpoints, data flow, story dependencies, risks
- **Design instructions**: full design instructions issue (frontend only) — sprint-level document covering all affected surfaces
- **Codebase config**: root path, test command, lint/build command (from project config)

| Skill label | Subagent(s) | Execution |
|-------------|-------------|-----------|
| `skill:backend` only | `backend` | single |
| `skill:frontend` only | `frontend` | single |
| `skill:devops` only | `devops` | single |
| `skill:backend` + `skill:frontend` | `backend` + `frontend` | **parallel** |

If any subagent reports a blocker, `post_comment(ISSUE_NUMBER)` with the blocker and halt.

### S4 — Mark ACs, Commit and Push

Once all subagents complete, first update the issue body — rewrite every `- [ ]` item in the `## Acceptance Criteria` section as `- [x]`. Use `update_issue_body(ISSUE_NUMBER, updated_body)` from the tracker adapter.

Then commit inside each codebase path using the changed files each subagent reported:

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

### S5 — Open PR

Use `create_pr(title, body, head: story-branch, base: sprint-branch)` from the tracker adapter, run from inside the codebase path:

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

`post_comment(ISSUE_NUMBER, body)` from the tracker adapter:

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

`update_labels(ISSUE_NUMBER, add: [implemented], remove: [in-progress])` from the tracker adapter.

---

## Change Mode (C1–C5)

Entered when `change` is the first argument. The story already has an implementation on an existing branch. One or more of the labels `story-updated`, `design-updated`, or `technical-updated` is expected — implement the delta only; do not re-implement what is already on the branch.

### C1 — Gather Change Context in Parallel

In a single batch:

1. **Issue body + comments** — the ticket already fetched in Step 1 (hold it)
2. **TDD** — fetch as in S1 step 2; re-read in full regardless of which label is present
3. **Original Design Instructions** (frontend only) — fetch as in S1 step 3 (full issue)
4. **Updated Design Instructions** (frontend only, if `design-updated` label is present) — `list_issues(milestone_id, labels: [design-updated])` to find the updated design instructions issue. `fetch_issue` it in full. The full document contains the `## Change Description` block and the complete revised sprint-level design.
5. **Latest TL Annotation** (if `technical-updated` label is present) — scan issue comments for the most recent `## Technical Lead Annotation`. Extract updated Skill, Complexity, Scope, and Key Decisions. Earlier annotation comments are superseded.
6. **Existing branch + PR** — scan issue comments for `## Implementation Complete`. Extract PR number(s). `fetch_pr(pr_number)` to get the branch name. If no `## Implementation Complete` comment is found, report "No previous implementation found for story #N — run `/dev standard <N>` instead." and stop.

Determine the change delta — what needs to be implemented or revised:

| Label | Delta |
|-------|-------|
| `story-updated` | BA rewrote the `## Acceptance Criteria` section in the issue body. Re-read it now and reconcile against the existing implementation map from C2. |
| `technical-updated` | TL updated the annotation and/or TDD. The existing implementation may need to be revised to match the updated Scope, Key Decisions, API contracts, or data models in the latest annotation and TDD. |
| `design-updated` | Designer updated the design instructions. The existing UI may need to be revised to match the updated layout, components, tokens, or states described in the `## Change Description` of the updated design instructions issue. |

All three labels may be present simultaneously — collect every applicable delta.

### C2 — Git Setup and Read Existing Implementation

Using the PR already fetched in C1 step 6, inspect its `merged` field:

- **PR not merged** — apply **Story branch setup → Existing PR found (not merged)**: `checkout_branch(<existing-branch>)` inside `<codebase-path>`.
- **PR merged** — apply **Story branch setup → Existing PR found and merged**: `create_branch(<story-branch-pattern>, <sprint-branch>)` inside `<codebase-path>`.

For multi-skill stories, determine merge status and apply the correct strategy independently in each codebase path.

Once on the branch, read the source files relevant to this story's scope (use the Scope section from the latest TL annotation in C1 step 5 to identify which layers and modules are touched). For each affected layer — API endpoints, handlers, services, repositories, UI components, state slices — read the actual files and build an **existing implementation map**:

- Which files exist and what each one currently does
- Which ACs from the issue's `## Acceptance Criteria` section are already implemented and how
- Which TDD contracts (API routes, request/response shapes, data model fields, component props) are already in place
- For each delta item identified in C1 — whether it requires **adding** new code, **modifying** existing code, or **removing** existing code, and which specific files are affected

This map is passed verbatim to subagents in C3 so they can target the delta precisely without re-exploring the codebase.

### C3 — Dispatch to Skill Subagent

Inspect the latest TL annotation for the current `skill:` label(s). Invoke matching subagent(s).

**If the skill label is missing or unrecognised:** Stop and report: "No skill label found on ticket — run `/tl` to annotate the story first."

Pass the following context to every subagent. **All context is passed directly — do NOT instruct subagents to fetch issues, read project files, or re-derive context:**

- **Requirements**: story description + delta to implement. Prepend every applicable notice — include all that apply:
  - If `story-updated`: "IMPORTANT: The story's acceptance criteria have been updated by the BA. Review the current ACs against the existing implementation map and decide what needs to be added, modified, or removed."
  - If `technical-updated`: "IMPORTANT: The technical solution has been updated. Review the updated Scope and Key Decisions below and revise the existing implementation to match — implement the delta only."
  - If `design-updated`: "IMPORTANT: The UI design has been updated. Review the Design Change section below and revise the existing UI implementation to match — implement the delta only."
- **Scope**: from the latest `## Technical Lead Annotation` comment (step 5 if `technical-updated`, otherwise the existing annotation)
- **Key decisions**: from the latest `## Technical Lead Annotation` comment
- **Architecture context**: relevant TDD sections verbatim from the re-read TDD in C1 step 2
- **Design instructions**: if `design-updated`, use the updated design instructions from C1 step 4 (full issue including `## Change Description` block); otherwise use the original from C1 step 3 — always pass the full sprint-level document, not a story slice
- **Existing implementation**: the implementation map from C2 — what is already on the branch, keyed to ACs and TDD contracts, with explicit add/modify/remove guidance per delta item
- **Existing branch**: branch name from C1 step 6 — all changes must be committed to this branch
- **Codebase config**: root path, test command, lint/build command (from project config)

| Skill label | Subagent(s) | Execution |
|-------------|-------------|-----------|
| `skill:backend` only | `backend` | single |
| `skill:frontend` only | `frontend` | single |
| `skill:devops` only | `devops` | single |
| `skill:backend` + `skill:frontend` | `backend` + `frontend` | **parallel** |

If any subagent reports a blocker, `post_comment(ISSUE_NUMBER)` with the blocker and halt.

### C4 — Mark ACs, Commit and Push

Once all subagents complete, update the issue body — rewrite every `- [ ]` item in the `## Acceptance Criteria` section that was part of this delta as `- [x]`. Leave already-checked `- [x]` items untouched. Use `update_issue_body(ISSUE_NUMBER, updated_body)` from the tracker adapter.

Then commit inside each codebase path to the story branch (existing or newly created in C2):

```
cd <codebase-path>
git add <changed files reported by subagent>
git commit -m "feat(#<ISSUE_NUMBER>): <imperative-tense description of the delta>"
git push origin <story-branch>
```

Multi-skill: run independently in each codebase path. Only stage files changed as part of this delta.

### C5 — Update or Open PR and Update Labels

The action depends on whether the original PR was merged (determined in C2):

**PR not merged** — append a `## Change Applied` section to the existing PR body using `update_pr(pr_number, body)` from the tracker adapter:

```
## Change Applied

Labels: <list of update labels that triggered this change>

Delta:
- <one-line summary of what was added, revised, or removed>
```

**PR merged** — open a new PR using `create_pr(title, body, head: <new-story-branch>, base: <sprint-branch>)`. Use the same PR title and body format as S5, appending a `## Change Applied` block at the end of the body:

```
## Change Applied

Labels: <list of update labels that triggered this change>

Delta:
- <one-line summary of what was added, revised, or removed>
```

`update_labels(ISSUE_NUMBER, add: [implemented], remove: [in-progress])` from the tracker adapter.

---

## Constraints

- Implement strictly within the scope of the ACs — no extras, no refactors beyond what the ticket requires
- Do not merge any PR — merging is a human action
- If a blocker is found, comment on the issue and stop — do not guess
- Standard Mode PRs target the sprint feature branch
- Change Mode with an **unmerged PR**: commits to the existing branch and appends to the existing PR — no new branch or PR
- Change Mode with a **merged PR**: creates a new branch from the sprint branch and opens a new PR — the original PR is already closed
