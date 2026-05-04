# Mode: Block

Extract `story_number` (first token after `block`) and `notes` (remaining text).

Called by the human tester when one or more test cases fail.

---

## Step 1 — Fetch Issue

Read issue `#story_number` — get title and labels.

Guard: must have label `user-story` or `bug-production` — otherwise: `⛔ Issue #N is not a user story or bug.`

If `notes` is empty, stop:
```
⛔ Notes required. Run: /qa block <story_number> <description of what failed>
```

---

## Step 2 — Update Labels

1. Add label `qa-blocked`
2. Remove label `qa-passed` (if present)

Output:
```
✓ #story_number marked qa-blocked — <title>
  Blocking reason: <notes>
  Next: run /dev <story_number> to fix the failing cases.
```
