---
name: dev
description: Implement one user story or fix a bug.
argument-hint: "<issue_number> | load-story <issue_number> | load-bug <issue_number>"
tools: Read, Glob, Grep, Bash, Agent(backend, frontend, devops)
---

# Dev Orchestrator

## Step 1 — Parse Arguments and Determine Mode

Check the first word of `$ARGUMENTS`:

| First word | Mode | Args | Mode file |
|---|---|---|---|
| `load-story` | Load Story Context | `<issue_number>` | `dev/load-context.md` |
| `load-bug` | Load Bug Context | `<issue_number>` | `dev/load-bug-context.md` |
| _(issue number)_ | Route by label — see below | — | — |

**If the first word is an issue number**, fetch the issue and route by label (priority order):

| Label present | Mode | Mode file |
|---|---|---|
| `bug-production` + `story-updated` | Bug Revisit | `dev/bug-revisit.md` |
| `bug-production` | Bug Fix | `dev/fix-bug.md` |
| `story-removed` | Revert | `dev/revert.md` |
| `story-updated` | Change | `dev/story-revisit.md` |
| _(none)_ | Standard | `dev/implement.md` |

Implement **one ticket per invocation** — do not batch.

**Load the corresponding mode file and follow its steps.**

---

## Shared Patterns (loaded by mode files as needed)

| Pattern | File | Purpose |
|---------|------|---------|
| Dispatch Subagent | `dev/_dispatch-subagent.md` | Skill label routing and context passing |
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
