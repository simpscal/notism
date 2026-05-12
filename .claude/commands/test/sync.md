
Extract `story_number` (the token after `sync-test-cases`).

Called when a story has been amended (`story-updated` label) and its ACs have changed. Updates the existing QA test cases comment to match the current ACs.

---

## Step 1 — Fetch Story Context

Read issue `#story_number` in full. Extract current ACs verbatim.

---

## Step 2 — Find Existing Test Cases Comment

Search the issue's comments for one with the heading `## QA Test Cases`.

If no existing test cases comment found:
```
ℹ No existing test cases found for #N. Run /qa write-test-cases <N> to generate them.
```
Then stop.

---

## Step 3 — Diff ACs

Compare current ACs from the issue against the AC sections in the existing test cases comment:

| Change | Action |
|--------|--------|
| AC text changed | Regenerate that section's test cases |
| New AC added | Add new section with test cases |
| AC removed | Remove that section |
| AC unchanged | Preserve section as-is (including any manual pass/fail marks) |

---

## Step 4 — Clarify Ambiguities

For ACs marked as "changed" or "added" in the diff, review each for the following signals:

| Signal | Example |
|--------|---------|
| No error path defined | AC describes happy path but no AC covers invalid input or failure |
| Vague quantifiers | Words like "recent", "large", "several" with no concrete definition |
| Missing role scoping | Action described without specifying which user roles it applies to |
| Undefined state dependency | AC assumes prior state not guaranteed elsewhere in the story |
| Conflicting ACs | Two ACs describe different outcomes for the same trigger |
| Validation rules without boundaries | Field must be "valid" or "correct" but limits are not stated |

Only check changed/added ACs — do not re-examine unchanged ACs.

If ambiguities are found:
- Use `AskUserQuestion` — do NOT proceed to Step 5
- For each ambiguity: cite the specific AC verbatim, state what is unclear, and offer 2–3 possible interpretations where applicable
- Ask each question independently and specifically — do not bundle unrelated questions

Do NOT infer or invent missing business logic. If critical logic is undefined, it must be resolved here before proceeding.

If no ambiguities are found, proceed directly to Step 5.

---

## Step 5 — Update Comment

Edit the existing test cases comment in-place with the updated content.

Preserve:
- The header, PR links, footer (test environment, tested by, overall result)
- Test case rows for unchanged ACs (including any manually filled ☐ marks)

Regenerate only changed/added AC sections.

Output:
```
✓ Test cases updated on #story_number
  Added: N AC(s)
  Updated: N AC(s)
  Removed: N AC(s)
  Preserved: N AC(s)
```
