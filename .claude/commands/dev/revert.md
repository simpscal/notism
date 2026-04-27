# Mode: Revert

The story's requirement was dropped. Existing implementation must be reversed. This mode creates revert PRs targeting the sprint branch — one per existing story PR.

---

## Step 1 — Find Existing Story PRs

For each codebase listed in the project config, search for PRs associated with this issue:

List all pull requests with branch prefix `feature/issue-<N>-` from the tracker adapter.

Collect all PRs found as `$STORY_PRS`.

If none found in any codebase: close issue `#ISSUE_NUMBER` and stop.

---

## Step 2 — Build Revert Branches

For each PR in `$STORY_PRS`, `cd` into the relevant codebase path:

- Base: sprint branch (the PR's `baseRefName`)
- Branch name: apply the git-strategy skill's **Revert** pattern
- If the sprint branch does not exist, halt: "Sprint feature branch `<sprint-branch>` not found in `<codebase-path>`."

-> Create a new branch named `{branch_name}` from `{sprint_branch}`

If the PR was **not merged** (`merged: false`): skip — code is not on the sprint branch. If all PRs in `$STORY_PRS` are unmerged, close issue `#ISSUE_NUMBER` and stop.

If the PR was **merged** (`merged: true`), get its merge commit SHA and revert it:

Fetch the pull request and read `mergeCommitSha`. Then:

```bash
git revert -m 1 <merge-commit-sha> --no-edit
```

Push the revert commit:

```bash
git push
```

For multi-skill stories, run independently in each codebase path.

---

## Step 3 — Open Revert PRs

For each revert branch created in Step 2, open a pull request:

- **Title**: `revert(#<N>): <story title>`
- **Head**: revert branch (from git-strategy **Revert** pattern)
- **Base**: `<sprint-branch>` (from original PR's `baseRefName`)
- **Body**: Render the `pr-revert` template with `{story_number, story_title, original_pr, merge_commit, test_command, lint_command}`

Collect all opened revert PR numbers as `$REVERT_PRS`.

---

## Step 4 — Notify

-> Follow `_notify-complete.md` (Revert stories variant)
