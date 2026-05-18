---
name: checkpoint
description: Use to read, write, or clear workflow resume state under `.claude/state/<workflow>.json`. Auto-invoke at workflow entry (read + resume prompt) and at every `## Step N COMPLETE` boundary (write). Single source of truth for resume across feature, hotfix, redesign, refactor.
tools: Read, Write, Edit, Bash
---

## File Layout

```
.claude/state/
  feature.json
  hotfix.json
  redesign.json
  refactor.json
```

## Schema

```json
{
  "_version": 1,
  "<run-key>": {
    "stage": "<stage-name>",
    "primary_arg": "<value>",
    "current_phase": "<phase-id>",
    "current_step": "<step-label>",
    "started": "<iso8601>",
    "updated": "<iso8601>",
    "completed_steps": ["step-1", "step-2"],
    "phases": {
      "<phase-id>": {
        "decisions": { "key": "value" },
        "artifacts": { "issues": [], "branches": [], "files": [] }
      }
    }
  }
}
```

- `_version = 1`. Halt with `"checkpoint schema version mismatch: file=<v> expected=1"` on mismatch.
- `<run-key>` = `<stage>-<primary-arg>`.
- `completed_steps` is append-only and ordered.
- Decision keys must be stable identifiers (e.g. `stack_choice`), not question text.

## Read

1. Path: `.claude/state/<workflow>.json`.
2. If file absent → return `null`.
3. `Read` file. Parse JSON.
4. Validate `_version`. Halt on mismatch.
5. Return entry at `<run-key>` or `null`.

## Write

Inputs: `workflow`, `run_key`, `stage`, `primary_arg`, `phase`, `step`, optional `decisions`, optional `artifacts`.

1. `Read` existing file or start from `{"_version": 1}`.
2. If `obj[run_key]` absent, initialise:
   ```
   { "stage": <stage>, "primary_arg": <primary_arg>, "started": <now>, "completed_steps": [], "phases": {} }
   ```
3. Deep-merge `decisions` and `artifacts` into `phases[phase]` (arrays append + dedupe).
4. Set `current_phase = phase`, `current_step = step`, `updated = <now>`.
5. If previous `current_step` not in `completed_steps`, append it. (`step` arg names the **next** step; previous value is what completed.)
6. `Write` file back, 2-space indent.

## Clear

Inputs: `workflow`, `run_key`.

1. `Read` file. If absent → no-op.
2. Delete `obj[run_key]`.
3. If only `_version` remains → `Bash: rm` the file.
4. Else `Write` updated file.

## List

Inputs: `workflow`.

1. `Read` file. If absent → return `[]`.
2. Return keys except `_version`, sorted by `updated` desc.

## Resume Prompt

On checkpoint hit at workflow entry, always ask via `AskUserQuestion`:

```
Found checkpoint for <workflow> <run-key>:
  Stage:    <stage>
  Started:  <started>
  Last:     <updated> (<current_step>)
  Done:     step-1 → step-2 → step-3
  Next:     <next step from mode file>

Resume? [Y]es / [r]estart / [c]ancel
```

- **Resume** → load decisions/artifacts, jump to step after `current_step`.
- **Restart** → call `checkpoint:clear`, start at Step 1.
- **Cancel** → abort; leave checkpoint untouched.

## Decision Replay

Before every `AskUserQuestion` in the mode file:

1. Look up the question's key in `phases[<phase>].decisions[<key>]`.
2. If found → use stored value.
3. If missing → ask, then `checkpoint:write` the answer.

## Artifact Replay

Before creating any artifact (issue, branch, file):

1. Check `phases[<phase>].artifacts` for an existing reference.
2. If present → reuse.
3. If absent → create, then `checkpoint:write`.

## Step Boundary

After each `> STEP [N] COMPLETE`, call `checkpoint:write` with:

- `step` = label of the next Step (or `"done"` after the final step).
- Decisions and artifacts produced in the step just completed.

## On Completion

When a stage finishes its final step:

1. Write final state with `current_step = "done"`, `current_phase = "done"`.
2. If the stage terminates the workflow (e.g. `feature:release`, `hotfix:release`), call `checkpoint:clear` for **all** run-keys related to the same sprint/issue.
3. Otherwise leave the checkpoint in place.
