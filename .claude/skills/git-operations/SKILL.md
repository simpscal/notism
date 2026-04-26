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

### `create_branch(branch_name, from_branch)`
```bash
git checkout {from_branch}
git pull
git checkout -b {branch_name}
git push -u origin {branch_name}
```

### `checkout_branch(branch_name)`
```bash
git checkout {branch_name}
git pull
```

### `commit_and_push(branch_name, files, message)`
```bash
git add {files}
git commit -m "{message}"
git push origin {branch_name}
```

---

## PR Operations

### `fetch_pr(id, repo?)`
- **Tool**: `mcp__github__pull_request_read` → `{ owner, repo, pullNumber: id }`
- Also run: `gh pr diff {id}` for file list and diff
- `repo` optional — omit for current codebase, supply `owner/repo-name` for cross-repo
- Returns: title, body, head branch, changed files, `merged` boolean, linked issue (`Closes #N`)

### `create_pr(title, body, head, base)`
- **Tool**: `mcp__github__create_pull_request` → `{ owner, repo, title, body, head, base }`
- Returns: PR number

### `update_pr(pr_id, body)`
- **CLI**: `gh pr edit {pr_id} --body "{body}"`
- Always `fetch_pr` first — modify, then write

### `submit_review(pr_id, verdict, body)`
- `verdict`: `"APPROVE"` or `"REQUEST_CHANGES"`
- **CLI**: `gh pr review {pr_id} --approve --body "{body}"` / `gh pr review {pr_id} --request-changes --body "{body}"`

### `post_pr_comment(pr_id, body)`
- **Tool**: `mcp__github__add_issue_comment` → `{ owner, repo, issue_number: pr_id, body }`

### `list_prs(repo, state, head_prefix?)`
- **Tool**: `mcp__github__list_pull_requests` → `{ owner, repo, state }`
- `state`: `"open"` | `"closed"` | `"all"` — merged-only: pass `"closed"`, filter client-side by `merged: true`
- Filter client-side by `headRefName.startsWith(head_prefix)` if prefix provided
- Returns: `[{number, title, url, headRefName, state, merged}]`

### `list_branches(repo, pattern?)`
- **Tool**: `mcp__github__list_branches` → `{ owner, repo }`
- Filter client-side by `pattern` if provided
- Returns: array of branch names

### `delete_branch(repo, branch)`
- **CLI**: `git push origin --delete {branch}` (from codebase path)
- "remote ref does not exist" = skip silently

### `diff_branches_files(repo, base, head)`
- **CLI**: `gh api repos/{owner}/{repo}/compare/{base}...{head} --jq '[.files[].filename]'`
- Returns: array of file paths
