---
name: refactor
description: Refactor lifecycle — create plan, amend plan, implement.
tools: Read, Write, Glob, Grep, Bash, AskUserQuestion, Agent(backend, frontend, devops)
---

# /refactor — Refactor Lifecycle Orchestrator

## Step 1 — Parse Arguments and Load Mode

| Stage | Args | Description | Mode file |
|---|---|---|---|
| `create` | _(none)_ | Survey the codebase, draft a refactor plan, and open a tracker issue with `refactoring` label. | `refactor/create.md` |
| `amend` | `<refactor_issue>` | Revise an existing refactor plan in light of new findings. | `refactor/amend.md` |
| `implement` | `<refactor_issue>` | Implement the refactor plan — preserves observable behaviour. | `refactor/implement.md` |

**Argument reference:**

- `<refactor_issue>` — issue number of the refactor plan (carries `refactoring` label).

**Load the corresponding mode file and follow its steps.**

### Stage Picker (when `$ARGUMENTS` is empty or unmatched)

1. Use `AskUserQuestion` with one question listing the 3 stages (`create`, `amend`, `implement`).
2. If `amend` or `implement` is chosen, ask one more `AskUserQuestion` for `<refactor_issue>`.
3. Treat the result as `$ARGUMENTS = "<stage> <args>"` and continue with the matched row.

---

## Constraints

- Refactor must not alter observable behaviour. Tests stay green.
- One stage per invocation.

### Step Tracking
After completing each numbered step, emit exactly:

> STEP [N] COMPLETE
