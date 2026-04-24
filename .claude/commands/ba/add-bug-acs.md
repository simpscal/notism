# Mode: Bug

`fetch_issue(bug_issue_number)` to read the bug report in full.

---

## Step 1 — Analyse the Bug in Context

Determine what "fixed" looks like from the user's observable perspective, what the intended behaviour is, and what edge cases the ACs should cover.

If critical information is missing, use `AskUserQuestion` once to ask all blocking questions in a single message.

---

## Step 2 — Write Acceptance Criteria

Use `render_template("acceptance-criteria", {criteria, notes})`.

---

## Step 3 — Update the Bug Issue

`update_issue_body(<N>, body)` using `render_template("acceptance-criteria", {criteria, notes})` — append to the **end** of the existing body.

Do NOT modify the original `## Bug Report` section.
