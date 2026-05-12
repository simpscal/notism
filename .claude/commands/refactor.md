---
name: refactor
description: Refactor lifecycle — create plan, amend plan, implement.
argument-hint: "<create|amend|implement> [args]"
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

If the first word does not match any stage, ask the user which stage they want via `AskUserQuestion`.

---

## Constraints

- Refactor must not alter observable behaviour. Tests stay green.
- One stage per invocation.

### Step Tracking
After completing each numbered step, emit exactly:

> STEP [N] COMPLETE
