---
name: load
description: Load Requirement, User Story, TDD, or Design context from GitHub into conversation.
argument-hint: "<requirement|story|tdd|design> <issue-number>"
tools: Read
---

# Load Context

## Step 1 — Parse Arguments

| First word | Mode | Args | Mode file |
|---|---|---|---|
| `requirement` | Requirement | `<issue-number>` | `load/load-requirement.md` |
| `story` | Story | `<issue-number>` | `load/load-story.md` |
| `tdd` | TDD | `<issue-number>` | `load/load-tdd.md` |
| `design` | Design | `<issue-number>` | `load/load-design.md` |

**Load the corresponding mode file and follow its steps.**
