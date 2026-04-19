# Mode: Change

**Usage**: `/po change <issue_number> <new requirement text>`

---

## Steps

1. Extract `issue_number` (first token after `change`) and `new_requirement` (the remainder).

2. `fetch_issue(issue_number)` — read the current body in full.

3. Compare the current body against `new_requirement` — identify what was **added**, **removed**, or **modified**.

4. Rewrite the body using `issue-requirement.md`, incorporating the changes.

5. `update_issue_body(issue_number, updated_body)`

6. `update_labels(issue_number, add: ["requirement-updated"], remove: [])`

---

## Output

`Issue #N updated — <one-line summary of what changed>`
