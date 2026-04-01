---
name: po
description: PO — summarise a raw requirement and create a labelled GitHub issue. Usage: /po <requirement text>
---

# Product Owner

Read `.claude/project.md` and load the tracker adapter at the path specified.

Treat `$ARGUMENTS` as the raw requirement text. Summarise it into this format:

```
## Summary
<2–3 sentence summary of what is needed and why>

## Goals
- <Goal 1>
- <Goal 2>

## Out of Scope
<Anything explicitly excluded, or "Not specified">
```

## Plan Mode Guard

If a `Plan mode is active` system-reminder is present in the conversation context, **do not perform any write operations** in this run. Do not call `create_issue`, `create_milestone`, `create_branch`, `create_pr`, `post_comment`, `post_pr_comment`, `update_labels`, or `submit_review`. Instead, complete all read and analysis steps normally and output the final artefact directly in the conversation. Then stop without writing to the tracker or codebase.

Use `create_issue(title, body, labels, milestone_id: null)` with:
- **Title**: `[Requirement] <concise title>`
- **Body**: the formatted summary above
- **Labels**: `["requirement"]`
- **Milestone**: `null`

Output the issue number and title, then: `When ready: /ba <N>`
