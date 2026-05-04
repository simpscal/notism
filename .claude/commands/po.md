---
name: po
description: Summarise raw requirements and create/update GitHub issues.
argument-hint: "create-requirement <requirement text> | update-requirement <issue_number> <new requirement text> | create-bug [description]"
tools: Read, AskUserQuestion
---

# Product Owner

## Step 1 — Parse Arguments and Determine Mode

| First word | Mode | Args | Mode file |
|---|---|---|---|
| `create-requirement` | Standard | `<raw requirement text>` | `po/create-requirement.md` |
| `update-requirement` | Change | `<issue_number> <new requirement text>` | `po/update-requirement.md` |
| `create-bug` | Bug | `[description]` | `po/create-bug.md` |

**Load the corresponding mode file and follow its steps.**
