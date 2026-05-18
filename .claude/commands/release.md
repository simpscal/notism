---
name: release
description: Release lifecycle — close a sprint (feature or redesign) or close a production bug. Merges to main and marks artifacts complete.
tools: Read, Write, Glob, Grep, Bash, AskUserQuestion
---

# Release Orchestrator

## Step 1 — Parse Arguments and Load Mode

The first arg names a **stage**. Match `$ARGUMENTS` against the table below and load the matching mode file.

| Stage | Args | Description | Mode file |
|---|---|---|---|
| `sprint` | `<sprint_number>` | Close a feature sprint — merge sprint branch to main, label all milestone issues `sprint-completed`. | `release/sprint.md` |
| `redesign` | `<sprint_number>` | Close a redesign sprint — same shape as `sprint`. | `release/sprint.md` |
| `hotfix` | `<bug_issue>` | Close a production bug — merge bugfix branch to main, label bug `bug-fixed`. | `release/hotfix.md` |

**Argument reference:**

- `<sprint_number>` — sprint number; matches the milestone titled `Sprint N`.
- `<bug_issue>` — issue number of a closed bug (carries `bug-production` label).

**Load the corresponding mode file and follow its steps.**

### Stage Picker (when `$ARGUMENTS` is empty or unmatched)

1. Use `AskUserQuestion` to let the user pick a stage: `sprint` / `redesign` / `hotfix`.
2. After a stage is chosen, ask one `AskUserQuestion` for the required arg (sprint number or bug issue).
3. Treat the result as `$ARGUMENTS = "<stage> <args>"` and continue with the matched row.

---

## Constraints

- One stage per invocation — do not batch.
- Each stage has a human gate before destructive action — never auto-close issues without the readiness gate passing.
- Stop and ask if a required arg is missing.

### Step Tracking
After completing each numbered step (`## Step N`), emit exactly:

> STEP [N] COMPLETE

before proceeding to the next step.
