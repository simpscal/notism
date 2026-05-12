---
name: hotfix
description: Production bug fix lifecycle — report, ACs, fix, release. Testing handled by /test.
tools: Read, Write, Glob, Grep, Bash, AskUserQuestion, Agent(backend, frontend, devops)
---

# /hotfix — Production Bug Fix Orchestrator

For bugs found in production. Faster lane than feature — no design, no TDD; the bug ticket carries ACs directly and goes straight to fix → release. Test cases and QA verdict are handled by the separate `/test` workflow.

## Step 1 — Parse Arguments and Load Mode

| Stage | Args | Description | Mode file |
|---|---|---|---|
| `report` | `[description]` | Clarify the bug interactively and open a tracker issue with `bug-production` label. | `hotfix/report.md` |
| `acs` | `<bug_issue>` | Analyse the bug and add Acceptance Criteria to the same ticket. | `hotfix/acs.md` |
| `implement` | `<bug_issue>` | Investigate root cause and apply the fix — fresh, or delta-only if `story-updated` label is set. | `hotfix/implement.md` |
| `fix-bug` | `<bug_issue>` | Re-fix after QA blocked the bug (`qa-blocked` label). | `hotfix/fix-bug.md` |
| `release` | `<bug_issue>` | Merge the bugfix PR to main and close the bug. | `hotfix/release.md` |

**Argument reference:**

- `[description]` — free-text bug report (symptoms, repro steps); optional, will be gathered interactively if omitted.
- `<bug_issue>` — issue number of the bug ticket (carries `bug-production` label).

**Load the corresponding mode file and follow its steps.**

### Stage Picker (when `$ARGUMENTS` is empty or unmatched)

1. Use `AskUserQuestion` with one question listing 4 most-common stages (`report`, `acs`, `implement`, `release`); the 5th (`fix-bug`) is offered via the auto-injected "Other".
2. After a stage is chosen, ask one `AskUserQuestion` per required arg (bug issue number, optional description).
3. Treat the result as `$ARGUMENTS = "<stage> <args>"` and continue with the matched row.

For test cases and QA verdict, use the separate `/test` workflow (`/test write|sync|amend|pass|block <bug_issue>`).

### Standard sequence

`report` → `acs` → `implement` → `/test write` → `/test pass` (or `/test block`) → `release`.

QA fail loop: `fix-bug` → `/test pass`/`/test block`.

---

## Constraints

- Each stage has a human gate — never chain `report` → `acs` → `fix-bug` automatically.
- Always operate on the same bug issue across stages — never split into new story issues.
- Stop and ask if a required arg is missing.

### Step Tracking
After completing each numbered step, emit exactly:

> STEP [N] COMPLETE
