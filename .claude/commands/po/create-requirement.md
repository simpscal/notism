# Mode: Standard

## Step 1 — Load Product Context

Attempt to read `PRODUCT.md` from the repo root. If it exists, extract the **Vision** and **Business Goals** sections and hold them in context. If the file does not exist, skip this step silently.

---

## Step 2 — Summarise Requirement

Summarise the raw requirement using the `issue-requirement` template with `{summary, goals, out_of_scope}`.

If product context was loaded in Step 1, append an **Alignment Check** block after the rendered summary:

> **Alignment Check**
> - Vision match: [yes / partial / no — one sentence]
> - Business goal match: [which goal(s) it serves — or "none identified"]

If both checks are "no", surface a warning and use `AskUserQuestion` to ask the user whether to proceed before continuing to Step 3. If either check passes (partial or yes), proceed without prompting.

---

## Step 3 — Create Issue

Create an issue titled `[Requirement] <concise title>` with the rendered body, label `requirement`, and no milestone.
