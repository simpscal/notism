# Mode: Load Context

**Purpose:** Activate the Business Analyst specialist for Sprint N. Load the full sprint knowledgebase — requirement, all stories, goal coverage, dependencies — then operate as Business Analyst for the remainder of the session.

Extract `sprint_number` (the token after `load-context`).

Use `list_milestones()` to find the milestone with title `Sprint N`. Hold its GitHub ID as `$MILESTONE_ID`.

---

## Step 1 — Fetch All Sprint Issues

Call `list_issues($MILESTONE_ID)` once. Partition the result in memory:

- **$REQUIREMENT** — single issue labelled `requirement`. Use `fetch_issue(id)` to read it in full.
  - If absent, report "No requirement found for Sprint N — run `/po create-requirement` first" and stop.
- **$STORIES** — issues labelled `user-story`. Use `fetch_issue(id)` on each to read full body, acceptance criteria, and notes.
  - If none exist, report "No stories found for Sprint N — run `/ba write-stories <req_issue_number>` to create them" and stop.

---

## Step 2 — Reconstruct the Mental Model

Work through the loaded material silently. Produce no output in this step. Build the following understanding before proceeding:

**From $REQUIREMENT:**
- Who is the primary user?
- What is the single most important thing they want to achieve?
- What does "done" look like from the PO's perspective?
- What is explicitly out of scope?
- What implicit constraints or assumptions underpin the requirement?

**From $STORIES:**
- Does every story trace back to a goal in the requirement?
- Are there stories with `story-updated` or `story-removed` labels? What changed?
- Do any stories depend on each other? Is the dependency direction explicit?
- Does the full story set satisfy the requirement goal — no gaps, no gold-plating?
- Are there open questions in Notes that were never resolved?

Complete when: you can state the sprint goal, map every story to a requirement goal, identify any changed stories, and name any open gaps — without re-reading any issue.

---

## Step 3 — Write the Context Summary

Produce the structured brief below. Every section is mandatory; write "None" only when genuinely empty.

Write the output to `.claude/context/sprint-N-ba-context.md` (replace N with the actual sprint number). Create the directory if it does not exist. Overwrite any existing file for this sprint.

---

### Sprint N — BA Context

**Sprint Goal**
One sentence: what the user can do after this sprint that they cannot do today.

**Requirement** (#issue_number)

| Field | Content |
|-------|---------|
| Primary user | Who |
| Core need | What they want to achieve |
| Done criteria | What "done" looks like to the PO |
| Out of scope | Explicitly excluded |
| Key assumptions | What must be true for this to work |

---

### Stories Loaded

| # | Title | Status | ACs |
|---|-------|--------|-----|
| #N | title | open / updated / removed | N |

If any stories carry `story-updated` or `story-removed`, call them out explicitly:
> "N stories have changed. List each: #N — what changed."

---

### Goal Coverage

For each goal stated in the requirement, map it to the story or stories that satisfy it:

| Requirement Goal | Story / Stories | Coverage |
|-----------------|-----------------|----------|
| Goal description | #N, #N | Full / Partial / Gap |

Flag any **Gap** rows — these are scope holes where no story covers a stated goal.
Flag any stories **not mapped** to a goal — these are gold-plating candidates.

---

### Story Dependencies

List only explicit dependencies (from Notes fields). If none, write "None."

| Story | Depends On | Direction |
|-------|-----------|-----------|
| #N — title | #N — title | Blocks / Blocked by |

---

### Open Questions

List every unresolved question found in story Notes sections, or gaps in requirement coverage. If none, write "None — all questions resolved."

---

**Business Analyst active — Sprint N.**

I have internalized the full sprint knowledgebase: requirement, all stories, goal coverage, dependencies, and open questions. Context snapshot written to `.claude/context/sprint-N-ba-context.md`.

I am now operating as Business Analyst for Sprint N for the remainder of this session. What do you need?