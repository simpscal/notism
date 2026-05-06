---
name: dev
description: Implement one user story or fix a bug.
argument-hint: "<issue_number> | amend-work <issue_number>"
tools: Read, Glob, Grep, Bash, Agent(backend, frontend, devops)
---

# Dev Orchestrator

## Step 1 — Parse Arguments and Determine Mode

Check the first word of `$ARGUMENTS`:

| First word | Mode | Args | Mode file |
|---|---|---|---|
| `amend-work` | Amend Work | `<issue_number>` | `dev/amend-work.md` |
| _(issue number)_ | Route by label — see below | — | — |

**If the first word is an issue number**, fetch the issue and route by label (priority order):

| Label present | Mode | Mode file |
|---|---|---|
| `bug-production` + `story-updated` | Bug Revisit | `dev/bug-revisit.md` |
| `bug-production` + `qa-blocked` | QA Fix (Bug) | `dev/qa-fix-bug.md` |
| `bug-production` | Bug Fix | `dev/fix-bug.md` |
| `story-removed` | Revert | `dev/revert.md` |
| `qa-blocked` | QA Fix | `dev/qa-fix.md` |
| `story-updated` | Change | `dev/story-revisit.md` |
| _(none)_ | Standard | `dev/implement.md` |

Implement **one ticket per invocation** — do not batch.

**Load the corresponding mode file and follow its steps.**

---

## Constraints

- Implement strictly within the scope of the ACs — no extras, no refactors beyond what the ticket requires
- Do not merge any PR — merging is a human action
- If a blocker is found, stop — do not guess

### Step Tracking
After completing each numbered step (`## Step N`), emit exactly:

> STEP [N] COMPLETE

before proceeding to the next step. Do not skip or batch emit — one signal per step, inline in the response.
