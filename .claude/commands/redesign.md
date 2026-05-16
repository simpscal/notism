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
| `design` | _(none)_ | **Phase 1.** Capture scope in one sentence, build the design system, present an `index.html` design catalog, get user approval, revise `DESIGN.md`, file the retrospective `[Redesign Brief]` issue, generate per-surface design instructions + HTML mockups, decompose into stories with a priority implementation table. Produces the brief issue + `Sprint N` milestone + story issues. | `redesign/design.md` |
| `amend-design` | `<story_issue>` | Amend the design for one story after Phase 1. Classifies the change scope from user input — **`system`** revises `DESIGN.md` + regenerates the design catalog (`sprint-<N>/index.html`) via the same pipeline as `design`; **`page`** regenerates the target surface `.md` + `.html`; **`both`** runs both pipelines. Hub comment is not re-rendered — its blob URLs are branch-ref and stay valid as new commits land on the sprint branch. Labels affected implemented stories `story-updated` — primitives stories only when primitives actually shifted in the diff, page stories whose surface intersects the change. | `redesign/amend-design.md` |
| `implement` | `<story_issue>` | **Phase 2.** Implement one story per invocation. Frontend only. Checks the `story-updated` label — Fresh branch for first-time implementation, Revisit branch for delta-only after an amendment. Reads only the design instructions for the story's surface. | `redesign/implement.md` |

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
