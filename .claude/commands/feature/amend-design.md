
Extract `sprint_number` (the token after `amend-design`).

---

## Step 1 — Load Sprint Context

-> Load Sprint Snapshot for Sprint N (github skill). Hold $MILESTONE_ID, $STORIES, $REQUIREMENT, $TDD, $DESIGN.

**Mode-specific guard**: If `$DESIGN` is absent → report "No Design Instructions found for Sprint N — run `/designer write-design Sprint N` first" and stop.

---

## Step 2 — Read the Design System

Read `DESIGN.md` at the repo root in full. Capture exact token names, component names, and variant names — these are the authoritative vocabulary for all design instructions.

---

## Step 3 — Reconstruct the Mental Model

Work through all loaded material silently. Produce no output in this step. Build the following understanding before proceeding:

**From $REQUIREMENT:**
- What is the UX intent? What does the user want to feel or accomplish?
- What does "done" look like from the PO's perspective?
- What is explicitly out of scope?

**From $STORIES:**
- Which stories introduce new surfaces? Which modify existing ones?
- What interactions and states does each UI story imply?
- Which stories are flagged `story-updated` or `story-removed`?
- What information hierarchy or data does each surface need to show?

**From $DESIGN:**
- What layout is currently specified?
- What components are prescribed?
- Are there open design questions in the issue?

**From DESIGN.md:**
- Which components cover sprint needs out of the box?
- Are there any gaps — sprint needs something not in the inventory?
- Which tokens apply to the affected surfaces?

Complete when: you can name every affected surface, map each to the stories driving it, identify applicable components and tokens, and flag any design system gaps — without re-reading any issue.

When complete, activate using this format:

> Design Specialist active — Sprint N Design Instructions. Full knowledgebase loaded: [list what was loaded]. Ready to discuss changes or alternatives.

Do not proceed to Step 4 until activation is complete.

---

## Step 4 — Open Amendment Dialog

Ask a single `AskUserQuestion`:

> What changed, and why? Describe the problem with the current Design Instructions and the direction you want to go — or share options you'd like to evaluate.

Hold the response as **$CHANGE_INPUT**. Do not proceed until answered.

Use $CHANGE_INPUT to engage in discussion — answer trade-off questions, surface constraints from the mental model, flag risks from loaded material. Continue iterating until the final direction is confirmed.

---

## Step 5 — Revise Design Instructions

Use the current Design Instructions as the baseline. The output must be the full revised artifact, not a summary or diff.

Evaluate each section against the confirmed change. Follow `../_design-structure.md` for structure and token/component conventions.

| Section | Update trigger |
|---------|----------------|
| Overview | Sprint UI goal or affected surfaces changed |
| Layout | Any surface layout added, modified, or removed — sketch affected surfaces only via `../_design-layouts.md` |
| Components | Any component added, changed, or removed |
| Design Tokens | Any token usage added or changed |
| UI States | Any state added, changed, or removed for affected surfaces |
| Responsive Behavior | Any breakpoint behaviour added or changed |
| Accessibility | Any ARIA, keyboard, or focus requirement added or changed |

Update the body of the $DESIGN issue with the revised content.

---

## Step 6 — Classify Scope Changes and Label Affected Stories

From $STORIES, filter to only stories carrying the `implemented` label. Compare the revised Design Instructions against each implemented story and classify the impact:

| Classification | Condition |
|----------------|-----------|
| `additive` | Change adds new behaviour; existing implementation remains valid |
| `breaking` | Change conflicts with or invalidates the existing implementation |
| `structural` | Change requires full revisit; affected files treated as blank slate |
| `unaffected` | Story is not touched by this change |

Produce a **Scope Classification Table**:

| Story | Title | Classification | Reason |
|-------|-------|----------------|--------|
| #N | title | additive / breaking / structural / unaffected | one sentence |

If any classification is ambiguous, ask before proceeding.

**Label updates**: For each story classified `additive`, `breaking`, or `structural`:
- If the story has label `implemented` → add label `story-updated`.
- If no `implemented` label → skip.

Run all label additions in parallel.
