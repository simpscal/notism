---
name: jira-tracker
description: Jira tracker adapter — maps abstract workflow operations to Atlassian MCP tools. Swap this file (and update project.md) to switch trackers.
---

# Tracker Adapter: Jira

This file defines how each abstract workflow operation maps to Atlassian MCP tool calls. Commands read this adapter (via project config) and use the operation definitions below — they never call Jira APIs directly.

Config values for all operations come from `.claude/project.md` (Issue Tracker section):
- **Base URL** → `$JIRA_BASE_URL` (e.g. `https://yourorg.atlassian.net`)
- **Project Key** → `$JIRA_PROJECT_KEY` (e.g. `NOT`)
- **Board ID** → `$JIRA_BOARD_ID` (e.g. `1`)
- **Cloud ID** → `$JIRA_CLOUD_ID` (required for some MCP tool calls — get via `getAccessibleAtlassianResources`)

Auth is handled by the Atlassian MCP server. No env vars needed for authentication.

---

## Operations

### `link_to(id)`
Return an inline issue reference that renders as a clickable link in this tracker.
- **Format**: `{PROJECT_KEY}-{id}` (e.g. `NOT-17`)
- Use this format anywhere a story or issue needs to be referenced in issue bodies or comments

### `fetch_issue(id)`
Read a single issue in full (summary, description, labels, sprint, comments).
- **MCP tool**: `mcp__plugin_atlassian_atlassian__getJiraIssue`
- **Params**:
  ```json
  {
    "issueIdOrKey": "{PROJECT_KEY}-{id}"
  }
  ```
- Returns: `fields.summary` (title), `fields.description` (body), `fields.labels`, `fields.customfield_10020` (sprint), `fields.comment.comments`

### `list_issues(milestone_id, labels?)`
List issues in a sprint, optionally filtered by label(s).
- **MCP tool**: `mcp__plugin_atlassian_atlassian__searchJiraIssuesUsingJql`
- **Params** (no label filter):
  ```json
  {
    "jql": "project = {PROJECT_KEY} AND sprint = {milestone_id}",
    "fields": ["summary", "labels", "assignee", "status"]
  }
  ```
- **Params** (with label filter — one label):
  ```json
  {
    "jql": "project = {PROJECT_KEY} AND sprint = {milestone_id} AND labels in ({label})",
    "fields": ["summary", "labels", "assignee", "status"]
  }
  ```
- To filter by multiple labels: call once per label and intersect results
- Returns: array of issues (key, summary, labels, assignee, status)

### `create_issue(title, body, labels, milestone_id?)`
Create a new issue.
- **MCP tool**: `mcp__plugin_atlassian_atlassian__createJiraIssue`
- **Params**:
  ```json
  {
    "projectKey": "{PROJECT_KEY}",
    "summary": "{title}",
    "description": "{body}",
    "issueType": "Story",
    "labels": {labels}
  }
  ```
- If `milestone_id` provided, add `"customfield_10020": { "id": {milestone_id} }` to the fields
- Returns: `key` (e.g. `NOT-42`) as the new issue id

### `update_issue_body(issue_id, body)`
Replace the description of an existing issue with updated content.
- Always `fetch_issue` first to read current content, then modify before calling this
- **MCP tool**: `mcp__plugin_atlassian_atlassian__editJiraIssue`
- **Params**:
  ```json
  {
    "issueIdOrKey": "{issue_id}",
    "description": "{body}"
  }
  ```

### `update_labels(issue_id, add, remove)`
Add and/or remove labels on an issue.
- Read current labels first with `fetch_issue` (`fields.labels`) to avoid overwriting
- Compute merged set: `(current + add) - remove`
- **MCP tool**: `mcp__plugin_atlassian_atlassian__editJiraIssue`
- **Params**:
  ```json
  {
    "issueIdOrKey": "{issue_id}",
    "labels": {merged_labels_array}
  }
  ```

### `post_comment(issue_id, body)`
Post a comment on an issue.
- **MCP tool**: `mcp__plugin_atlassian_atlassian__addCommentToJiraIssue`
- **Params**:
  ```json
  {
    "issueIdOrKey": "{issue_id}",
    "body": "{body}"
  }
  ```

### `transition_issue(issue_id, status)`
Move an issue to a new status (e.g. "In Progress", "Done").
- First get available transitions:
  - **MCP tool**: `mcp__plugin_atlassian_atlassian__getTransitionsForJiraIssue`
  - **Params**: `{ "issueIdOrKey": "{issue_id}" }`
- Then apply matching transition:
  - **MCP tool**: `mcp__plugin_atlassian_atlassian__transitionJiraIssue`
  - **Params**: `{ "issueIdOrKey": "{issue_id}", "transitionId": "{id}" }`

### `create_milestone(title, description)`
Create a new sprint on the board.
- **MCP tool**: `mcp__plugin_atlassian_atlassian__fetchAtlassian`
- **Params**:
  ```json
  {
    "url": "{JIRA_BASE_URL}/rest/agile/1.0/sprint",
    "method": "POST",
    "body": {
      "name": "{title}",
      "goal": "{description}",
      "originBoardId": {BOARD_ID}
    }
  }
  ```
- Returns: `id` (sprint id, used as `milestone_id` in other operations)

### `list_milestones()`
List all sprints on the board to determine the next sprint number.
- **MCP tool**: `mcp__plugin_atlassian_atlassian__fetchAtlassian`
- **Params**:
  ```json
  {
    "url": "{JIRA_BASE_URL}/rest/agile/1.0/board/{BOARD_ID}/sprint",
    "method": "GET"
  }
  ```
- Returns: list of sprints (`values[].id`, `values[].name`, `values[].state`: `active`/`closed`/`future`)

### `create_pr(title, body, head, base)`
Not native to Jira. PRs are managed by the git host (GitHub, Bitbucket, etc.).
- Use the git host's PR tool directly (e.g. `mcp__github__create_pull_request` or `gh pr create`)
- Jira will auto-link the PR if the branch name or PR description contains the issue key (e.g. `NOT-17`)

---

## Switching to a Different Tracker

To activate this adapter:

1. In `.claude/project.md`, update the Issue Tracker section:
   ```
   - **Type**: jira
   - **Base URL**: https://yourorg.atlassian.net
   - **Project Key**: NOT
   - **Board ID**: 1
   - **Tracker adapter**: .claude/trackers/jira-tracker.md
   ```
2. Authenticate via `mcp__plugin_atlassian_atlassian__authenticate` (one-time OAuth flow)
3. No env vars required — MCP handles auth

To switch back to GitHub: revert `Tracker adapter` in `project.md` to `.claude/trackers/github-tracker.md`.

The operation interface (names and semantics) is the contract — adapters implement it.
