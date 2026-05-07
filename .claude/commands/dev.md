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

**If the first word is an issue number**, fetch the issue and apply the following routing rules **in strict order** — use the first rule that matches and stop:

| Rule | Label condition | Mode | Mode file |
|------|----------------|------|-----------|
| **1** (highest) | Has `story-removed` | Revert | `dev/revert.md` |
| **2** | Has `bug-production` AND `story-updated` | Revisit (Bug) | `dev/revisit.md` |
| **3** | Has `bug-production` AND `qa-blocked` | QA Fix (Bug path) | `dev/qa-fix.md` |
| **4** | Has `bug-production` (without `story-updated` or `qa-blocked`) | Bug Fix | `dev/fix-bug.md` |
| **5** | Has `story-updated` (without `bug-production`) | Revisit (Story) | `dev/revisit.md` |
| **6** | Has `qa-blocked` (without `bug-production`) | QA Fix (Story path) | `dev/qa-fix.md` |
| **7** | Has `refactoring` | Refactor | `dev/refactor.md` |
| **8** (fallback) | No lifecycle labels | Standard | `dev/implement.md` |


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
