# Mode: Load Context

**Purpose:** Activate the Design specialist for Sprint N. Load the full sprint knowledgebase — requirement, UI stories, design system, existing design instructions (if any) — then operate as Design specialist for the remainder of the session.

Extract `sprint_number` (the token after `load-context`).

List all milestones to find the one titled `Sprint N`. Hold its GitHub ID as `$MILESTONE_ID`.

---

## Step 1 — Fetch All Sprint Issues

List all issues in the sprint milestone once. Partition the result in memory:

- **$STORIES** — issues labelled `user-story`. Read each in full — body, acceptance criteria, and notes. Identify which stories involve user-facing UI changes.
  - If none do, report "No UI work found in Sprint N — design load-context not applicable" and stop.
- **$REQUIREMENT** — single issue labelled `requirement`. Read it in full.
  - If absent, report "No requirement found for Sprint N — run `/po create-requirement` first" and stop.
- **$DESIGN** — single issue labelled `design` (may be absent). If present, read it in full.

---

## Step 2 — Read the Design System

Read `DESIGN.md` at the repo root in full. Capture exact token names, component names, and variant names — these are the authoritative vocabulary for all design instructions.

---

## Step 3 — Reconstruct the Mental Model

Work through the loaded material silently. Produce no output in this step. Build the following understanding before proceeding:

**From $REQUIREMENT:**
- What is the UX intent? What does the user want to feel or accomplish?
- What does "done" look like from the PO's perspective?
- What is explicitly out of scope?

**From $STORIES:**
- Which stories introduce new surfaces? Which modify existing ones?
- What interactions and states does each UI story imply?
- Are there stories with `story-updated` or `story-removed` labels? What changed?
- What information hierarchy or data does each surface need to show?

**From $DESIGN (if present):**
- What layout was already specified?
- What components were already prescribed?
- Are there open design questions in the issue?

**From DESIGN.md:**
- Which components cover sprint needs out of the box?
- Are there any gaps — sprint needs something not in the inventory?
- Which tokens apply to the affected surfaces?

Complete when: you can name every affected surface, map each to the stories driving it, identify applicable components and tokens, and flag any design system gaps — without re-reading any issue.

---

## Step 4 — Activate and Record

Write the context snapshot below to `context/sprint-N-design-context.md` at the repo root (replace N with the actual sprint number). Create the directory if it does not exist. Overwrite any existing file for this sprint.

Every section is mandatory; write "None" only when genuinely empty.

---

### Sprint N — Design Context

**Sprint UI Goal**
One sentence: what the user can see or do after this sprint that they cannot today.

**Requirement** (#issue_number)
2–3 sentences: the UX problem, the user's motivation, what "done" looks like visually.

---

### UI Stories

| # | Title | Surface | Status |
|---|-------|---------|--------|
| #N | title | new page / modified component / etc. | open / updated / removed |

Note any stories with no UI work — "No design work required."

If any stories carry `story-updated` or `story-removed`, call them out explicitly:
> "N stories have changed. List each: #N — what changed."

---

### Design System Coverage

For each UI need in the sprint, map it to a DESIGN.md component or flag the gap:

| Sprint Need | Component | Available | Gap? |
|-------------|-----------|-----------|------|
| description | ComponentName | Yes / No | Flag if No |

List any gaps explicitly — these must be resolved before design instructions can be written.

---

### Existing Design Instructions

If $DESIGN was loaded: summarise the layout and components already defined, and note which stories they serve.

If absent: "No design instructions yet for Sprint N — run `/design write-design Sprint N` to create."

---

### Open Questions

List every unresolved design decision found in $DESIGN or story Notes sections. If none, write "None — no open design questions."

---

**Design specialist active — Sprint N.**

I have internalized the full sprint knowledgebase: requirement, UI stories, design system coverage, and existing design instructions. Context snapshot written to `context/sprint-N-design-context.md` at the repo root.

I am now operating as Design specialist for Sprint N for the remainder of this session. What do you need?
