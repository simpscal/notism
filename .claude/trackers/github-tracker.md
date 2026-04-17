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
