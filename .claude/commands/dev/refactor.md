# Mode: Change

The story already has an implementation (open or merged PR). Implement the delta only — do not re-implement what is already on the branch.

---

## C1 — Gather Story Context in Parallel

1. **Issue body + comments** — the ticket already fetched in Step 1 (hold it)

2. **TDD** — `list_issues(milestone_id, labels: [technical-design label from project config])` to find it, then `fetch_issue(tdd_number)` to read full content. Extract:
   - Problem statement
   - Proposed solution
   - Architecture key decisions
   - Components design
   - API specification
   - Data models
   - Risks
   - Implementation priority

3. **Design Instructions** (frontend only) — `list_issues(milestone_id, labels: [design-reviewed])` to find the design instructions issue. `fetch_issue` it in full — the document covers the entire sprint's UI design.

---

## C2 — Git Setup

For each codebase / skill in scope, discover the existing PR state:

Use `list_prs(repo, "open", "feature/issue-<N>-")` from the tracker adapter.

- **Open PR found** — check out the existing branch. Hold PR number for C3:
  ```bash
  git fetch origin
  git checkout <existing-branch> && git pull
  ```

- **No open PR** — use `list_prs(repo, "closed", "feature/issue-<N>-")` and filter client-side for `merged: true`. Hold the PR number for C3. Use `get_pr(repo, pr_number)` to get the `mergeCommitSha`. Then create a new branch (follow the branch naming strategy):
  ```bash
  git fetch origin
  git checkout <sprint-branch> && git pull
  git checkout -b <story-branch>
  git push -u origin <story-branch>
  ```
  If the sprint branch does not exist, halt: "Sprint feature branch `<sprint-branch>` not found in `<codebase-path>`."

For multi-skill stories, run setup independently in each codebase path.

---

## C3 — Diff Analysis

For each PR found in C2 (open or merged), fetch its diff and body:

**Open PR:**
Use `get_pr(repo, pr_number)` to read the PR body and `files[]` (each entry includes `filename`, `status`, and `patch` with the line-level diff).

**Merged PR:**
Use `get_pr(repo, pr_number)` to read the PR body, `mergeCommitSha`, and `files[]`.

Produce a **delta summary**:

| Section | Content |
|---------|---------|
| Already implemented | ACs satisfied on the current branch (from PR body `## Acceptance Criteria` section) |
| New / changed ACs | ACs in the updated story not yet satisfied or differing from the branch |
| Removed ACs | ACs present in the original PR body that no longer appear in the updated story |
| Affected files | Files already touched in the PR diff — subagents must not duplicate this work |

Hold this delta summary — it is passed to every subagent in C4.

---

## C4 — Dispatch to Skill Subagent

-> Follow `_dispatch-subagent.md`

In addition to the standard context table, pass the following to every subagent:

| Extra context | Source |
|---------------|--------|
| Delta summary | Produced in C3 |
| Affected files | From `get_pr` `files[].filename` |
| Instruction | "Implement the delta only. Do not re-implement ACs already satisfied. Do not modify already-correct files unless an AC explicitly requires a change." |

---

## C5 — Commit and Push

Once all subagents complete:

-> Follow `_commit-push.md`

Push to the existing story branch (checked out in C2). Commit message:

```
feat(#<ISSUE_NUMBER>): update <short description> per story change
```

---

## C6 — Open or Update PR

**Open PR case** — no PR action needed. Skip to end.

**Merged PR case** — open a new PR targeting the sprint branch via `create_pr(title, body, head, base)`:
- **Title**: `feat(#<N>): <short description> (change)`
- **Head**: `<new story branch from C2>`
- **Base**: `<sprint-branch>`
- **Body**: Use `render_template("pr-story", {summary, changes, test_command, lint_command, manual_verification, acceptance_criteria, closes})`, noting this is a change update and referencing the original merged PR

For multi-skill stories, update or open each PR independently.

---

## C7 — Notify

**Merged PR case only** — follow `_notify-complete.md`.

**Open PR case** — skip this step.
