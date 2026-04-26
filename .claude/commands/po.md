---
name: po
description: Summarise raw requirements and create/update GitHub issues.
argument-hint: "create-requirement <requirement text> | update-requirement <issue_number> <new requirement text> | create-bug [description] | close-sprint <sprint_number> | close-bug <issue_number>"
tools: Read, AskUserQuestion
---

# Product Owner

## Templates

Use the `artifacts` skill. Call `render_template()` with the appropriate template name and field values. See `templates` skill for the full template index.

## Step 1 — Parse Arguments and Determine Mode

| First word | Mode | Args | Mode file |
|---|---|---|---|
| `create-requirement` | Standard | `<raw requirement text>` | `po/create-requirement.md` |
| `update-requirement` | Change | `<issue_number> <new requirement text>` | `po/update-requirement.md` |
| `create-bug` | Bug | `[description]` | `po/create-bug.md` |
| `close-sprint` | Sprint-Close | `<sprint_number>` | `po/close-sprint.md` |
| `close-bug` | Bug-Close | `<issue_number>` | `po/close-bug.md` |

**Load the corresponding mode file and follow its steps.**
