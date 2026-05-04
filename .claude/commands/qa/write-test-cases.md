# Mode: Write Test Cases

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

## Step 2 — Generate Test Cases

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

## Step 3 — Post Test Cases Comment

Render the `comment-qa-test-cases` template with `{issue_number, story_title, test_cases}`, then post it as a comment on issue `#story_number`.

Output:
```
✓ Test cases posted on #story_number — <title>
  ACs covered: N
  Test cases written: N
```
