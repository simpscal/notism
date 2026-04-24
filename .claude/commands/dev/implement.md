# Mode: Standard

Implement **one ticket per invocation** — do not batch.

---

## S1 — Gather Story Context in Parallel

1. **Issue body + comments** — the ticket already fetched in Step 1 (hold it)

2. **TDD** — `list_issues(milestone_id, labels: [technical-design label from project config])` to find it, then `fetch_issue(tdd_number)` to read full content. Extract:
   - Problem statement
   - Proposed solution
   - Architecture key decisions
   - Components design
   - API specification
   - Data models
   - Risks
   - Implementation priority

3. **Design Instructions** (frontend only) — `list_issues(milestone_id, labels: [design-reviewed])` to find the design instructions issue. `fetch_issue` it in full — the document covers the entire sprint's UI design.

---

## S2 — Git Setup

- `base_branch` = sprint branch (`feature/sprint-{N}`)
- Branch name from git-strategy Story pattern: `feature/issue-{N}-{short-description}` (single-skill) or `feature/issue-{N}-{short-description}-backend` / `-frontend` (multi-skill)
- If sprint branch does not exist, halt: "Sprint feature branch `<sprint-branch>` not found in `<codebase-path>`."

`cd` into the codebase path for the relevant skill, then:

```bash
git fetch origin
git checkout <base_branch> && git pull
git checkout -b <story-branch>
git push -u origin <story-branch>
```

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

Use `create_pr(title, body, head: story-branch, base: base_branch)` from inside the codebase path:

**PR title:** `feat(#<ISSUE_NUMBER>): <short description>`
**PR body:** Use `render_template("pr-story", {summary, changes, test_command, lint_command, manual_verification, acceptance_criteria, closes})`

For multi-skill stories, open one PR per skill — each from its own codebase path, each targeting the sprint branch.

---

## S6 — Notify

-> Follow `_notify-complete.md`
