---
name: redesign
description: UI redesign lifecycle — design → implement. Sprint setup, design system + approval gate + revised DESIGN.md, retrospective brief issue, priority-ordered story implementation.
tools: Read, Write, Glob, Grep, Bash, AskUserQuestion, Agent(frontend)
---

# UI Redesign Orchestrator

## Step 1 — Parse Arguments and Load Mode

The first arg names a **stage**. Match `$ARGUMENTS` against the table below and load the matching mode file.

| Stage | Args | Description | Mode file |
|---|---|---|---|
| `design` | _(none)_ | Build the design system, file the brief issue, generate per-surface mockups + instructions, and decompose priority-ordered stories. | `redesign/design.md` |
| `amend-design` | `<story_issue>` | Amend the design for one story by scope — `system` (DESIGN.md + catalog), `page` (surface files), or `both`. | `redesign/amend-design.md` |
| `implement` | `<story_issue>` | Implement one redesign story (frontend only) — fresh, or delta-only when `story-updated`. | `redesign/implement.md` |

**Argument reference:**

- `<story_issue>` — issue number of a single redesign user story.

For sprint release, use `/release redesign <sprint_number>`.

**Load the corresponding mode file and follow its steps.**

### Resume Detection

Before handing control to the mode file, look up any existing resume state for this run keyed by `workflow = redesign`, `run_key = <stage>-<primary_arg>`. For `design` (no arg), the run-key is `design-sprint-<N>` once the sprint number is assigned in Step 1.

If state is found, ask the user via `AskUserQuestion`:

- **Resume** → jump past completed steps; replay stored decisions and artifacts.
- **Restart** → clear the state, start at Step 1.
- **Cancel** → abort; leave the state untouched.

### Stage Picker (when `$ARGUMENTS` is empty or unmatched)

1. Use `AskUserQuestion` to let the user pick a stage:
   - **Stage**: present `design` / `amend-design` / `implement`.
2. After a stage is chosen, ask one `AskUserQuestion` per required arg from the table (story issue number). `design` takes no arguments — proceed directly.
3. Treat the result as `$ARGUMENTS = "<stage> <args>"` and continue with the matched row.

### Lifecycle sequence

- **Standard redesign**: `design` → `implement` (per story, in priority order) → `/release redesign <sprint>`.
- **Single-story design amendment**: `amend-design <story_issue>` → `implement <story_issue>` (Revisit branch handles `story-updated`).

---

### Step Tracking
After completing each numbered step (`## Step N`), emit exactly:

> STEP [N] COMPLETE

before proceeding to the next step.
