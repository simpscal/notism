# Mode: Revert

The story's requirement was dropped. Existing implementation must be reversed. This mode creates revert PRs targeting the sprint branch — one per existing story PR.

---

## Step 1 — Find Existing Story PRs

For each codebase, list story branches for issue `<N>` to find PRs associated with this issue.

Collect all PRs found as `$STORY_PRS`.

If none found in any codebase: close issue `#ISSUE_NUMBER` and stop.

---

## Step 2 — Build Revert Branches

For each PR in `$STORY_PRS`, create revert branch for issue `<N>` and story PR `<PR_NUMBER>` in the relevant codebase path.

For each merged PR, also:
- Get the `mergeCommitSha` and run `git revert -m 1 <merge-commit-sha> --no-edit`
- Push the revert commit

---

## Step 3 — Open Revert PRs

For each revert branch created in Step 2, open a pull request:

- **Title**: `revert(#<N>): <story title>`
- **Head**: revert branch (from git skill **Revert** pattern)
- **Base**: `<sprint-branch>` (from original PR's `baseRefName`)
- **Body**: Render the `pr-revert` template with `{story_number, story_title, original_pr, merge_commit, test_command, lint_command}`

Collect all opened revert PR numbers as `$REVERT_PRS`.

---

## Step 4 — Notify

-> Follow `_notify-complete.md` (Revert stories variant)
