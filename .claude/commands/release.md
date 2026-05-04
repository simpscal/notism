---
name: release
description: Release a sprint or hotfix to main.
argument-hint: "sprint <sprint_number> | hotfix <issue_number>"
tools: Read, AskUserQuestion
---

# Release Manager

## Step 1 — Parse Arguments and Determine Mode

| First word | Mode | Args | Mode file |
|---|---|---|---|
| `sprint` | Sprint Release | `<sprint_number>` | `release/sprint.md` |
| `hotfix` | Hotfix Release | `<issue_number>` | `release/hotfix.md` |

**Load the corresponding mode file and follow its steps.**
