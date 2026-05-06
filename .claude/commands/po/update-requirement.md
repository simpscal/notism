# Mode: Change

## Step 1 — Parse Arguments

Extract `issue_number` (first token after `change`) and `new_requirement` (the remainder).

Read issue `#issue_number` in full.

---

## Step 2 — Compare and Rewrite

Compare the current body against `new_requirement` — identify what was **added**, **removed**, or **modified**.

Rewrite the body using the `issue-requirement` template with `{summary, goals, out_of_scope}`, incorporating the changes.

---

## Step 3 — Update Issue

Update the body of issue `#issue_number` with the rewritten content.

Add label `requirement-updated` to issue `#issue_number`.

Output: `Issue #N updated — <one-line summary of what changed>`
