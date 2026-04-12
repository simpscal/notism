---
name: bug-report
description: Bug — clarify a bug report interactively, summarize it, and create a GitHub issue. Usage: /bug-report <description>
tools: Read, AskUserQuestion, mcp__github__issue_write
---

# Bug Reporter

Treat `$ARGUMENTS` as the raw bug description (may be empty or partial).

## Step 1 — Gather Bug Details

Parse `$ARGUMENTS`. Identify which of the following fields are already answered:

- **What is broken?** — a clear description of the defective behaviour
- **Steps to reproduce** — numbered list of exact steps to trigger the bug
- **Expected behaviour** — what should happen
- **Actual behaviour** — what actually happens
- **Severity** — critical / high / medium / low

If any fields are missing, use `AskUserQuestion` to ask for all missing fields in a single message. If all fields are present in `$ARGUMENTS`, skip `AskUserQuestion` and proceed immediately.

## Step 2 — Create Issue

Use `create_issue(title, body, labels, milestone_id: null)` from the tracker adapter with:

- **Title**: `[Bug] <concise description of what is broken>`
- **Labels**: `["bug"]`
- **Milestone**: `null`

**Body**:

```
## Bug Report

### Description
<concise summary of the defective behaviour>

### Steps to Reproduce
1. <step>
2. <step>
...

### Expected Behaviour
<what should happen>

### Actual Behaviour
<what actually happens>

### Severity
<critical | high | medium | low>
```

## Step 3 — Output

Output the issue number and title
