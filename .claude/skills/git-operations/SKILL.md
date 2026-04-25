---
name: git-operations
description: Git and PR operations — create/checkout/commit branches; open, read, update, list, and delete pull requests; list and diff remote branches.
tools: Bash, mcp__github__pull_request_read, mcp__github__create_pull_request, mcp__github__list_pull_requests,
  mcp__github__list_branches
---

# Git Operations

All operations run inside the relevant codebase path. The caller `cd`s to the correct path before invoking.

The **repo** value for PR operations comes from the project's CLAUDE.md or equivalent project config (owner and repo name for the issue tracker).

---

## Branch Operations

### `create_branch(branch_name, from_branch)`
Create a new branch from a base branch and push it to origin.
```bash
git checkout {from_branch}
git pull
git checkout -b {branch_name}
git push -u origin {branch_name}
```

### `checkout_branch(branch_name)`
Switch to an existing branch and pull the latest.
```bash
git checkout {branch_name}
git pull
```

### `commit_and_push(branch_name, files, message)`
Stage specific files, commit, and push to origin.
```bash
git add {files}
git commit -m "{message}"
git push origin {branch_name}
```

---

## PR Operations

### `fetch_pr(id, repo?)`
Read a pull request in full (title, body, changed files, linked issues, diff).
- **Tool**: `mcp__github__pull_request_read` with `{ owner, repo, pullNumber: id }`
- `repo` is optional — omit to use the current codebase repo, supply `owner/repo-name` for cross-repo lookups
- Also read file list and diff via `gh pr diff {id}`
- Returns: PR metadata (including `merged` boolean — `true` if merged, `false` if open or closed unmerged), head branch name, changed files, body (extract "Closes #N" to get linked issue)

### `create_pr(title, body, head, base)`
Open a pull request.
- **Tool**: `mcp__github__create_pull_request` with `{ owner, repo, title, body, head, base }`
- Returns: PR number

### `update_pr(pr_id, body)`
Replace the body of an existing pull request.
- **CLI**: `gh pr edit {pr_id} --body "{body}"`
- Always `fetch_pr` first to obtain the current body, then append or modify before calling this

### `submit_review(pr_id, verdict, body)`
Submit a formal code review on a PR.
- Verdict is `"APPROVE"` or `"REQUEST_CHANGES"`
- **CLI**: `gh pr review {pr_id} --approve --body "{body}"` / `gh pr review {pr_id} --request-changes --body "{body}"`

### `post_pr_comment(pr_id, body)`
Post a plain comment on a pull request.
- **Tool**: `mcp__github__add_issue_comment` with `{ owner, repo, issue_number: pr_id, body }`

### `list_prs(repo, state, head_prefix?)`
List pull requests, optionally filtered by head branch prefix.
- **Tool**: `mcp__github__list_pull_requests` with `{ owner, repo, state }`, then filter client-side by `headRefName.startsWith(head_prefix)` if prefix provided
- `repo` is the codebase repo slug (e.g. `owner/repo-name`)
- `state`: `"open"` | `"closed"` | `"all"`. For merged-only, pass `"closed"` and filter client-side by `merged: true`
- Returns: array of `{number, title, url, headRefName, state, merged}`

### `list_branches(repo, pattern?)`
List remote branches, optionally filtered by name prefix.
- **Tool**: `mcp__github__list_branches` with `{ owner, repo }`
- `repo` is the codebase repo slug
- Filter results client-side by `pattern` if provided
- Returns: array of branch names

### `delete_branch(repo, branch)`
Delete a branch from the remote.
- **CLI**: `git push origin --delete {branch}` (run from within the codebase path)
- *(No delete-branch MCP tool exists — CLI is the only path)*
- If branch no longer exists on remote, skip silently ("remote ref does not exist" = OK)

### `diff_branches_files(repo, base, head)`
List files changed (added or modified) between two branches.
- **CLI**: `gh api repos/{owner}/{repo}/compare/{base}...{head} --jq '[.files[].filename]'`
- `repo` is the codebase repo slug
- *(No compare-branches MCP tool exists — `gh api` is the only path)*
- Returns: array of file paths
