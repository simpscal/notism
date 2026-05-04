# Comment: QA Test Cases

## OUTPUT FORMAT

```markdown
## QA Test Cases — #issue_number: story_title

---

### AC 1: ac_text

- [ ] **1.1 Happy path** — brief scenario label
  **Steps:** 1. Navigate to X 2. Click Y 3. Enter Z
  **Expected:** Expected outcome matching AC

- [ ] **1.2 Edge case** — brief scenario label
  **Steps:** 1. Navigate to X 2. Submit without filling field
  **Expected:** Expected outcome matching AC

### AC 2: ac_text

- [ ] **2.1 Happy path** — brief scenario label
  **Steps:** 1. Step one 2. Step two
  **Expected:** Expected outcome matching AC

- [ ] **2.2 Failure case** — brief scenario label
  **Steps:** 1. Step one
  **Expected:** Expected outcome matching AC

---

**Test environment:** staging
**Tested by:** _<!-- fill in -->_
```

---

## FIELDS

| Field | Req | Notes |
|-------|-----|-------|
| `issue_number` | yes | Story or bug issue number |
| `story_title` | yes | Exact title from issue |
| `test_cases` | yes | One `### AC N: <ac_text>` section per AC, each with `- [ ]` task list items |

## TEST CASE RULES

- Each AC gets its own `### AC N: <ac_text>` section — use the AC text verbatim as the heading
- Minimum 2 test cases per AC: 1 happy path + 1 edge or failure case
- Each test case is a `- [ ]` task list item — human checks it off when it passes; unchecked = not yet verified or failed
- Steps: user-action steps only — "Navigate to X", "Click Y", "Enter Z" — no code, no file paths
- Expected result: directly mirrors the AC outcome — observable without reading code
