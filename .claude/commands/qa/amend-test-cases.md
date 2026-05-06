# Mode: Amend Test Cases

Extract `story_number` (the token after `amend-test-cases`).

---

## Step 1 — Load Story Context

Read issue `#story_number` in full. Extract:
- Story title
- User story statement
- Acceptance criteria (each AC verbatim)
- Notes (edge cases, dependencies)
- Current labels

Search the issue's comments for one with the heading `## QA Test Cases`. Hold it as **$EXISTING_TEST_CASES**.

If no existing test cases comment is found, report:
```
ℹ No existing test cases found for #N. Run /qa write-test-cases <N> to generate them first.
```
Then stop.

---

## Step 2 — Reconstruct the Mental Model

Work through all loaded material silently. Produce no output in this step. Build the following understanding:

- What does each current AC require to be true?
- Which test cases in $EXISTING_TEST_CASES map to which ACs?
- Are there ACs with no corresponding test case, or test cases with no matching AC?
- What states, roles, and error paths are currently covered?
- What gaps or weak spots exist in the current coverage?

Complete when: you can state every AC, its current test coverage, and any coverage gaps — without re-reading.

Activate as QA specialist for story `#story_number`. State:

> QA specialist active — #N: <title>. Story context and existing test cases loaded. Ready to discuss changes or coverage gaps.

---

## Step 3 — Open Amendment Dialog

Ask the QA specialist a single `AskUserQuestion`:

> What changed in this story, and what should be tested differently? Describe the AC changes, new edge cases to cover, or gaps in the current test cases you want to address.

Hold the response as **$CHANGE_INPUT**. Do not proceed until answered.

Use $CHANGE_INPUT to engage in discussion — surface coverage gaps from the mental model, flag ACs with weak or missing error paths, discuss what new behaviour needs verification. Continue until the final scope of changes is confirmed.

---

## Step 4 — Clarify Ambiguities

Before revising, review changed or new ACs for the following signals:

| Signal | Example |
|--------|---------|
| No error path defined | AC describes happy path but no AC covers invalid input or failure |
| Vague quantifiers | Words like "recent", "large", "several" with no concrete definition |
| Missing role scoping | Action described without specifying which user roles it applies to |
| Undefined state dependency | AC assumes prior state not guaranteed elsewhere in the story |
| Conflicting ACs | Two ACs describe different outcomes for the same trigger |
| Validation rules without boundaries | Field must be "valid" or "correct" but limits are not stated |

If ambiguities are found: use `AskUserQuestion` — cite the specific AC verbatim, state what is unclear, offer 2–3 interpretations. Do NOT bundle unrelated questions. Do NOT proceed until resolved.

If no ambiguities are found, proceed directly to Step 5.

---

## Step 5 — Revise Test Cases

Using the confirmed changes from Step 3 and resolved ambiguities from Step 4, update the test cases:

| Change | Action |
|--------|--------|
| AC text changed | Regenerate that AC's test case section |
| New AC added | Add new section with test cases |
| AC removed | Remove that section |
| New edge case identified | Add case to the relevant AC section |
| AC unchanged, coverage gap found | Add missing edge/failure case |
| AC unchanged, coverage sufficient | Preserve section as-is |

**Test case rules:**
- Steps must be user-action steps — no code references
- Expected result must mirror the AC outcome exactly — observable without reading code
- Steps must be reproducible by a non-engineer against a running system
- If backend-only: steps describe observable state changes in the UI

Edit the existing test cases comment in-place with the revised content. Preserve unchanged sections including any manually filled pass/fail marks.

Output:
```
✓ Test cases updated on #story_number — <title>
  Added: N case(s)
  Updated: N case(s)
  Removed: N case(s)
  Preserved: N case(s)
```
