# Mode: Standard

Implement **one ticket per invocation** — do not batch.

---

## S1 — Gather All Story Context in Parallel

-> Follow `_gather-context.md`

---

## S2 — Git Setup

`cd` into the codebase path for the relevant skill. Create the story branch (follow the branch naming strategy) from the sprint branch:

```bash
git fetch origin
git checkout <sprint-branch> && git pull
git checkout -b <story-branch>  # name from git-strategy Story pattern
git push -u origin <story-branch>
```

If the sprint branch does not exist, halt: "Sprint feature branch `<sprint-branch>` not found in `<codebase-path>`."

For multi-skill stories, run setup independently in each codebase path.

---

## S3 — Dispatch to Skill Subagent

-> Follow `_dispatch-subagent.md`

---

## S4 — Commit and Push

Once all subagents complete:

-> Follow `_commit-push.md`

---

## S5 — Open PR

Use `create_pr(title, body, head: story-branch, base: sprint-branch)` from inside the codebase path:

**PR title:** `feat(#<ISSUE_NUMBER>): <short description>`
**PR body:** Use `pr-story.md`

For multi-skill stories, open one PR per skill — each from its own codebase path, each targeting the sprint branch.

---

## S6 — Notify

-> Follow `_notify-complete.md`
