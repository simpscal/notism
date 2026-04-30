---
name: git
description: Git operations, branching strategy, and PR management. Branch naming, creation, checkout, commit, push, PR creation/review/deletion. Derive owner/repo via `gh repo view` from codebase directory — never hardcode.
tools: Bash, mcp__github__pull_request_read, mcp__github__create_pull_request, mcp__github__list_pull_requests, mcp__github__list_branches
---

# Git

**triggers:** create sprint branch, create story branch, create bug branch, create revert branch, create feature branch, branch name, name branch, create branch, checkout branch, switch branch, commit and push, create PR, open PR, delete branch, list branches, diff branches

Apply the strategy below whenever a branch needs to be created or selected.

---

## Repo Derivation

`owner`/`repo` derived via `gh repo view --json owner,name --jq '[.owner.login,.name]|join("/")'` from inside the codebase directory. Codebase paths come from CLAUDE.md Codebases table — never hardcode.

---

## Branch Patterns

| Context | Pattern |
|---------|---------|
| Main | `main` |
| Sprint | `feature/sprint-{N}` |
| Story (single-skill) | `feature/issue-{N}-{short-description}` |
| Story (multi-skill) | `feature/issue-{N}-{short-description}-backend` / `-frontend` |
| Revert (single-skill) | `revert/issue-{N}-{short-description}` |
| Revert (multi-skill) | `revert/issue-{N}-{short-description}-backend` / `-frontend` |
| Bugfix (single-skill) | `fix/issue-{N}-{short-description}` |
| Bugfix (multi-skill) | `fix/issue-{N}-{short-description}-backend` / `-frontend` |

`short-description` derivation:
1. Strip leading `[Tag]` prefix
2. Lowercase; replace spaces/special chars with hyphens
3. Remove stop words: a, an, the, and, or, for, to, of, in, on, at, by, with, when, then
4. Keep first 4 remaining words; trim trailing hyphens

Example: `[Story] Display toast notification when payment fails` → `display-toast-notification-payment`

**Branch Collision Handling:** If derived name exists on remote, append `-2`, `-3`, etc. until unique.

---

## Branch Operations

### Create Sprint Branch
**triggers:** create sprint branch
**when:** need a sprint branch for a new sprint
```bash
git checkout main && git pull
git checkout -b feature/sprint-{N}
git push -u origin feature/sprint-{N}
```

### Create Story Branch (single-skill)
**triggers:** create story branch, create feature branch
**when:** need a story branch for an issue
```bash
git checkout feature/sprint-{N}
git pull
git checkout -b feature/issue-{N}-{short-description}
git push -u origin feature/issue-{N}-{short-description}
```

### Create Story Branch (multi-skill)
**triggers:** create story branch backend, create story branch frontend
**when:** need separate backend/frontend branches
```bash
git checkout feature/sprint-{N}
git pull
git checkout -b feature/issue-{N}-{short-description}-{skill}
git push -u origin feature/issue-{N}-{short-description}-{skill}
```

### Create Bug Branch
**triggers:** create bug branch
**when:** need a bugfix branch
```bash
git checkout main && git pull
git checkout -b fix/issue-{N}-{short-description}
git push -u origin fix/issue-{N}-{short-description}
```

### Create Revert Branch
**triggers:** create revert branch
**when:** need a revert branch
```bash
git checkout main && git pull
git checkout -b revert/issue-{N}-{short-description}
git push -u origin revert/issue-{N}-{short-description}
```

### Checkout Sprint Branch
**triggers:** checkout sprint branch, switch to sprint branch, go to sprint branch
**when:** need to switch to the sprint branch for a given sprint number N

Apply the Sprint branch pattern with N to derive the branch name, then checkout that branch and pull latest.

### Checkout Branch
**triggers:** checkout branch, switch to branch, go to branch
**when:** need to move to an existing branch
```bash
git checkout {branch_name}
git pull
```

### Check Branch Exists
**triggers:** branch exists, does branch exist, verify branch, sprint branch exists
**when:** need to confirm a branch is on the remote
- **Tool**: `mcp__github__list_branches` → `{ owner, repo }`
- Filter client-side: exact match on `branch_name`
- Returns: `true` if found, `false` if not

### Commit and Push
**triggers:** commit and push, commit files, save and push, push my changes
**when:** user wants to commit files and push
```bash
git add {files}
git commit -m "{message}"
git push origin {branch_name}
```

### Delete Branch
**triggers:** delete branch, remove branch, clean up branch
**when:** user wants to delete a remote branch
```bash
git push origin --delete {branch}
```
"remote ref does not exist" = skip silently.

---

## PR Operations

### Create PR
**triggers:** create PR, open a PR, raise PR, submit PR, open pull request
**when:** user wants to open a pull request
- **Tool**: `mcp__github__create_pull_request` → `{ owner, repo, title, body, head, base }`
- Returns: PR number

### Fetch PR
**triggers:** show PR, view PR, get PR, look at PR, read PR
**when:** user wants details of a specific pull request
- **Tool**: `mcp__github__pull_request_read` → `{ owner, repo, pullNumber: id }`
- Also run: `gh pr diff {id}` for file list and diff
- Returns: title, body, head branch, changed files, `merged` boolean, `Closes #N`

### List PRs
**triggers:** list PRs, show PRs, find PRs, open PRs, closed PRs, merged PRs
**when:** user wants to list pull requests
- **Tool**: `mcp__github__list_pull_requests` → `{ owner, repo, state }`
- `state`: `"open"` | `"closed"` | `"all"` — for merged-only: pass `"closed"`, filter by `merged: true`
- Returns: `[{number, title, url, headRefName, state, merged}]`

### Submit Review
**triggers:** approve PR, LGTM, request changes, review PR, submit review
**when:** user wants to approve or request changes on a pull request
- **CLI**: `gh pr review {pr_id} --approve --body "{body}"` or `gh pr review {pr_id} --request-changes --body "{body}"`

### Delete Branch (remote)
**triggers:** delete branch, remove branch
**when:** user wants to delete a remote branch
- **CLI**: `git push origin --delete {branch}` (from codebase path)
- "remote ref does not exist" = skip silently

### Diff Branch Files
**triggers:** diff branches, compare branches, files changed between
**when:** user wants to see which files differ between two branches
- **CLI**: `gh api repos/{owner}/{repo}/compare/{base}...{head} --jq '[.files[].filename]'`
- Returns: array of file paths
