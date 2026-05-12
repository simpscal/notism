
---

## Step 1 — Check File Exists

Check the repo root for `DESIGN.md`. If absent, stop: "`DESIGN.md` not found — run `/design-system create` first."

---

## Step 2 — Load Current State

Read `DESIGN.md` in full. Capture:

- Every color token name and hex value
- Every typography scale name and its properties
- Every rounded, spacing, and component token
- The prose in every markdown section

Hold this as the **baseline**. Do not proceed until the full file is loaded.

---

## Step 3 — Open Amendment Dialog

Ask a single `AskUserQuestion`:

> What do you want to change? Describe the addition, update, or removal — for tokens, components, or prose sections.

Hold the response as **$CHANGE_INPUT**.

If $CHANGE_INPUT is ambiguous (e.g. "update the colors" with no specifics), ask one follow-up to clarify the exact target and direction before proceeding.

---

## Step 4 — Apply Changes

Edit `DESIGN.md` directly. Rules:

- **Tokens (colors, typography, rounded, spacing, components)**: edit only the affected entries in the YAML frontmatter. Preserve all other token names and values exactly.
- **Prose sections**: edit only the affected section(s). Preserve all other sections verbatim.
- **New tokens**: add them in the correct YAML block, grouped with related tokens. Add a corresponding entry in the relevant prose section.
- **Removed tokens**: remove from frontmatter and from any component or prose reference. Do not leave dangling `{colors.*}` or `{typography.*}` references.
- **Do not invent.** New tokens or components must come from the codebase or be explicitly provided by the user.
- **Preserve existing token names.** Do not rename tokens to match spec recommendations.

---

## Step 5 — Validate

Run the linter:

```bash
npx -y @google/design.md lint DESIGN.md
```

Fix any **errors** (broken token refs, invalid hex, schema violations) and re-run until the error count is zero. Warnings do not block.

---

## Step 6 — Report

Show a concise summary of what changed:

```
Tokens: Added <N> · Updated <N> · Removed <N>
Components: Added <N> · Updated <N> · Removed <N>
Sections updated: <list>
Linter: <N> errors · <N> warnings
```
