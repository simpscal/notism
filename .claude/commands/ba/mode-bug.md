# Mode: Bug

**Usage**: `/ba bug <bug_issue_number>`

`fetch_issue(bug_issue_number)` to read the bug report in full.

---

## B1 — Analyse the Bug in Context

Using the bug report (description, reproduction steps, expected/actual behaviour), determine:

- What is the system's intended behaviour in this scenario?
- What user need does the broken behaviour fail to satisfy?
- What does "fixed" look like from a user's observable perspective?
- What edge cases or related scenarios should the ACs cover?

If critical information is missing, use `AskUserQuestion` once to ask all blocking questions in a single message.

---

## B2 — Write Acceptance Criteria

Fill in `acceptance-criteria.md`.

-> Apply `_validation.md` (AC Testability Checklist)

---

## B3 — Update the Bug Issue

`update_issue_body(<N>, body)` using `acceptance-criteria.md` — append to the **end** of the existing body.

Do NOT modify the original `## Bug Report` section.
