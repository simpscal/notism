---
name: help-flows
description: Pick a workflow stage and get the exact command to run.
argument-hint: "[free-text intent | 'all' for full cheat sheet]"
tools: AskUserQuestion
---

# /help-flows — Workflow Picker

Goal: ask user what they want to do, then print **one exact command** they can copy-paste.
/
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
- **Report a bug** → `bug-start`
- **Continue a bug** → `bug-continue`
- **Change requirement mid-sprint** → `req-change`
- **Amend ACs on one story/bug** → `ac-amend`
- **Add a story to current sprint** → `add-story`
- **Merge stories** → `merge-stories`
- **Refactor** → `refactor`
- **Amend a refactor plan** → `refactor-amend`
- **QA failed — fix it** → `qa-fix`
- **Release** → `release`
- **Show full cheat sheet** → `all`

If user picks `all`, jump to **Cheat Sheet** below.

## Step 3 — Resolve Stage to Command

Look up the chosen stage in the **Stage Map**. For each placeholder (`<requirement_issue>`, `<sprint>`, `<issue>`, `<delta>`, `<description>`, `<notes>`, `<target>`, `<source>`), ask via `AskUserQuestion` (one question per missing arg, batched in a single call when possible). Skip any args already supplied in `$ARGUMENTS`.

**Stage Map**:

| Stage id | Required args | Command template |
|---|---|---|
| `feature-start` | `<description>` | `/po create-requirement <description>` |
| `feature-continue` | _(see sub-stages)_ | Ask: which sub-stage — write-stories / design / tdd / dev / test / pass-or-block. Map to `/ba write-stories <req#>`, `/designer write-design <sprint>`, `/tech-lead write-feature-tdd <sprint>`, `/dev <story#>`, `/qa write-test-cases <story#>`, `/qa pass <story#>` or `/qa block <story#> <notes>`. |
| `bug-start` | `[description]` | `/po create-bug <description>` |
| `bug-continue` | _(see sub-stages)_ | Ask: which sub-stage — acs / dev / test / pass-or-block / release. Map to `/ba add-bug-acs <bug#>`, `/dev <bug#>`, `/qa write-test-cases <bug#>`, `/qa pass <bug#>` or `/qa block <bug#> <notes>`, `/release hotfix <bug#>`. |
| `req-change` | `<requirement_issue>`, `<delta>` | `/po update-requirement <requirement_issue> <delta>` _then suggest follow-up:_ `/ba sync-stories <requirement_issue>` |
| `ac-amend` | `<issue>` | `/ba amend <issue>` |
| `add-story` | `<requirement_issue>` | `/ba add-story <requirement_issue>` |
| `merge-stories` | `<target>`, `<source>` | `/ba merge-stories <target> <source>` |
| `refactor` | _(none)_ | `/tech-lead create-refactor` |
| `refactor-amend` | `<refactor_issue>` | `/tech-lead amend-refactor <refactor_issue>` |
| `qa-fix` | `<issue>` | `/dev <issue>` _(auto-routes via `qa-blocked` label)_ |
| `release` | sprint or hotfix? + `<n>` | `/release sprint <sprint>` _or_ `/release hotfix <bug#>` |

## Step 4 — Output

Print exactly:

```
👉 Run: <resolved command>
```

If a follow-up command is part of the flow (e.g. `req-change` → `/ba sync-stories`), add one line:

```
↳ Next: <follow-up command>
```

Then stop. No extra prose, no execution.

---

## Cheat Sheet

_Printed only when `$ARGUMENTS` is `all`/`cheatsheet` or user picks "Show full cheat sheet"._

### 🆕 Feature (Sprint)

1. `/po create-requirement <description>`
2. `/ba write-stories <requirement_issue>`
3. `/designer write-design <sprint>` _(web codebase only)_
4. `/tech-lead write-feature-tdd <sprint>`
5. `/dev <story_issue>` _(repeat per story)_
6. `/qa write-test-cases <story_issue>`
7. `/qa pass <story_issue>` _or_ `/qa block <story_issue> <notes>`
8. `/release sprint <sprint>`

### 🐛 Bug

1. `/po create-bug [description]`
2. `/ba add-bug-acs <bug_issue>`
3. `/dev <bug_issue>`
4. `/qa write-test-cases <bug_issue>`
5. `/qa pass <bug_issue>` _or_ `/qa block <bug_issue> <notes>`
6. `/release hotfix <bug_issue>`

### 🔁 Requirement Change

1. `/po update-requirement <requirement_issue> <delta>`
2. `/ba sync-stories <requirement_issue>`
3. `/designer sync-design <sprint>` _(if web stories changed)_
4. `/tech-lead sync-feature-tdd <sprint>`
5. `/dev <story_issue>` _(per changed story)_
6. `/qa sync-test-cases <story_issue>` _or_ `/qa write-test-cases <story_issue>`

### ✏️ AC Amend

1. `/ba amend <issue>`
2. `/designer sync-design <sprint>` _(if design impact)_
3. `/tech-lead sync-feature-tdd <sprint>` _(if technical impact)_
4. `/dev <issue>`
5. `/qa sync-test-cases <issue>`

### 🧹 Refactor

1. `/tech-lead create-refactor`
2. `/dev <refactor_issue>`
3. `/tech-lead amend-refactor <refactor_issue>` _(if plan needs revision)_

### 🚫 QA Fail Loop

1. `/dev <issue>` _(QA Fix via `qa-blocked` label)_
2. `/qa pass <issue>` _or_ `/qa block <issue> <notes>`

### ➕ Add Story Mid-Sprint

1. `/ba add-story <requirement_issue>`
2. `/designer sync-design <sprint>` _(if web)_
3. `/tech-lead sync-feature-tdd <sprint>`
4. `/dev <new_story_issue>`
5. `/qa write-test-cases <new_story_issue>`

### 🔀 Merge Stories

1. `/ba merge-stories <target_issue> <source_issue> [...]`

### 🚢 Release

- Sprint: `/release sprint <sprint>`
- Hotfix: `/release hotfix <bug_issue>`

---

**Tip:** `/dev <issue>` auto-routes by label — `bug-production`, `qa-blocked`, `story-updated`, `story-removed`, `refactoring`, or default Standard mode.

---

## Constraints

- Never **execute** the resolved command — just print it.
- Never invent stages or commands not in the Stage Map.
- If user-supplied args already match required slots, do not re-ask.
- One `AskUserQuestion` call may batch multiple needed args (issue#, sprint#) as separate questions.
