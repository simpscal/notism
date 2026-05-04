# Mode: Pass

Extract `story_number` (the token after `pass`).

Called by the human tester after verifying all test cases pass.

---

## Step 1 — Fetch Issue

Read issue `#story_number` — get title and labels.

Guard checks (stop if any fail):
- Must have label `user-story` or `bug-production` — otherwise: `⛔ Issue #N is not a user story or bug.`
- Must have label `implemented` — otherwise: `⛔ Issue #N is not yet implemented.`

---

## Step 2 — Update Labels

1. Add label `qa-passed`
2. Remove label `qa-blocked` (if present)

---

## Step 3 — Human Gate

Output:
```
✓ #story_number marked qa-passed — <title>

⏸ Human gate: Merge the story branch into the sprint branch.
```
