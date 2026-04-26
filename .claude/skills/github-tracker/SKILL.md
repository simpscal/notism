---
name: github-tracker
description: >
  GitHub issue tracker library — create, read, update issues; post comments; create/list milestones;
  manage labels; close issues. Never hardcode repo slugs, label names, or branch patterns.
tools: mcp__github__issue_read, mcp__github__list_issues, mcp__github__issue_write,
  mcp__github__add_issue_comment, mcp__github__update_issue, Bash
---

## Confirmation Protocol

Before any mutating operation:
1. Summarise all planned mutations in one block
2. Ask once: `"Proceed? (y/n)"` — group related mutations into a single prompt
3. Proceed only if confirmed; stop and report if denied

**No confirmation needed**: `fetch_issue`, `list_issues`, `list_milestones`, any read-only `gh api`

**Always confirm**: `create_issue`, `create_milestone`, `update_issue_body`, `update_labels`, `post_comment`, `gh issue close`

**Example:**
```
## Planned Tracker Actions

1. create_milestone("Sprint 4", "User can log in")
2. create_issue("[Story] Log in with email", labels: user-story, milestone: Sprint 4)
3. create_issue("[Story] Log out", labels: user-story, milestone: Sprint 4)
4. update_labels(#12, add: sprint-ready)

Proceed? (y/n)
```

---

## Operations

### `link_to(id)`
- Format: `#id` (e.g. `#17`) — use in issue bodies and comments

### `fetch_issue(id)`
- **Tool**: `mcp__github__issue_read` → `{ owner, repo, issue_number: id }`
- Returns: title, body, labels, milestone, comments

### `list_issues(milestone_id, labels?)`
- **Tool**: `mcp__github__list_issues` → `{ owner, repo, milestone: milestone_id, labels, state: "open" }`
- Multiple labels: call once per label, intersect results
- Returns: `[{id, title, labels, assignees}]`

### `create_issue(title, body, labels, milestone_id?)`
- **Tool**: `mcp__github__issue_write` → `{ owner, repo, title, body, labels, milestone: milestone_id }`
- Returns: new issue number

### `update_issue_body(issue_id, body)`
- **Tool**: `mcp__github__issue_write` → `{ owner, repo, issue_number: issue_id, body }`
- Always `fetch_issue` first — modify, then write

### `update_labels(issue_id, add, remove)`
- **Tool**: `mcp__github__issue_write` → `{ owner, repo, issue_number: issue_id, labels: <current + add - remove> }`
- `fetch_issue` first to get current labels
- If `remove` is empty or omitted — skip removal, keep all current labels

### `post_comment(issue_id, body)`
- **Tool**: `mcp__github__add_issue_comment` → `{ owner, repo, issue_number: issue_id, body }`

### `update_comment(comment_id, body)`
- **CLI**: `gh api repos/{owner}/{repo}/issues/comments/{comment_id} --method PATCH -f body="{body}"`

### `create_milestone(title, description)`
- **CLI**: `gh api repos/{owner}/{repo}/milestones --method POST -f title="{title}" -f description="{description}"`
- Returns: milestone id

### `list_milestones()`
- **CLI**: `gh api repos/{owner}/{repo}/milestones --jq '.[].title'`
- Returns: list of milestone titles

### `list_milestones_detail()`
- **CLI**: `gh api repos/{owner}/{repo}/milestones --jq '[.[] | {number: .number, title: .title, open_issues: .open_issues}]'`
- Returns: `[{number, title, open_issues}]`

### `list_open_issues(labels)`
- **Tool**: `mcp__github__list_issues` → `{ owner, repo, state: "open", labels }`
- Returns: `[{number, title, labels}]`

### `close_issue(issue_id)`
- **Tool**: `mcp__github__update_issue` → `{ owner, repo, issue_number: issue_id, state: "closed" }`
