# Mode: Bug AC

Extract `issue_number` (the token after `amend-bug`).

---

## Step 1 — Fetch Issue and Validate Type

1. Read issue `#issue_number` in full — title, body, labels, milestone.
2. If labels do NOT contain `bug-production` → stop immediately and output:
   > ⚠️ Cannot proceed: Issue #`<issue_number>` does not have a `bug-production` label.
3. Extract current AC state:
   - Locate the `## Acceptance Criteria` section in the body.
   - List all existing ACs as the **baseline AC set**.
   - If no `## Acceptance Criteria` section exists: treat baseline as empty.

---

## Step 2 — Discovery: What Is Changing and Why

Provide context before opening dialogue:

> "I have read issue #`<issue_number>`: **`<title>`**. It currently has `<N>` acceptance criteria. I need to understand exactly what you want to change."

Run a full discovery session:

1. **Synthesise first.** State your current understanding of the bug, its intended behaviour, and its existing ACs.

2. **Surface every gap.** Identify which ACs are incorrect, incomplete, or no longer valid; what new behaviour needs coverage; the reason for the change (scope refinement, misdiagnosed bug, post-fix feedback); and whether the change affects related issues.

3. **Open the dialogue.** Ask all blocking questions in one structured message:
   - Lead: *"Here is what I understand — please correct anything wrong."*
   - Follow: *"Before I proceed, I need to clarify:"* — list specific questions.
   - Do NOT drip-feed questions one at a time.

4. **Incorporate and iterate.** After each response, re-synthesise. Repeat until fully unambiguous.

5. **Confirm alignment.** State final understanding before producing output.

Do not proceed to Step 3 until all discovery questions are resolved.

---

## Step 3 — Classify AC Changes

Classify every AC. Produce a **Classification Table**:

| # | AC Text (abbreviated) | Classification | Detail |
|---|---|---|---|
| 1 | _existing AC text_ | Kept / Removed / Modified | — or old→new |
| — | _new AC text_ | Added | — |

Every existing AC must have an explicit classification. "Kept" is valid — it means no change.

**AC testability checklist** — verify every Added or Modified AC:
- Observable without reading code?
- Describes a specific condition and a specific outcome?
- Could a non-engineer verify it in a running system?

Rewrite any AC that fails until it passes.

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

2. Update the body of issue `#issue_number` with the reconstructed content.

3. Add label `story-updated` to issue `#issue_number`.

4. Report:
   ```
   ACs: Added <N> · Removed <N> · Modified <N>
   ```

---

