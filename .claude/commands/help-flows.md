---
name: help-flows
description: Pick a workflow stage and get the exact command to run.
argument-hint: "[free-text intent | 'all' for full cheat sheet]"
tools: AskUserQuestion
---

# /help-flows — Workflow Picker

Goal: ask user what they want to do, then print **one exact command** they can copy-paste. Five workflows: `/feature`, `/redesign`, `/hotfix`, `/release`, `/refactor`.

---

## Step 1 — Branch on `$ARGUMENTS`

| Argument | Action |
|---|---|
| `all` _or_ `cheatsheet` | Skip to **Cheat Sheet** at bottom and print verbatim. Stop. |
| _free text_ (e.g. "I need to fix a bug in login") | Treat as intent. Skip Step 2. Go to Step 3 and infer the matching stage from the **Stage Map** below. If ambiguous, fall back to Step 2. |
| _empty_ | Go to Step 2. |

## Step 2 — Ask Intent

Use `AskUserQuestion` with a single multiSelect=false question:

> "What do you want to do?"

Options (label → stage id):

- **Start a new feature** → `feature-start`
- **Continue current sprint** → `feature-continue`
- **Change requirement mid-sprint** → `feature-change`
- **Amend ACs on one story** → `feature-amend-ac`
- **Add a story to current sprint** → `feature-add-story`
- **Merge stories** → `feature-merge`
- **Run a UI redesign** → `redesign-design`
- **Amend a redesign story's design** → `redesign-amend-design`
- **Implement a redesign story** → `redesign-implement`
- **Production bug — fix it** → `hotfix-start`
- **Continue a production bug** → `hotfix-continue`
- **Fix a story regression** → `bug-fix-story`
- **Re-fix an incomplete bug fix** → `bug-fix-bug`
- **Refactor** → `refactor-start`
- **Amend a refactor plan** → `refactor-amend`
- **Release a sprint** → `release-sprint`
- **Release a redesign sprint** → `release-redesign`
- **Release a hotfix** → `release-hotfix`
- **Show full cheat sheet** → `all`

If user picks `all`, jump to **Cheat Sheet** below.

## Step 3 — Resolve Stage to Command

Look up the chosen stage in the **Stage Map**. For each placeholder, ask via `AskUserQuestion`. Skip args already supplied in `$ARGUMENTS`.

**Stage Map**:

| Stage id | Required args | Command template |
|---|---|---|
| `feature-start` | `<description>` | `/feature create-requirement <description>` |
| `feature-continue` | _(see sub-stages)_ | Ask: which sub-stage — stories / design / tdd / implement. Map to `/feature create-stories <req#>`, `/feature create-design <sprint>`, `/feature create-tdd <sprint>`, `/feature implement <story#>`. |
| `feature-change` | `<req#>`, `<delta>` | `/feature amend-requirement <req#> <delta>` _then suggest follow-ups:_ `/feature sync-stories <req#>`, `/feature sync-design <sprint>`, `/feature sync-tdd <sprint>`, `/feature implement <story#>`. |
| `feature-amend-ac` | `<story#>` | `/feature amend-stories <story#>` _then follow-ups:_ `/feature amend-design <story#>`, `/feature amend-tdd <story#>`, `/feature amend-implementation <story#>`. |
| `feature-add-story` | `<req#>` | `/feature add-story <req#>` |
| `feature-merge` | `<target> <source>` | `/feature merge-stories <target> <source>` |
| `release-sprint` | `<sprint>` | `/release sprint <sprint>` |
| `release-redesign` | `<sprint>` | `/release redesign <sprint>` |
| `release-hotfix` | `<bug#>` | `/release hotfix <bug#>` |
| `redesign-design` | _(none)_ | `/redesign design` _(scope captured in one question; brief issue created mid-flow)_ |
| `redesign-amend-design` | `<story#>` | `/redesign amend-design <story#>` _then follow-up:_ `/redesign implement <story#>`. |
| `redesign-implement` | `<story#>` | `/redesign implement <story#>` |
| `hotfix-start` | `[description]` | `/hotfix report <description>` |
| `hotfix-continue` | _(see sub-stages)_ | Ask: which sub-stage — acs / implement. Map to `/hotfix acs <bug#>`, `/hotfix implement <bug#>`. |
| `bug-fix-story` | `<story#>`, `<bug_spec>` | `/feature fix-story <story#> <bug_spec>` |
| `bug-fix-bug` | `<bug#>`, `<bug_spec>` | `/hotfix fix-bug <bug#> <bug_spec>` |
| `refactor-start` | _(none)_ | `/refactor create` _then:_ `/refactor implement <refactor#>` |
| `refactor-amend` | `<refactor#>` | `/refactor amend <refactor#>` |

## Step 4 — Output

Print exactly:

```
👉 Run: <resolved command>
```

If a follow-up command is part of the flow, add one line per follow-up:

```
↳ Next: <follow-up command>
```

Then stop. No extra prose, no execution.

---

## Cheat Sheet

_Printed only when `$ARGUMENTS` is `all`/`cheatsheet` or user picks "Show full cheat sheet"._

### 🆕 Feature (Sprint)

1. `/feature create-requirement <description>`
2. `/feature create-stories <requirement_issue>`
3. `/feature create-design <sprint>` _(web codebase only)_
4. `/feature create-tdd <sprint>`
5. `/feature implement <story_issue>` _(repeat per story)_
6. `/release sprint <sprint>`

### 🔁 Requirement Change (within Feature)

1. `/feature amend-requirement <requirement_issue> <delta>`
2. `/feature sync-stories <requirement_issue>`
3. `/feature sync-design <sprint>` _(if web stories changed)_
4. `/feature sync-tdd <sprint>`
5. `/feature implement <story_issue>` _(handles `story-updated` internally; `/feature revert <story_issue>` for removed)_

### ✏️ AC Amend (within Feature)

1. `/feature amend-stories <story_issue>`
2. `/feature amend-design <story_issue>` _(if design impact)_
3. `/feature amend-tdd <story_issue>` _(if technical impact)_
4. `/feature amend-implementation <story_issue>`

### ➕ Add Story Mid-Sprint (within Feature)

1. `/feature add-story <requirement_issue>`
2. `/feature sync-design <sprint>` _(if web)_
3. `/feature sync-tdd <sprint>`
4. `/feature implement <new_story_issue>`

### 🔀 Merge Stories (within Feature)

1. `/feature merge-stories <target_issue> <source_issue> [...]`

### 🎨 Redesign

1. `/redesign design`                              _← Phase 1: capture scope, build design system, file [Redesign Brief] issue, generate previews + stories + priority table_
2. `/redesign amend-design <story_issue>`         _← amend one story's per-surface design; upserts hub comment; labels affected implemented stories `story-updated`_
3. `/redesign implement <story_issue>`            _← Phase 2: follow the Priority Implementation Table on the brief issue; foundations first. Handles `story-updated` (Revisit branch)_
4. `/release redesign <sprint>`                    _← reuses sprint release shape_

### 🐞 Bug Fix Loop

- `/feature fix-story <story_issue> <bug_spec>` _(story regression)_
- `/hotfix fix-bug <bug_issue> <bug_spec>` _(incomplete bug fix)_

### 🐛 Hotfix (Production Bug)

1. `/hotfix report [description]`
2. `/hotfix acs <bug_issue>`
3. `/hotfix implement <bug_issue>`
4. `/release hotfix <bug_issue>`

### 🚀 Release

- `/release sprint <sprint_number>` — close a feature sprint
- `/release redesign <sprint_number>` — close a redesign sprint
- `/release hotfix <bug_issue>` — close a production bug

### 🧹 Refactor

1. `/refactor create`
2. `/refactor implement <refactor_issue>`
3. `/refactor amend <refactor_issue>` _(if plan needs revision)_

### 🛠 Setup (one-off utility)

- `/setup init`
- For `PRODUCT.md` or `DESIGN.md`: describe the change in natural language (e.g. "create the product context", "amend the vision section", "regenerate DESIGN.md").

---

## Constraints

- Never **execute** the resolved command — just print it.
- Never invent stages or commands not in the Stage Map.
- If user-supplied args already match required slots, do not re-ask.
- One `AskUserQuestion` call may batch multiple needed args as separate questions.
