---
name: git-operations
description: Git and PR operations — create/checkout/commit branches; open, read, update, list, and delete pull requests; list and diff remote branches.
tools: Bash, mcp__github__pull_request_read, mcp__github__create_pull_request, mcp__github__list_pull_requests,
  mcp__github__list_branches
---

# Git Operations

- All operations run inside the relevant codebase path
- `owner`/`repo` come from project config — never hardcode

---

## Branch Operations

### Create Branch
**triggers:** create branch, new branch, make a branch, branch off, start a branch, set up a branch, checkout -b
**when:** user wants to create a new git branch from an existing one
```bash
git checkout {from_branch}
git pull
git checkout -b {branch_name}
git push -u origin {branch_name}
```

### Checkout Branch
**triggers:** switch to branch, checkout branch, go to branch, move to branch, change branch, switch branch
**when:** user wants to move to an existing branch
```bash
git checkout {branch_name}
git pull
```

### Commit and Push
**triggers:** commit and push, commit files, save and push, push my changes, commit changes, stage and commit
**when:** user wants to commit specific files and push to remote
```bash
git add {files}
git commit -m "{message}"
git push origin {branch_name}
```

---

## PR Operations

### Fetch PR
**triggers:** show PR, view PR, get PR, look at PR, open PR, read PR, PR details, what is PR, describe PR
**when:** user wants to read the details of a specific pull request by number
- **Tool**: `mcp__github__pull_request_read` → `{ owner, repo, pullNumber: id }`
- Also run: `gh pr diff {id}` for file list and diff
- `repo` optional — omit for current codebase, supply `owner/repo-name` for cross-repo
- Returns: title, body, head branch, changed files, `merged` boolean, linked issue (`Closes #N`)

### Create PR
**triggers:** create PR, open a PR, raise PR, submit PR, make a pull request, open pull request, new PR
**when:** user wants to open a new pull request
- **Tool**: `mcp__github__create_pull_request` → `{ owner, repo, title, body, head, base }`
- Returns: PR number

### Update PR
**triggers:** update PR, edit PR, change PR description, modify PR body, rewrite PR, update pull request description
**when:** user wants to edit the body/description of an existing pull request
- **CLI**: `gh pr edit {pr_id} --body "{body}"`
- Always fetch the PR first — modify the existing body, then write

### Submit Review
**triggers:** approve PR, LGTM, request changes, review PR, submit review, reject PR, sign off PR
**when:** user wants to approve or request changes on a pull request
- `verdict`: `"APPROVE"` or `"REQUEST_CHANGES"`
- **CLI**: `gh pr review {pr_id} --approve --body "{body}"` / `gh pr review {pr_id} --request-changes --body "{body}"`

### Post PR Comment
**triggers:** comment on PR, add comment to PR, post to PR, leave a comment, reply on PR, write comment on PR
**when:** user wants to add a comment to a pull request
- **Tool**: `mcp__github__add_issue_comment` → `{ owner, repo, issue_number: pr_id, body }`

### List PRs
**triggers:** list PRs, show PRs, find PRs, all PRs, open PRs, closed PRs, merged PRs, what PRs exist
**when:** user wants to list pull requests filtered by state (open / closed / merged)
- **Tool**: `mcp__github__list_pull_requests` → `{ owner, repo, state }`
- `state`: `"open"` | `"closed"` | `"all"` — merged-only: pass `"closed"`, filter client-side by `merged: true`
- Filter client-side by `headRefName.startsWith(head_prefix)` if prefix provided
- Returns: `[{number, title, url, headRefName, state, merged}]`

### List Branches
**triggers:** list branches, show branches, what branches, all branches, remote branches, existing branches
**when:** user wants to see all remote branches, optionally filtered by a name prefix
- **Tool**: `mcp__github__list_branches` → `{ owner, repo }`
- Filter client-side by `pattern` if provided
- Returns: array of branch names

### Delete Branch
**triggers:** delete branch, remove branch, clean up branch, get rid of branch, drop branch
**when:** user wants to delete a remote branch
- **CLI**: `git push origin --delete {branch}` (from codebase path)
- "remote ref does not exist" = skip silently

### Diff Branch Files
**triggers:** diff branches, compare branches, files changed between, what changed between, changes from branch to branch, compare two branches
**when:** user wants to see which files differ between two branches
- **CLI**: `gh api repos/{owner}/{repo}/compare/{base}...{head} --jq '[.files[].filename]'`
- Returns: array of file paths
