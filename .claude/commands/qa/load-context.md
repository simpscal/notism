# Mode: Load Context

Extract `story_number` (the token after `load-context`).

---

## Step 1 — Fetch Issue

Read issue `#story_number` in full — title, labels, ACs.

---

## Step 2 — Find Test Cases Comment

Search the issue's comments for one with the heading `## QA Test Cases`.

If found: display the full comment.
If not found: report `No QA test cases found for #story_number`.

---

## Step 3 — Summarise State

Report:
- Story title and labels
- QA status: `qa-passed` / `qa-blocked` / `pending` (neither label present)
- Number of ACs
- Number of test cases (count rows in test case tables, if comment exists)
