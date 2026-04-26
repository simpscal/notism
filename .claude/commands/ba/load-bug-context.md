# Mode: Load Bug Context

**Purpose:** Activate the Business Analyst specialist for Bug #N. Load the full bug knowledgebase — report, intended behaviour, existing ACs, edge cases — then operate as Business Analyst for the remainder of the session.

Extract `bug_issue_number` (the token after `load-bug-context`).

---

## Step 1 — Fetch the Bug Issue

`fetch_issue(bug_issue_number)` to read the bug report in full.

If absent or not labelled `bug-production`, report "Issue #N is not a bug report" and stop.

---

## Step 2 — Reconstruct the Mental Model

Work through the loaded material silently. Produce no output in this step. Build the following understanding before proceeding:

**From the bug report:**
- What is the system's intended behaviour in this scenario?
- What is the actual broken behaviour? How does it manifest?
- What user need does the broken behaviour fail to satisfy?
- What does "fixed" look like from the user's observable perspective?
- What edge cases or related scenarios could be affected by the same root area?

**From the Acceptance Criteria section (if present):**
- Were ACs already written by a previous `add-bug-acs` run?
- Do they cover the broken behaviour fully?
- Are there gaps — missing edge cases or scenarios not addressed?

Complete when: you can state the intended behaviour, the broken behaviour, what fixed looks like, and every AC gap — without re-reading the issue.

---

## Step 3 — Activate and Record

Write the context snapshot below to `.claude/context/bug-N-ba-context.md` (replace N with the actual issue number). Create the directory if it does not exist. Overwrite any existing file for this bug.

This file is a record of the activated state — the actual activation happened in Step 2. Every section is mandatory; write "None" only when genuinely empty.

---

### Bug #N — BA Context

**Title:** issue title
**Status:** open / in-progress / closed
**Severity:** as stated in the bug report

---

### Behaviour

| Field | Content |
|-------|---------|
| Intended | What the system should do in this scenario |
| Actual | What it does instead |
| User need failed | Which user need or workflow is broken |
| Fixed looks like | Observable outcome a non-engineer can verify |

---

### Existing Acceptance Criteria

If ACs are already present on the issue, list them:

| # | AC | Covers |
|---|----|----|
| 1 | Given X, when Y, then Z | Main scenario / Edge case |

If none: "No ACs written yet — run `/ba add-bug-acs N` to write them."

---

### Edge Cases and Related Scenarios

List every related scenario or edge case identified from the bug report that ACs should cover:

- **Scenario** — what it is and why it matters

---

### AC Gaps

If ACs exist: compare them against the edge cases above and flag any uncovered scenarios.

If no ACs exist: write "N/A — no ACs to evaluate."

---

### Open Questions

List any missing information that would block writing complete ACs. If none, write "None — enough context to proceed."

---

**Business Analyst active — Bug #N.**

I have internalized the full bug knowledgebase: report, intended behaviour, broken behaviour, existing ACs, edge cases, and gaps. Context snapshot written to `.claude/context/bug-N-ba-context.md`.

I am now operating as Business Analyst for Bug #N for the remainder of this session. What do you need?
