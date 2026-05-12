---
name: help-flows
description: Pick a workflow stage and get the exact command to run.
argument-hint: "[free-text intent | 'all' for full cheat sheet]"
tools: AskUserQuestion
---

# /help-flows — Workflow Picker

Goal: ask user what they want to do, then print **one exact command** they can copy-paste. Four workflows: `/feature`, `/hotfix`, `/test`, `/refactor`.

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
- **Production bug — fix it** → `hotfix-start`
- **Continue a production bug** → `hotfix-continue`
- **Write test cases** → `test-write`
- **Mark QA pass/block** → `test-verdict`
- **QA failed — fix it** → `qa-fix`
- **Refactor** → `refactor-start`
- **Amend a refactor plan** → `refactor-amend`
- **Sprint release** → `feature-release`
- **Show full cheat sheet** → `all`

If user picks `all`, jump to **Cheat Sheet** below.

## Step 3 — Resolve Stage to Command

Look up the chosen stage in the **Stage Map**. For each placeholder, ask via `AskUserQuestion`. Skip args already supplied in `$ARGUMENTS`.

**Stage Map**:

| Stage id | Required args | Command template |
|---|---|---|
| `feature-start` | `<description>` | `/feature create-requirement <description>` |
| `feature-continue` | _(see sub-stages)_ | Ask: which sub-stage — stories / design / tdd / implement. Map to `/feature create-stories <req#>`, `/feature create-design <sprint>`, `/feature create-tdd <sprint>`, `/feature implement <story#>`. |
| `feature-change` | `<req#>`, `<delta>` | `/feature amend-requirement <req#> <delta>` _then suggest follow-ups:_ `/feature sync-stories <req#>`, `/feature sync-design <sprint>`, `/feature sync-tdd <sprint>`, `/feature implement <story#>`, `/test sync <story#>`. |
| `feature-amend-ac` | `<story#>` | `/feature amend-stories <story#>` _then follow-ups:_ `/feature amend-design <story#>`, `/feature amend-tdd <story#>`, `/feature amend-implementation <story#>`, `/test amend <story#>`. |
| `feature-add-story` | `<req#>` | `/feature add-story <req#>` |
| `feature-merge` | `<target> <source>` | `/feature merge-stories <target> <source>` |
| `feature-release` | `<sprint>` | `/feature release <sprint>` |
| `hotfix-start` | `[description]` | `/hotfix report <description>` |
| `hotfix-continue` | _(see sub-stages)_ | Ask: which sub-stage — acs / implement / release. Map to `/hotfix acs <bug#>`, `/hotfix implement <bug#>`, `/hotfix release <bug#>`. |
| `test-write` | `<issue>` | `/test write <issue>` |
| `test-verdict` | pass or block? + `<issue>` | `/test pass <issue>` _or_ `/test block <issue> <notes>` |
| `qa-fix` | `<issue>` | `/feature fix-story <issue>` _(or `/hotfix fix-bug <bug#>` if it's a bug)_ _then:_ `/test pass <issue>` |
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
6. `/test write <story_issue>`
7. `/test pass <story_issue>` _or_ `/test block <story_issue> <notes>`
8. `/feature release <sprint>`

### 🔁 Requirement Change (within Feature)

1. `/feature amend-requirement <requirement_issue> <delta>`
2. `/feature sync-stories <requirement_issue>`
3. `/feature sync-design <sprint>` _(if web stories changed)_
4. `/feature sync-tdd <sprint>`
5. `/feature implement <story_issue>` _(handles `story-updated` internally; `/feature revert <story_issue>` for removed)_
6. `/test sync <story_issue>`

### ✏️ AC Amend (within Feature)

1. `/feature amend-stories <story_issue>`
2. `/feature amend-design <story_issue>` _(if design impact)_
3. `/feature amend-tdd <story_issue>` _(if technical impact)_
4. `/feature amend-implementation <story_issue>`
5. `/test amend <story_issue>`

### ➕ Add Story Mid-Sprint (within Feature)

1. `/feature add-story <requirement_issue>`
2. `/feature sync-design <sprint>` _(if web)_
3. `/feature sync-tdd <sprint>`
4. `/feature implement <new_story_issue>`
5. `/test write <new_story_issue>`

### 🔀 Merge Stories (within Feature)

1. `/feature merge-stories <target_issue> <source_issue> [...]`

### 🚫 QA Fail Loop

1. `/feature fix-story <story_issue>` _(or `/hotfix fix-bug <bug_issue>`)_
2. `/test pass <issue>` _or_ `/test block <issue> <notes>`

### 🐛 Hotfix (Production Bug)

1. `/hotfix report [description]`
2. `/hotfix acs <bug_issue>`
3. `/hotfix implement <bug_issue>`
4. `/test write <bug_issue>`
5. `/test pass <bug_issue>` _or_ `/test block <bug_issue> <notes>`
6. `/hotfix release <bug_issue>`

### 🧪 Test (standalone)

- `/test write <issue>` — first test cases for the issue
- `/test sync <issue>` — reconcile after requirement change
- `/test amend <issue>` — revise after single-issue AC change
- `/test pass <issue>` — mark `qa-passed`
- `/test block <issue> <notes>` — mark `qa-blocked` with failure notes

### 🧹 Refactor

1. `/refactor create`
2. `/refactor implement <refactor_issue>`
3. `/refactor amend <refactor_issue>` _(if plan needs revision)_

### 🛠 Setup (one-off utility)

- `/setup init`
- `/setup pcd create` / `/setup pcd amend [section]`
- `/setup design-system create` / `/setup design-system amend`

---

## Constraints

- Never **execute** the resolved command — just print it.
- Never invent stages or commands not in the Stage Map.
- If user-supplied args already match required slots, do not re-ask.
- One `AskUserQuestion` call may batch multiple needed args as separate questions.
