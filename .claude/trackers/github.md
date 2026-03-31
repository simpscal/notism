---
name: github
description: GitHub tracker adapter — maps abstract workflow operations to GitHub MCP tools and CLI. Swap this file (and update project.md) to use a different tracker.
---

# Tracker Adapter: GitHub

This file defines how each abstract workflow operation maps to GitHub-specific actions. Commands read this adapter (via project config) and use the operation definitions below — they never call GitHub tools directly.

The **repo** value for all operations comes from `.claude/project.md` (Issue Tracker → Repo).

---

## Operations

### `fetch_issue(id)`
Read a single issue in full (title, body, labels, milestone, comments).
- **Tool**: `mcp__github__issue_read` with `{ owner, repo, issue_number: id }`
- Returns: title, body, labels, milestone, all comments

### `list_issues(milestone_id, labels?)`
List issues in a milestone, optionally filtered by label(s).
- **Tool**: `mcp__github__list_issues` with `{ owner, repo, milestone: milestone_id, labels, state: "open" }`
- If filtering by multiple labels, call once per label and intersect results
- Returns: array of issues (id, title, labels, assignees)

### `create_issue(title, body, labels, milestone_id?)`
Create a new issue.
- **Tool**: `mcp__github__issue_write` with `{ owner, repo, title, body, labels, milestone: milestone_id }`
- Returns: new issue number

### `update_labels(issue_id, add, remove)`
Add and/or remove labels on an issue.
- **Tool**: `mcp__github__issue_write` with `{ owner, repo, issue_number: issue_id, labels: <current labels + add - remove> }`
- Read current labels first with `fetch_issue` to avoid overwriting

### `post_comment(issue_id, body)`
Post a comment on an issue.
- **Tool**: `mcp__github__add_issue_comment` with `{ owner, repo, issue_number: issue_id, body }`

### `create_milestone(title, description)`
Create a new sprint milestone.
- **Tool**: `mcp__github__issue_write` or `gh api repos/{owner}/{repo}/milestones -f title="{title}" -f description="{description}"`
- Fallback: `gh api repos/{owner}/{repo}/milestones --method POST -f title="{title}" -f description="{description}"`
- Returns: milestone id (number)

### `list_milestones()`
List all existing milestones to determine the next sprint number.
- **CLI**: `gh api repos/{owner}/{repo}/milestones --jq '.[].title'`
- Returns: list of milestone titles

### `fetch_pr(id)`
Read a pull request in full (title, body, changed files, linked issues, diff).
- **Tool**: `mcp__github__pull_request_read` with `{ owner, repo, pullNumber: id }`
- Also read file list and diff via `mcp__github__get_commit` or `gh pr diff {id}`
- Returns: PR metadata, changed files, body (extract "Closes #N" to get linked issue)

### `create_pr(title, body, head, base)`
Open a pull request.
- **Tool**: `mcp__github__create_pull_request` with `{ owner, repo, title, body, head, base }`
- Returns: PR number

### `submit_review(pr_id, verdict, body)`
Submit a formal code review on a PR.
- Verdict is `"APPROVE"` or `"REQUEST_CHANGES"`
- **Tool**: `mcp__github__pull_request_review_write` with method `"submit_pending"` and the verdict and body
- Or: `gh pr review {pr_id} --approve --body "{body}"` / `gh pr review {pr_id} --request-changes --body "{body}"`

### `post_pr_comment(pr_id, body)`
Post a comment on a pull request (not a review — just a regular comment).
- **Tool**: `mcp__github__add_issue_comment` with `{ owner, repo, issue_number: pr_id, body }`
- Note: GitHub treats PR comments and issue comments identically via this tool

---

## Git Operations

Used by the dev and TL commands for branch management. These are local git operations, not GitHub API calls.

### `create_branch(branch_name, from_branch)`
```bash
git checkout {from_branch}
git pull
git checkout -b {branch_name}
git push -u origin {branch_name}
```

### `create_story_branch(branch_name, from_branch)`
```bash
git checkout {from_branch}
git pull
git checkout -b {branch_name}
```

### `push_branch(branch_name)`
```bash
git push -u origin {branch_name}
```

---

## Switching to a Different Tracker

To replace GitHub with Jira or another tracker:

1. Create `.claude/trackers/jira.md` with the same operation names mapped to Jira's API/CLI
2. In `.claude/project.md`, update `Tracker adapter` to point to the new file
3. No changes to any command file are needed

The operation interface (names and semantics) is the contract — adapters implement it.
