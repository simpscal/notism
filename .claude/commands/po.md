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

Use `create_issue(title, body, labels, milestone_id: null)` with:
- **Title**: `[Requirement] <concise title>`
- **Body**: the formatted summary above
- **Labels**: `["requirement"]`
- **Milestone**: `null`

Output the issue number and title, then: `When ready: /ba <N>`
