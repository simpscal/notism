---
name: redesign
description: UI redesign lifecycle — design → implement. Sprint setup, design system + approval gate + revised DESIGN.md, retrospective brief issue, priority-ordered story implementation.
tools: Read, Write, Glob, Grep, Bash, AskUserQuestion, Agent(frontend)
---

# /redesign — UI Redesign Orchestrator

A visually-driven lifecycle for redesigning **existing** UI surfaces. Two phases plus a single-story amendment stage. No requirement issue.

Testing handled by `/test`; release reuses `/feature release <sprint>`.

## Step 1 — Parse Arguments and Load Mode

The first arg names a **stage**. Match `$ARGUMENTS` against the table below and load the matching mode file.

| Stage | Args | Description | Mode file |
|---|---|---|---|
| `design` | _(none)_ | Build the design system, file the brief issue, generate per-surface mockups + instructions, and decompose priority-ordered stories. | `redesign/design.md` |
| `amend-design` | `<story_issue>` | Amend the design for one story by scope — `system` (DESIGN.md + catalog), `page` (surface files), or `both`. | `redesign/amend-design.md` |
| `implement` | `<story_issue>` | Implement one redesign story (frontend only) — fresh, or delta-only when `story-updated`. | `redesign/implement.md` |

**Argument reference:**

- `<story_issue>` — issue number of a single redesign user story.

For test cases and QA verdict, use `/test write|sync|amend|pass|block <story_issue>`. For sprint release, use `/feature release <sprint_number>`.

**Load the corresponding mode file and follow its steps.**

### Stage Picker (when `$ARGUMENTS` is empty or unmatched)

1. Use `AskUserQuestion` to let the user pick a stage:
   - **Stage**: present `design` / `amend-design` / `implement`.
2. After a stage is chosen, ask one `AskUserQuestion` per required arg from the table (story issue number). `design` takes no arguments — proceed directly.
3. Treat the result as `$ARGUMENTS = "<stage> <args>"` and continue with the matched row.

### Lifecycle sequence

- **Standard redesign**: `design` → `implement` (per story, in priority order) → `/test write` → `/test pass`/`/test block` → `/feature release <sprint>`.
- **Single-story design amendment**: `amend-design <story_issue>` → `implement <story_issue>` (Revisit branch handles `story-updated`) → `/test amend <story_issue>` → `/test pass`/`/test block`.

---

### Step Tracking
After completing each numbered step (`## Step N`), emit exactly:

> STEP [N] COMPLETE

before proceeding to the next step.
