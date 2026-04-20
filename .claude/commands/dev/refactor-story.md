# Mode: Change

The story already has an implementation (open or merged PR). Implement the delta only — do not re-implement what is already on the branch.

---

## C1 — Gather All Story Context in Parallel

-> Follow `_gather-context.md`

---

## C2 — Git Setup

For each codebase / skill in scope, discover the existing PR state:

```bash
gh pr list --repo <repo> --head "feature/issue-<N>-*" --state open --json number,headRefName
```

- **Open PR found** — check out the existing branch. Hold PR number for C3:
  ```bash
  git fetch origin
  git checkout <existing-branch> && git pull
  ```

- **No open PR** — find the merged PR, hold its number and `mergeCommit` SHA for C3, then create a new branch (follow the branch naming strategy).
  ```bash
  gh pr list --repo <repo> --head "feature/issue-<N>-*" --state merged --json number,headRefName,mergeCommit
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
```bash
gh pr diff <pr-number>
gh pr view <pr-number> --json body
```

**Merged PR:**
```bash
gh pr diff <pr-number>
gh pr view <pr-number> --json body,mergeCommit
# Or diff via the merge commit directly:
git show <merge-commit-sha> --stat
```

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
| Affected files | From `gh pr diff` file list |
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
- **Body**: Use `pr-story.md`, noting this is a change update and referencing the original merged PR

For multi-skill stories, update or open each PR independently.

---

## C7 — Notify

**Merged PR case only** — follow `_notify-complete.md`.

**Open PR case** — skip this step.
