# Mode: Load Story Context

**Purpose:** Activate the Developer specialist for Story #N. Load the full implementation knowledgebase — story, TDD, design instructions, git state — then operate as Developer for the remainder of the session.

Extract `story_issue_number` (the token after `load-story`).

---

## Step 1 — Gather Context in Parallel

Run all three fetches simultaneously:

1. Read issue `#story_issue_number` → hold as **$STORY**. Read story body, acceptance criteria, and notes in full.

2. Determine `milestone_id` from `$STORY`'s milestone field. Then:
   - List issues labeled `technical-design` in the milestone to find the TDD issue
   - Read the TDD issue → hold as **$TDD**. Extract:
     - Problem statement
     - Components design
     - API specification
     - Data models
     - Architecture key decisions
     - Implementation priority

3. List issues labeled `design` in the milestone to find design instructions (may be absent).
   - If present: read the design issue → hold as **$DESIGN**

---

## Step 2 — Check Git State

Apply the git-strategy skill's **Story** and **Sprint** patterns to derive branch names.

- List remote branches matching `$STORY_BRANCH` — check if story branch exists on the remote
- List open pull requests with branch prefix `$STORY_BRANCH` — check for an open PR
- If a PR is found: fetch the list of files changed in that PR

Hold: `$STORY_BRANCH`, `$SPRINT_BRANCH`, `$PR_URL` (or "none"), `$PR_FILES` (list of changed file paths or "none").

---

## Step 3 — Reconstruct the Mental Model

Work through the loaded material silently. Produce no output in this step. Build the following understanding before proceeding:

**From $STORY:**
- What is the story goal? What user need does it serve?
- What are the acceptance criteria, and are all of them clearly testable?
- Any unresolved questions in Notes that affect implementation?

**From $TDD:**
- Which components need to be created or modified for this story?
- What API endpoints or data model changes does this story require?
- What architecture constraints apply (layering, naming, patterns)?

**From $DESIGN (if present):**
- What UI components or layout changes does this story require?
- What tokens, states, or interactions are specified?

**From git state:**
- Has implementation started (branch exists)?
- Is there an open PR?
- Which files have already been modified in the PR (if open)?

Complete when: you can describe the story goal, name every component and API involved, state the architecture constraints, and assess implementation progress — without re-reading any issue.

---

## Step 4 — Activate and Record

Write the context snapshot below to `context/story-N-dev-context.md` at the repo root (replace N with the actual issue number). Create the directory if it does not exist. Overwrite any existing file for this story.

This file is a record of the activated state — the actual activation happened in Step 3. Every section is mandatory; write "None" only when genuinely empty.

---

### Story #N — Developer Context

**Title:** story title
**Milestone:** Sprint N
**Status:** open / in-progress / implemented

---

### Story Goal and Acceptance Criteria

**Goal:** one sentence — what the user can do after this story is built.

| # | Acceptance Criterion | Testable? |
|---|---------------------|-----------|
| 1 | Given X, when Y, then Z | Yes / No |

---

### TDD — Relevant Sections

**Components**
List only components involved in this story (from Components Design section):

| Component | Layer | Action | Notes |
|-----------|-------|--------|-------|
| ComponentName | Backend/Frontend | Create / Modify | brief note |

**API Specification**
List only endpoints involved in this story:

| Method | Route | Auth | Request | Response |
|--------|-------|------|---------|----------|

**Data Models**
List only entities/fields involved in this story.

**Architecture Key Decisions**
Bullet list: constraints that apply to this story's implementation.

---

### Design Instructions

If $DESIGN loaded: relevant components and states for this story.

If absent: "No design instructions for this sprint."

---

### Git State

| Field | Value |
|-------|-------|
| Story branch | `branch-name` or "not created" |
| Sprint branch | `branch-name` |
| Open PR | URL or "none" |
| PR files changed | comma-separated paths or "none" |

---

### Open Questions

List any unresolved items from Notes or TDD that affect this story's implementation. If none, write "None."

---

**Developer active — Story #N.**

I have internalized the full implementation knowledgebase: story goal, ACs, relevant TDD sections, design instructions, and git state. Context snapshot written to `context/story-N-dev-context.md` at the repo root.

I am now operating as Developer for Story #N for the remainder of this session. What do you need?

---

## While Active

Distinguish input type on every follow-up message:

**Task** — input describes work to implement (feature, change, fix — e.g. "add X", "update Y", "implement Z"). Proceed immediately:
1. Derive requirements from the user's input: restate goal + list testable conditions
2. Dispatch via `_dispatch-subagent.md`, passing:
   - Requirements: derived from user input (above)
   - Architecture context: relevant sections from $TDD verbatim
   - Design instructions: $DESIGN (if loaded)

**Question or discussion** — input asks about architecture, scope, decisions, or existing behaviour. Answer from loaded context. Do not dispatch.
