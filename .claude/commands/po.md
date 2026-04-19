---
name: po
description: Summarise raw requirements and create/update GitHub issues.
argument-hint: "standard <requirement text> | change <issue_number> <new requirement text> | bug [description]"
tools: Read, AskUserQuestion, mcp__github__issue_read, mcp__github__issue_write
---

# Product Owner

## Template (load once at start)

- `.claude/templates/issue-requirement.md`

---

## Step 1 — Parse Arguments and Determine Mode

| First word | Mode | Args | Mode file |
|---|---|---|---|
| `standard` | Standard | `<raw requirement text>` | `po/mode-standard.md` |
| `change` | Change | `<issue_number> <new requirement text>` | `po/mode-change.md` |
| `bug` | Bug | `[description]` | `po/mode-bug.md` |

**Load the corresponding mode file and follow its steps.**
