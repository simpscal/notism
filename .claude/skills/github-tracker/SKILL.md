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

**No confirmation needed**: read issue, list issues, list milestones — any read-only operation

**Always confirm**: create issue, create milestone, update issue body, update labels, post comment, close issue, update comment

**Example:**
```
## Planned Tracker Actions

1. Create milestone "Sprint 4" with description "User can log in"
2. Create issue "[Story] Log in with email" — labels: user-story, milestone: Sprint 4
3. Create issue "[Story] Log out" — labels: user-story, milestone: Sprint 4
4. Add label sprint-ready to issue #12

Proceed? (y/n)
```

---

## Operations

### Link Reference
**triggers:** reference issue, link to issue, mention issue
**when:** formatting an issue reference inside a body or comment
- Format: `#id` (e.g. `#17`) — use in issue bodies and comments

### Fetch Issue
**triggers:** read issue, get issue, fetch issue, show issue, look up issue
**when:** need the full content of a single issue — title, body, labels, milestone, comments
- **Tool**: `mcp__github__issue_read` → `{ owner, repo, issue_number: id }`
- Returns: title, body, labels, milestone, comments

### List Issues
**triggers:** list issues, find issues, get issues, issues in sprint, issues with label
**when:** need multiple issues filtered by milestone or label
- **Tool**: `mcp__github__list_issues` → `{ owner, repo, milestone: milestone_id, labels, state: "open" }`
- Multiple labels: call once per label, intersect results
- Returns: `[{id, title, labels, assignees}]`

### Create Issue
**triggers:** create issue, new issue, open issue, add issue
**when:** need to create a new GitHub issue
- **Tool**: `mcp__github__issue_write` → `{ owner, repo, title, body, labels, milestone: milestone_id }`
- Returns: new issue number

### Update Issue Body
**triggers:** update issue, edit issue body, rewrite issue body, modify issue content
**when:** need to change the body/content of an existing issue
- **Tool**: `mcp__github__issue_write` → `{ owner, repo, issue_number: issue_id, body }`
- Always read the issue first — modify, then write

### Update Labels
**triggers:** add label, remove label, update labels, change labels, label issue
**when:** need to add or remove labels on an issue
- **Tool**: `mcp__github__issue_write` → `{ owner, repo, issue_number: issue_id, labels: <current + add - remove> }`
- Read the issue first to get current labels
- If `remove` is empty or omitted — skip removal, keep all current labels

### Post Comment
**triggers:** post comment, add comment, comment on issue, leave a comment
**when:** need to add a new comment to an issue
- **Tool**: `mcp__github__add_issue_comment` → `{ owner, repo, issue_number: issue_id, body }`

### Update Comment
**triggers:** update comment, edit comment, modify comment
**when:** need to edit an existing comment by its comment ID
- **CLI**: `gh api repos/{owner}/{repo}/issues/comments/{comment_id} --method PATCH -f body="{body}"`

### Create Milestone
**triggers:** create milestone, new milestone, add milestone, set up sprint milestone
**when:** need to create a new sprint or milestone
- **CLI**: `gh api repos/{owner}/{repo}/milestones --method POST -f title="{title}" -f description="{description}"`
- Returns: milestone id

### List Milestones
**triggers:** list milestones, show milestones, get milestones, what milestones exist
**when:** need the titles of all milestones to find a matching sprint
- **CLI**: `gh api repos/{owner}/{repo}/milestones --jq '.[].title'`
- Returns: list of milestone titles

### List Milestones Detail
**triggers:** list milestones with details, milestone details, milestone counts, milestone IDs
**when:** need milestone numbers and open issue counts, not just titles
- **CLI**: `gh api repos/{owner}/{repo}/milestones --jq '[.[] | {number: .number, title: .title, open_issues: .open_issues}]'`
- Returns: `[{number, title, open_issues}]`

### List Open Issues
**triggers:** list open issues, find open issues, open bugs, open stories, issues by label
**when:** need all open issues filtered by label regardless of milestone
- **Tool**: `mcp__github__list_issues` → `{ owner, repo, state: "open", labels }`
- Returns: `[{number, title, labels}]`

### Close Issue
**triggers:** close issue, mark issue closed, resolve issue, shut issue
**when:** need to close or resolve a GitHub issue
- **Tool**: `mcp__github__update_issue` → `{ owner, repo, issue_number: issue_id, state: "closed" }`
