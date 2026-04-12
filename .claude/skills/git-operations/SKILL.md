---
name: git-operations
description: Git and PR operations — create/checkout/commit branches and open/read/update pull requests.
tools: Bash
---

# Git Operations

All operations run inside the relevant codebase path. The caller `cd`s to the correct path before invoking.

The **repo** value for PR operations comes from `.claude/project.md` (Issue Tracker → Repo).

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

### `fetch_pr(id)`
Read a pull request in full (title, body, changed files, linked issues, diff).
- **Tool**: `mcp__github__pull_request_read` with `{ owner, repo, pullNumber: id }`
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
