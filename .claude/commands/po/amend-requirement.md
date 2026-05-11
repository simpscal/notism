# Mode: Change

## Step 1 — Load Product Context

Attempt to read `PRODUCT.md` from the repo root. If it exists, extract the **Vision** and **Business Goals** sections and hold them in context. If the file does not exist, skip this step silently.

---

## Step 2 — Parse Arguments

Extract `issue_number` (first token after `change`) and `new_requirement` (the remainder).

Read issue `#issue_number` in full.

---

## Step 3 — Compare and Rewrite

Compare the current body against `new_requirement` — identify what was **added**, **removed**, or **modified**.

Rewrite the body using the `issue-requirement` template with `{summary, goals, out_of_scope}`, incorporating the changes.

If product context was loaded in Step 1, append an **Alignment Check** block after the rewritten summary:

> **Alignment Check**
> - Vision match: [yes / partial / no — one sentence]
> - Business goal match: [which goal(s) it serves — or "none identified"]

If both checks are "no", surface a warning and use `AskUserQuestion` to ask the user whether to proceed before continuing to Step 4. If either check passes (partial or yes), proceed without prompting.

---

## Step 4 — Update Issue

Update the body of issue `#issue_number` with the rewritten content.

Add label `requirement-updated` to issue `#issue_number`.

Output: `Issue #N updated — <one-line summary of what changed>`
