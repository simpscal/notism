# Mode: Revert

The story's requirement was dropped. Existing implementation must be reversed. This mode creates revert PRs targeting the sprint branch — one per existing story PR.

---

## R1 — Find Existing Story PRs

For each codebase listed in the project config, search for PRs associated with this issue:

```bash
gh pr list --repo <repo> --head "feature/issue-<N>-*" --state all --json number,headRefName,state,merged,baseRefName
```

Collect all PRs found as `$STORY_PRS`.

If none found in any codebase: `post_comment(ISSUE_NUMBER, "No story PRs found for #<N>. Nothing to revert.")`, `update_labels(ISSUE_NUMBER, add: [], remove: [in-progress])`, and stop.

---

## R2 — Build Revert Branches

For each PR in `$STORY_PRS`, `cd` into the relevant codebase path:

Create the revert branch (follow the branch naming strategy) from the sprint branch (the PR's `baseRefName`):

```bash
git fetch origin
git checkout <sprint-branch> && git pull
git checkout -b <revert-branch>  # name from git-strategy Revert pattern
```

If the sprint branch does not exist, halt: "Sprint feature branch `<sprint-branch>` not found in `<codebase-path>`."

If the PR was **merged** (`merged: true`), get its merge commit SHA and revert it:

```bash
gh api repos/<repo>/pulls/<pr-number> --jq '.merge_commit_sha'
git revert -m 1 <merge-commit-sha> --no-edit
```

If the PR was **not merged** (`merged: false`): no revert commit needed — code is not on the sprint branch.

Push the revert branch:

```bash
git push -u origin <revert-branch>
```

For multi-skill stories, run independently in each codebase path.

---

## R3 — Open Revert PRs

For each revert branch created in R2, open a PR via `create_pr(title, body, head, base)`:

- **Title**: `revert(#<N>): <story title>`
- **Head**: `revert/issue-<N>-<slug>`
- **Base**: `<sprint-branch>` (from original PR's `baseRefName`)
- **Body**:

```
## Summary

Reverts the implementation of story #<N> — <story title>.

The story was removed from the requirement scope and the implementation must be undone.

## Reverts

- Original PR: #<original-pr-number>
- Merge commit: `<sha>` _(or "PR was not merged — no commits on sprint branch")_

## Acceptance Criteria

- [ ] All changes introduced by #<original-pr-number> are absent from the sprint branch after merge
- [ ] Tests pass: `<test command from project config>`
- [ ] Build passes: `<lint/build command from project config>`

Closes #<N>
```

Collect all opened revert PR numbers as `$REVERT_PRS`.

---

## R4 — Notify

-> Follow `_notify-complete.md` (Revert stories variant)
