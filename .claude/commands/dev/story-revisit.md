# Mode: Change

The story already has an implementation (open or merged PR). Implement the delta only — do not re-implement what is already on the branch.

---

## Step 1 — Gather Story Context in Parallel

1. **Issue body + comments** — the ticket already fetched in Step 1 (hold it)

2. **TDD** — list issues labeled `technical-design` in the milestone to find it, then read the TDD issue in full. Extract:
   - Problem statement
   - Proposed solution
   - Architecture key decisions
   - Components design
   - API specification
   - Data models
   - Risks
   - Implementation priority

3. **Design Instructions** (frontend only) — list issues labeled `design` in the milestone to find the design instructions issue. Read it in full — the document covers the entire sprint's UI design.

---

## Step 2 — Git Setup

For each codebase / skill in scope, discover the existing PR state:

List open pull requests with branch prefix `feature/issue-<N>-` from the tracker adapter.

- **Open PR found** — hold PR number for Step 3. Switch to the existing branch.

- **No open PR** — list closed pull requests with branch prefix `feature/issue-<N>-` and filter client-side for `merged: true`. Hold the PR number for Step 3. Fetch that pull request to get the `mergeCommitSha`. Then:
  - Branch name: apply the git-strategy skill's **Story** pattern
  - If the sprint branch does not exist, halt: "Sprint feature branch `<sprint-branch>` not found in `<codebase-path>`."
  - Create a new branch named `{branch_name}` from `{sprint_branch}`

For multi-skill stories, run setup independently in each codebase path.

---

## Step 3 — Diff Analysis

For each PR found in Step 2 (open or merged), fetch its diff and body:

**Open PR:**
Fetch the pull request to read the PR body and `files[]` (each entry includes `filename`, `status`, and `patch` with the line-level diff).

**Merged PR:**
Fetch the pull request to read the PR body, `mergeCommitSha`, and `files[]`.

Produce a **delta summary**:

| Section | Content |
|---------|---------|
| Already implemented | ACs satisfied on the current branch (from PR body `## Acceptance Criteria` section) |
| New / changed ACs | ACs in the updated story not yet satisfied or differing from the branch |
| Removed ACs | ACs present in the original PR body that no longer appear in the updated story |
| Affected files | Files already touched in the PR diff — subagents must not duplicate this work |

Hold this delta summary — it is passed to every subagent in Step 4.

---

## Step 4 — Dispatch to Skill Subagent

-> Follow `_dispatch-subagent.md`

In addition to the standard context table, pass the following to every subagent:

| Extra context | Source |
|---------------|--------|
| Delta summary | Produced in Step 3 |
| Affected files | From `get_pr` `files[].filename` |
| Instruction | "Implement the delta only. Do not re-implement ACs already satisfied. Do not modify already-correct files unless an AC explicitly requires a change." |

---

## Step 5 — Commit and Push

Once all subagents complete, commit and push in each codebase path using the files each subagent reported. Push to the existing story branch. Commit message: `feat(#<ISSUE_NUMBER>): update <short description> per story change`.

---

## Step 6 — Open or Update PR

**Open PR case** — no PR action needed. Skip to end.

**Merged PR case** — open a new pull request targeting the sprint branch:
- **Title**: `feat(#<N>): <short description> (change)`
- **Head**: `<new story branch from Step 2>`
- **Base**: `<sprint-branch>`
- **Body**: Render the `pr-story` template with `{summary, changes, test_command, lint_command, manual_verification, acceptance_criteria, closes}`, noting this is a change update and referencing the original merged PR

For multi-skill stories, update or open each PR independently.

---

## Step 7 — Remove Label

Remove the `story-updated` label from the issue.

---

## Step 8 — Notify

**Merged PR case only** — follow `_notify-complete.md`.

**Open PR case** — skip this step.
