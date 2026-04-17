# Mode: Bug

**Usage**: `/tl bug <bug_issue_number>`

`fetch_issue(bug_issue_number)` to read the bug report in full. No TDD issue is created. No feature branches are created. The bug ticket is annotated directly.

---

## T1 — Read the Bug Issue in Full

`fetch_issue(bug_issue_number)` to read: title, description, reproduction steps, expected/actual behaviour, severity, `## Acceptance Criteria` (added by `/ba`), and all comments.

---

## T2 — Read the Architecture

-> Read each codebase's `CLAUDE.md`, scoped to the bug's affected area.

---

## T3 — Resolve Blocking Questions

-> Follow `_resolve-questions.md`

---

## T4 — Design the Fix Approach

Produce a concise technical analysis covering:

| Area | Content |
|------|---------|
| Root cause | Which layer/module is likely responsible and why |
| Scope | Specific files and layers that need to change |
| Fix approach | What to implement (1–3 sentences, no code) |
| Key decisions | At least one decision with rationale |
| Risk | Schema change? Migration? Rollback plan? Or "Low — logic fix only" |

---

## T5 — Determine Skill

Based on T4's scope:
- API / domain / persistence changes -> `skill:backend`
- UI / component / state changes -> `skill:frontend`
- Both -> `skill:backend` + `skill:frontend`

---

## T6 — Annotate the Bug Ticket

Use `comment-tl-annotation.md`, then `post_comment(<N>, body)`.

Then `update_labels(<N>, add: [tl-reviewed, skill:<label(s)>], remove: [])`.

```
## Technical Review Complete

**Skill**: <frontend | backend | both>
**Complexity**: <S | M | L>

---
> Pause Human gate: Review the technical annotation above.
> When ready: `/dev <N>`
```
