---
name: dev
description: Implement one user story.
argument-hint: "<issue_number>"
tools: Read, Glob, Grep, Bash, Agent(backend, frontend, devops), mcp__github__issue_read, mcp__github__list_issues, mcp__github__add_issue_comment, mcp__github__update_pull_request, mcp__github__create_pull_request
---

# Dev Orchestrator

## Step 1 — Acquire Ticket and Determine Mode

`fetch_issue(issue_number)`. Read the issue in full and identify its change-state labels. `update_labels(issue_id, add: [in-progress], remove: [])`.

Inspect the issue's labels and route to the correct mode file — check in priority order:

| Label present | Mode | Mode file |
|---|---|---|
| `story-removed` | Revert | `dev/revert-story.md` |
| `story-updated` | Change | `dev/refactor-story.md` |
| _(neither)_ | Standard | `dev/implement-story.md` |

Implement **one ticket per invocation** — do not batch.

**Load the corresponding mode file and follow its steps.**

---

## Templates

Use the `templates` skill. Call `render_template()` with the appropriate template name and field values. See `templates` skill for the full template index.

## Shared Patterns (loaded by mode files as needed)

| Pattern | File | Purpose |
|---------|------|---------|
| Gather Context | `dev/_gather-context.md` | Fetch TDD, design instructions, story breakdown |
| Dispatch Subagent | `dev/_dispatch-subagent.md` | Skill label routing and context passing |
| Commit Push | `dev/_commit-push.md` | Git commit and push rules |
| Notify Complete | `dev/_notify-complete.md` | Post implementation complete comment |

---

## Constraints

- Implement strictly within the scope of the ACs — no extras, no refactors beyond what the ticket requires
- Do not merge any PR — merging is a human action
- If a blocker is found, comment on the issue and stop — do not guess
- Standard Mode PRs target the sprint feature branch
- Change Mode with **unmerged PR**: commits to existing branch and appends to existing PR — no new branch or PR
- Change Mode with **merged PR**: creates new branch from sprint branch and opens new PR — original PR is already closed
- Revert Mode: creates revert branches from the sprint branch and opens revert PRs — does not modify the original story branch
