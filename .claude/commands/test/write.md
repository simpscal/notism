
Extract `story_number` (the token after `write-test-cases`).

---

## Step 1 — Fetch Story Context

Read issue `#story_number` in full. Extract:
- Story title
- User story statement
- Acceptance criteria (each AC verbatim)
- Notes (edge cases, dependencies)
- Milestone (sprint number)
- Current labels

If the issue does not have the `user-story` or `bug-production` label, stop:
```
⛔ Issue #N is not a user story or bug. Use /qa write-test-cases only for user-story or bug-production issues.
```

If the issue does not have the `implemented` label, stop:
```
⛔ Issue #N is not yet implemented (missing `implemented` label). Write test cases after dev completes implementation.
```

If the issue already has `qa-passed`, confirm with the user before overwriting existing test cases.

---

## Step 2 — Clarify Ambiguities

Before writing any test cases, review all extracted ACs and notes for the following signals:

| Signal | Example |
|--------|---------|
| No error path defined | AC describes happy path but no AC covers invalid input or failure |
| Vague quantifiers | Words like "recent", "large", "several" with no concrete definition |
| Missing role scoping | Action described without specifying which user roles it applies to |
| Undefined state dependency | AC assumes prior state not guaranteed elsewhere in the story |
| Conflicting ACs | Two ACs describe different outcomes for the same trigger |
| Validation rules without boundaries | Field must be "valid" or "correct" but limits are not stated |

If ambiguities are found:
- Use `AskUserQuestion` — do NOT proceed to Step 3
- For each ambiguity: cite the specific AC or note verbatim, state what is unclear, and offer 2–3 possible interpretations where applicable
- Ask each question independently and specifically — do not bundle unrelated questions

Do NOT infer or invent missing business logic. If critical logic is undefined, it must be resolved here before proceeding.

If no ambiguities are found, proceed directly to Step 3.

---

## Step 3 — Generate Test Cases

For each AC in the story, generate a test case table:

**Per AC, write:**
- 1 happy-path case — golden path that directly satisfies the AC
- 1–2 edge or failure cases — boundary conditions, empty states, invalid input, or error paths relevant to the AC

**Test case rules:**
- Steps must be user-action steps (e.g. "Navigate to X", "Click Y", "Enter Z in the field") — no code references
- Expected result must mirror the AC outcome exactly — observable without reading code
- Steps must be reproducible by a non-engineer against a running system
- If the story is backend-only (no UI): steps describe API calls via the product UI that surfaces the data, or observable state changes in the UI

---

## Step 4 — Post Test Cases Comment

Render the `comment-qa-test-cases` template with `{issue_number, test_cases}`, then post it as a comment on issue `#story_number`.

Output:
```
✓ Test cases posted on #story_number — <title>
  ACs covered: N
  Test cases written: N
```
