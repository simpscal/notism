# Mode: Story Change

Extract `issue_number` (the token after `amend-story`).

---

## SC1 — Fetch Issue and Validate Type

1. `fetch_issue(issue_number)` — read title, body, labels, milestone in full.
2. If labels do NOT contain `user-story` → stop immediately and output:
   > ⚠️ Cannot proceed: Issue #`<issue_number>` does not have a `user-story` label.
3. Extract current AC state:
   - Locate the `## Acceptance Criteria` section in the body.
   - List all existing ACs as the **baseline AC set**.
   - If no `## Acceptance Criteria` section exists: treat baseline as empty.

---

## SC2 — Discovery: What Is Changing and Why

Provide context before opening dialogue:

> "I have read issue #`<issue_number>`: **`<title>`**. It currently has `<N>` acceptance criteria. I need to understand exactly what you want to change."

Run a discovery session. Focus on:
- Which specific ACs are incorrect, incomplete, or no longer valid?
- What new behaviour needs to be covered that is not in the current ACs?
- What is the reason for this change? (scope refinement, bug in the ACs, post-demo feedback)
- Is this change self-contained to this story, or does it imply changes to related stories?

Do not proceed to SC3 until all discovery questions are resolved.

---

## SC3 — Classify AC Changes

Classify every AC. Produce a **Classification Table**:

| # | AC Text (abbreviated) | Classification | Detail |
|---|---|---|---|
| 1 | _existing AC text_ | Kept / Removed / Modified | — or old→new |
| — | _new AC text_ | Added | — |

Every existing AC must have an explicit classification. "Kept" is valid — it means no change.

---

## SC4 — Present Change Plan and Gate on Approval

Use `AskUserQuestion` to present:

```
## Story Change Plan — Issue #<N>: <title>

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

## SC5 — Execute

After user approval:

1. Reconstruct the full issue body:
   - Rewrite the `## Acceptance Criteria` section using the approved AC set (Added + Modified + Unchanged; omit Removed).
   - Update `## Notes` if the discovery session surfaced new edge cases or dependency changes. Do not remove existing valid notes.
   - Preserve all other sections verbatim (User Story statement, `---` footer, `Part of` link).

2. `update_issue_body(issue_number, updated_body)`

3. `update_labels(issue_number, add: ["story-updated"], remove: [])`
