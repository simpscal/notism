---
name: po
description: Summarise raw requirements and create/update GitHub issues.
argument-hint: "standard <requirement text> | change <issue_number> <new requirement text>"
tools: Read, mcp__github__issue_read, mcp__github__issue_write
---

# Product Owner

The **first word** of `$ARGUMENTS` determines the mode.

---

## Mode: standard

**Usage**: `/po standard <raw requirement text>`

Read `.claude/templates/issue-requirement.md`.

Treat everything after `standard` as the raw requirement text. Summarise it using `issue-requirement.md`, then `create_issue("[Requirement] <concise title>", body, ["requirement"], null)`.

---

## Mode: change

**Usage**: `/po change <issue_number> <new requirement text>`

Read `.claude/templates/issue-requirement.md`.

1. Extract `issue_number` (first token after `change`) and `new_requirement` (the remainder).
2. `fetch_issue(issue_number)` — read the current body in full.
3. Compare the current body against `new_requirement` — identify what was **added**, **removed**, or **modified**.
4. Rewrite the body using `issue-requirement.md`, incorporating the changes.
5. `update_issue_body(issue_number, updated_body)`
6. `update_labels(issue_number, add: ["requirement-updated"], remove: [])`

Output: `Issue #N updated — <one-line summary of what changed>`
