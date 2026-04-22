---
name: github-tracker
description: GitHub tracker adapter — maps abstract workflow operations to GitHub MCP tools and CLI. Swap this file (and update project.md) to use a different tracker.
---

# Tracker Adapter: GitHub

This file defines how each abstract workflow operation maps to GitHub-specific actions. Commands read this adapter (via project config) and use the operation definitions below — they never call GitHub tools directly.

The **repo** value for all operations comes from `.claude/project.md` (Issue Tracker → Repo).

---

## Confirmation Protocol

Before executing any **mutating** operation (or a planned sequence of them), you must:

1. **Summarize** all planned mutations in a single block — operation type, target, and key parameters
2. **Ask the user once**: `"Proceed with these actions? (y/n)"`
3. **Proceed only if confirmed.** If denied, stop and report what was skipped.

Group related mutations into one confirmation (e.g. create milestone + stories + label = one prompt, not N prompts).

**Read-only — no confirmation needed**: `fetch_issue`, `list_issues`, `list_milestones`, `gh pr list`, any `gh api` read.

**Mutating — always confirm**: `create_issue`, `create_milestone`, `create_pr`, `update_issue_body`, `update_labels`, `post_comment`, `gh issue close`, `git push origin --delete`.

**Example confirmation block:**
```
## Planned Tracker Actions

1. create_milestone("Sprint 4", "User can log in")
2. create_issue("[Story] Log in with email", labels: user-story, milestone: Sprint 4)
3. create_issue("[Story] Log out", labels: user-story, milestone: Sprint 4)
4. update_labels(#12, add: sprint-ready)

Proceed with these actions? (y/n)
```

---

## Operations

### `link_to(id)`
Return an inline issue reference that renders as a clickable link in this tracker.
- **Format**: `#id` (e.g. `#17`)
- Use this format anywhere a story or issue needs to be referenced in issue bodies or comments

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

### `update_issue_body(issue_id, body)`
Replace the body of an existing issue with updated content.
- **Tool**: `mcp__github__issue_write` with `{ owner, repo, issue_number: issue_id, body }`
- Always `fetch_issue` first to obtain the current body, then append or modify before calling this

### `update_labels(issue_id, add, remove)`
Add and/or remove labels on an issue.
- **Tool**: `mcp__github__issue_write` with `{ owner, repo, issue_number: issue_id, labels: <current labels + add - remove> }`
- Read current labels first with `fetch_issue` to avoid overwriting
- **Rule**: If `remove` is empty (`[]`, `[""]`, or omitted), skip removal — keep all current labels untouched

### `post_comment(issue_id, body)`
Post a comment on an issue.
- **Tool**: `mcp__github__add_issue_comment` with `{ owner, repo, issue_number: issue_id, body }`

### `update_comment(comment_id, body)`
Update the body of an existing comment.
- **CLI**: `gh api repos/{owner}/{repo}/issues/comments/{comment_id} --method PATCH -f body="{body}"`
- Use when revising an existing annotation or summary in-place rather than appending a new comment

### `create_milestone(title, description)`
Create a new sprint milestone.
- **Tool**: `mcp__github__issue_write` or `gh api repos/{owner}/{repo}/milestones -f title="{title}" -f description="{description}"`
- Fallback: `gh api repos/{owner}/{repo}/milestones --method POST -f title="{title}" -f description="{description}"`
- Returns: milestone id (number)

### `list_milestones()`
List all existing milestones to determine the next sprint number.
- **CLI**: `gh api repos/{owner}/{repo}/milestones --jq '.[].title'`
- Returns: list of milestone titles

### `list_open_issues(labels)`
List open issues filtered by one or more labels, without requiring a milestone.
- **Tool**: `mcp__github__list_issues` with `{ owner, repo, state: "open", labels }`
- Returns: array of `{number, title, labels}`

### `get_pr(repo, pr_number)`
Read a pull request in full (body, head/base refs, merge commit SHA, changed files).
- **Tool**: `mcp__github__pull_request_read` with `{ owner, repo, pullNumber: pr_number }`
- `repo` is the codebase repo slug (e.g. `simpscal/notism-api`)
- Returns: `{number, title, body, state, merged, mergeCommitSha, headRefName, baseRefName, files[{filename, status, additions, deletions, patch}]}`

### `list_milestones_detail()`
List milestones with number, title, and open issue count.
- **CLI**: `gh api repos/{owner}/{repo}/milestones --jq '[.[] | {number: .number, title: .title, open_issues: .open_issues}]'`
- *(No GitHub MCP tool for milestones — CLI is the only path)*
- Returns: array of `{number, title, open_issues}`

### `close_issue(issue_id)`
Close an issue.
- **Tool**: `mcp__github__update_issue` with `{ owner, repo, issue_number: issue_id, state: "closed" }`

### `create_pr(title, body, head, base)`
Create a pull request.
- **Tool**: `mcp__github__create_pull_request` with `{ owner, repo, title, body, head, base }`
- Returns: PR number and URL

### `list_prs(repo, state, head_prefix?)`
List pull requests, optionally filtered by head branch prefix.
- **Tool**: `mcp__github__list_pull_requests` with `{ owner, repo, state }`, then filter client-side by `headRefName.startsWith(head_prefix)` if prefix provided
- `repo` is the codebase repo slug (e.g. `simpscal/notism-api`), not the issue tracker repo
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
