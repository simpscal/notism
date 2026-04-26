# Mode: Bug

`fetch_issue(bug_issue_number)` to read the bug report in full.

---

## Step 1 — Analyse the Bug in Context

Determine from the bug report:
- What is the system's intended behaviour in this scenario?
- What user need does the broken behaviour fail to satisfy?
- What does "fixed" look like from the user's observable perspective?
- What edge cases or related scenarios should the ACs cover?

**AC testability checklist** — every AC must pass:
- Observable without reading code?
- Describes a specific condition and a specific outcome?
- Could a non-engineer verify it in a running system?

Rewrite any AC that fails until it passes. Avoid vague language: "should work", "handles errors", "is fast".

If critical information is missing, use `AskUserQuestion` once to ask all blocking questions in a single message.

---

## Step 2 — Write Acceptance Criteria

Use `render_template("acceptance-criteria", {criteria, notes})`.

**AC format**: *"When X, then Y"* or *"Given X, when Y, then Z"*

Include a **Notes** section for: edge cases, related scenarios, dependencies, open questions.

---

## Step 3 — Update the Bug Issue

`update_issue_body(<N>, body)` using `render_template("acceptance-criteria", {criteria, notes})` — append to the **end** of the existing body.

Do NOT modify the original `## Bug Report` section.

---

## Constraints

- Never add technical details to ACs — that is the architect's job
- Never invent scope — if unclear, run discovery
- Never produce tracker output until the user confirms the picture is correct
- Output is format-agnostic — produce clean markdown the user can paste wherever they need it
- Every AC must be observable without reading code, describe a specific condition and outcome, and be verifiable by a non-engineer in a running system
