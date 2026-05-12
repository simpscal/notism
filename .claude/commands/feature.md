---
name: feature
description: Sprint feature lifecycle — requirement, stories, design, TDD, dev, release. Absorbs mid-sprint changes and AC amendments. Testing handled by /test.
argument-hint: "<stage> [args]"
tools: Read, Write, Glob, Grep, Bash, AskUserQuestion, Agent(backend, frontend, devops)
---

# /feature — Feature Lifecycle Orchestrator

A sprint feature lifecycle. Each stage hands off via a tracker artifact (requirement issue → stories → design issue → TDD issue → PRs → release). Test cases and QA verdict are handled by the separate `/test` workflow.

This workflow also covers mid-sprint requirement changes and AC amendments — they are stages of the same lifecycle, not separate workflows.

## Step 1 — Parse Arguments and Load Mode

The first arg names a **stage**. Match `$ARGUMENTS` against the table below and load the matching mode file.

| Stage | Args | Description | Mode file |
|---|---|---|---|
| `create-requirement` | `<description>` | Turn a free-text requirement into a tracker issue with `requirement` label. | `feature/create-requirement.md` |
| `amend-requirement` | `<req_issue> <delta>` | Revise an existing requirement issue with the supplied change. | `feature/amend-requirement.md` |
| `create-stories` | `<requirement_issue>` | Break a requirement into user stories under a new sprint milestone. | `feature/create-stories.md` |
| `add-story` | `<requirement_issue>` | Append one extra story to the current sprint. | `feature/add-story.md` |
| `sync-stories` | `<requirement_issue>` | Reconcile existing stories with an amended requirement (add / change / remove). | `feature/sync-stories.md` |
| `amend-stories` | `<story_issue>` | Change ACs on a single story without touching its siblings. | `feature/amend-stories.md` |
| `merge-stories` | `<target> <source...>` | Fold one or more source stories into a target story. | `feature/merge-stories.md` |
| `create-design` | `<sprint_number>` | Author the sprint's design instructions (frontend surfaces). | `feature/create-design.md` |
| `sync-design` | `<sprint_number>` | Update design instructions after stories changed. | `feature/sync-design.md` |
| `amend-design` | `<story_issue>` | Revise design instructions for one amended story. | `feature/amend-design.md` |
| `create-tdd` | `<sprint_number>` | Author the sprint's technical design document. | `feature/create-tdd.md` |
| `sync-tdd` | `<sprint_number>` | Update TDD after stories changed. | `feature/sync-tdd.md` |
| `amend-tdd` | `<story_issue>` | Revise TDD sections affected by one amended story. | `feature/amend-tdd.md` |
| `implement` | `<story_issue>` | Implement a story — fresh build, or delta-only if `story-updated` label is set. | `feature/implement.md` |
| `revert` | `<story_issue>` | Undo work for a story removed during a requirement change. | `feature/revert.md` |
| `fix-story` | `<story_issue>` | Re-implement after QA blocked the story (`qa-blocked` label). | `feature/fix-story.md` |
| `amend-implementation` | `<story_issue>` | Re-implement after an AC amendment on one story. | `feature/amend-implementation.md` |
| `release` | `<sprint_number>` | Merge sprint branch to main and close the milestone. | `feature/release.md` |

**Argument reference:**

- `<description>` — free-text requirement (a sentence or two).
- `<requirement_issue>` / `<req_issue>` — issue number of the parent requirement.
- `<delta>` — free-text describing the change to apply.
- `<story_issue>` — issue number of a single user story.
- `<sprint_number>` — sprint number; matches the milestone titled `Sprint N`.
- `<target>` / `<source...>` — story issue numbers for a merge (target absorbs sources).

For test cases and QA verdict, use the separate `/test` workflow (`/test write|sync|amend|pass|block <story_issue>`).

**Load the corresponding mode file and follow its steps.**

If `$ARGUMENTS` does not match any row, ask via `AskUserQuestion` which stage the user wants.

### Stage usage by lifecycle phase

Testing stages (`/test write|sync|amend|pass|block`) are invoked via the separate `/test` workflow — they slot in after the implementation stage in each sequence below.

- **Standard sprint**: `create-requirement` → `create-stories` → `create-design` → `create-tdd` → `implement` → `/test write` → `/test pass`/`/test block` → `release`.
- **Mid-sprint requirement change**: `amend-requirement` → `sync-stories` → `sync-design` → `sync-tdd` → `implement` (handles the `story-updated` label internally; use `revert` for removed stories) → `/test sync`.
- **AC amendment on one story**: `amend-stories` → `amend-design` → `amend-tdd` → `amend-implementation` → `/test amend`.
- **Add story mid-sprint**: `add-story` → `sync-design` → `sync-tdd` → `implement` → `/test write`.
- **QA fail loop**: `fix-story` → `/test pass`/`/test block`.

---

## Constraints

- One stage per invocation — do not batch.
- Never invent artifacts (issues, milestones, labels) that the mode file does not explicitly create.
- Stop and ask if a required arg is missing — never guess issue numbers.

### Step Tracking
After completing each numbered step (`## Step N`), emit exactly:

> STEP [N] COMPLETE

before proceeding to the next step.
