# Mode: Bug AC Change

Extract `issue_number` (the token after `amend-bug`).

---

## Step 1 — Fetch Issue and Validate Type

1. `fetch_issue(issue_number)` — read title, body, labels, milestone in full.
2. If labels do NOT contain `bug` → stop immediately and output:
   > ⚠️ Cannot proceed: Issue #`<issue_number>` does not have a `bug` label.
3. Extract current AC state:
   - Locate the `## Acceptance Criteria` section in the body.
   - List all existing ACs as the **baseline AC set**.
   - If no `## Acceptance Criteria` section exists: treat baseline as empty.

---

## Step 2 — Discovery: What Is Changing and Why

Provide context before opening dialogue:

> "I have read issue #`<issue_number>`: **`<title>`**. It currently has `<N>` acceptance criteria. I need to understand exactly what you want to change."

Run a discovery session. Focus on:
- Which specific ACs are incorrect, incomplete, or no longer valid?
- What new behaviour needs to be covered that is not in the current ACs?
- What is the reason for this change? (scope refinement, misdiagnosed bug, post-fix feedback)
- Is this change self-contained to this issue, or does it imply changes to related issues?

Do not proceed to Step 3 until all discovery questions are resolved.

---

## Step 3 — Classify AC Changes

Classify every AC. Produce a **Classification Table**:

| # | AC Text (abbreviated) | Classification | Detail |
|---|---|---|---|
| 1 | _existing AC text_ | Kept / Removed / Modified | — or old→new |
| — | _new AC text_ | Added | — |

Every existing AC must have an explicit classification. "Kept" is valid — it means no change.

---

## Step 4 — Present Change Plan and Gate on Approval

Use `AskUserQuestion` to present:

```
## Bug AC Change Plan — Issue #<N>: <title>

**Added ACs** (<count>):
- [ ] <new AC text>

**Removed ACs** (<count>):
- <original AC text> ← removing

**Modified ACs** (<count>):
- Before: <old text>
  After:  <new text>

**Unchanged ACs** (<count>): (listed for completeness)
- [ ] <unchanged AC text>
```

Ask: *"Please confirm this change plan, or specify adjustments before I proceed."*

Do NOT call any mutating operation until the user confirms.

---

## Step 5 — Execute

After user approval:

1. Reconstruct the full issue body:
   - Locate the `## Acceptance Criteria` section.
   - Rewrite ONLY that section using the approved AC set (Added + Modified + Unchanged; omit Removed).
   - Do NOT modify, reorder, or touch any content in or before the `## Bug Report` section.
   - Preserve any `## Notes` section if present; update only if discovery surfaced changes.

2. `update_issue_body(issue_number, updated_body)`

3. `update_labels(issue_number, add: ["story-updated"], remove: [])`
