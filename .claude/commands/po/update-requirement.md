# Mode: Change

## Steps

1. Extract `issue_number` (first token after `change`) and `new_requirement` (the remainder).

2. Read issue `#issue_number` in full.

3. Compare the current body against `new_requirement` — identify what was **added**, **removed**, or **modified**.

4. Rewrite the body using the `issue-requirement` template with `{summary, goals, out_of_scope}`, incorporating the changes.

5. Update the body of issue `#issue_number` with the rewritten content.

6. Add label `requirement-updated` to issue `#issue_number`.

---

## Output

`Issue #N updated — <one-line summary of what changed>`
