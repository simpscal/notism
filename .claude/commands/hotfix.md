---
name: hotfix
description: Production bug fix lifecycle — report, ACs, fix, release.
tools: Read, Write, Glob, Grep, Bash, AskUserQuestion, Agent(backend, frontend, devops)
---

# Production Bug Fix Orchestrator

## Step 1 — Parse Arguments and Load Mode

| Stage | Args | Description | Mode file |
|---|---|---|---|
| `report` | `[description]` | Clarify the bug interactively and open a tracker issue with `bug-production` label. | `hotfix/report.md` |
| `acs` | `<bug_issue>` | Analyse the bug and add Acceptance Criteria to the same ticket. | `hotfix/acs.md` |
| `implement` | `<bug_issue>` | Investigate root cause and apply the fix — fresh, or delta-only if `story-updated` label is set. | `hotfix/implement.md` |
| `fix-bug` | `<bug_issue> <bug_spec>` | Re-fix a bug to address a follow-up spec; bug spec passed inline. | `hotfix/fix-bug.md` |
| `release` | `<bug_issue>` | Merge the bugfix PR to main and close the bug. | `hotfix/release.md` |

**Argument reference:**

- `[description]` — free-text bug report (symptoms, repro steps); optional, will be gathered interactively if omitted.
- `<bug_issue>` — issue number of the bug ticket (carries `bug-production` label).
- `<bug_spec>` — free-text describing a follow-up defect (used by `fix-bug`).

**Load the corresponding mode file and follow its steps.**

### Resume Detection

Before handing control to the mode file, look up any existing resume state for this run keyed by `workflow = hotfix`, `run_key = <stage>-<primary_arg>` (e.g. `implement-87`, `acs-87`). For `report` with no `<bug_issue>` yet, the run-key is set after the issue is created.

If state is found, ask the user via `AskUserQuestion`:

- **Resume** → jump past completed steps; replay stored decisions and artifacts.
- **Restart** → clear the state, start at Step 1.
- **Cancel** → abort; leave the state untouched.

### Stage Picker (when `$ARGUMENTS` is empty or unmatched)

1. Use `AskUserQuestion` with one question listing 4 most-common stages (`report`, `acs`, `implement`, `release`); the 5th (`fix-bug`) is offered via the auto-injected "Other".
2. After a stage is chosen, ask one `AskUserQuestion` per required arg (bug issue number, optional description).
3. Treat the result as `$ARGUMENTS = "<stage> <args>"` and continue with the matched row.

### Standard sequence

`report` → `acs` → `implement` → `release`.

Re-fix loop: `fix-bug <bug_issue> <bug_spec>`.

---

## Constraints

- Each stage has a human gate — never chain `report` → `acs` → `fix-bug` automatically.
- Always operate on the same bug issue across stages — never split into new story issues.
- Stop and ask if a required arg is missing.

### Step Tracking
After completing each numbered step, emit exactly:

> STEP [N] COMPLETE
