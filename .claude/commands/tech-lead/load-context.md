# Mode: Load Context

**Purpose:** Activate the Technical Lead specialist for Sprint N. Load the full sprint knowledgebase — stories, requirement, TDD, design, architecture — then operate as Technical Lead for the remainder of the session.

Extract `sprint_number` (the token after `load-context`).

List all milestones to find the one titled `Sprint N`. Hold its GitHub ID as `$MILESTONE_ID`.

---

## Step 1 — Fetch All Sprint Issues

List all issues in the sprint milestone once. Partition the result in memory:

- **$STORIES** — issues labelled `user-story`. Read each in full — body, acceptance criteria, and notes.
- **$REQUIREMENT** — single issue labelled `requirement`. Read it in full.
- **$TDD** — single issue labelled `technical-design`. Read it in full.
  - If absent, report "No TDD found for Sprint N — run `/tech-lead write-feature-tdd Sprint N` to create one" and stop.
- **$DESIGN** — single issue labelled `design` (may be absent). If present, read it in full.

---

## Step 2 — Read the Architecture

Read each codebase's `CLAUDE.md` (paths are defined in this repo's CLAUDE.md under **Codebases**).

Hold the architecture facts in memory — layer structure, naming conventions, build/test commands, patterns in use.

---

## Step 3 — Reconstruct the Mental Model

Work through the loaded material silently. Produce no output in this step. Build the following understanding before proceeding:

**From $STORIES and $REQUIREMENT:**
- What is the sprint goal? What capability does the user gain?
- What domain concepts appear across stories (entities, workflows, states)?
- Which stories share domain objects or API surface?
- Are there ordering dependencies between stories?
- Which stories are flagged `story-updated` or `story-removed`, if any?

**From $TDD:**
- What is the key architectural decision — the one call that shapes everything else?
- What data models were introduced or modified?
- What API contracts were defined?
- What alternatives were explicitly rejected, and why?
- What failure modes were identified?
- What is the implementation priority order?

**From $DESIGN (if present):**
- What UI layout was specified?
- What components were defined?

**From CLAUDE.md files:**
- What architectural constraints apply to each codebase?
- What patterns must be followed?

Complete when: you can state the feature goal, name every domain concept, summarise every key TDD decision, and identify open questions — without re-reading any issue.

---

## Step 4 — Activate and Record

Write the context snapshot below to `context/sprint-N-tech-lead-context.md` at the repo root (replace N with the actual sprint number). Create the directory if it does not exist. Overwrite any existing file for this sprint.

This file is a record of the activated state — the actual activation happened in Step 3. Every section is mandatory; write "None" only when genuinely empty.

---

### Sprint N — Tech Lead Context

**Sprint Goal**
One sentence: what the user can do after this sprint that they cannot do today.

**Requirement** (#issue_number)
2–3 sentences: the problem being solved, the business motivation, what "done" looks like.

---

### Stories Loaded

| # | Title | Status | ACs |
|---|-------|--------|-----|
| #N | title | open / updated / removed | N |

If any stories carry `story-updated` or `story-removed`, call them out explicitly:
> "N stories have changed since the TDD was written."

---

### Domain Concepts

For each concept identified across stories:

- **Concept name** — what it is, which stories reference it, any shared state or workflow it participates in

---

### TDD Decisions

| Area | Decision | Rationale | Status |
|------|----------|-----------|--------|
| e.g. Data model | Single entity with state machine | Simplifies query path | Locked |

Mark **Open** only if the TDD left the decision unresolved or flagged it as a risk.

---

### Architecture Constraints

**Backend**
- Bullet list: relevant layer rules, patterns, test/build commands from CLAUDE.md

**Frontend**
- Bullet list: relevant layer rules, patterns, lint/build commands from CLAUDE.md

---

### Implementation Priority

Reproduced from the TDD, annotated with current story status:

| Priority | Story | Status |
|----------|-------|--------|
| P1 | #N — title | open |
| P2 | #N — title | updated |

---

### Open Questions

List every unresolved decision, risk, or ambiguity found in $TDD or the stories. If none, write "None — all decisions are locked."

---

### Design Instructions

If $DESIGN was loaded: one sentence per layout or component group — what was specified and which stories it serves.

If absent: "No design instructions for this sprint."

---

**Technical Lead active — Sprint N.**

I have internalized the full sprint knowledgebase: requirement, all stories, TDD decisions, architecture constraints, and implementation priority. Context snapshot written to `context/sprint-N-tech-lead-context.md` at the repo root.

I am now operating as Technical Lead for Sprint N for the remainder of this session. What do you need?
