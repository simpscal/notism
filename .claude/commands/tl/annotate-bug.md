# Mode: Bug

`fetch_issue(bug_issue_number)` to read the bug report in full. No TDD issue is created. No feature branches are created. The bug ticket is annotated directly.

---

## T1 — Read the Bug Issue in Full

`fetch_issue(bug_issue_number)` to read: title, description, reproduction steps, expected/actual behaviour, severity, `## Acceptance Criteria` (added by `/ba`), and all comments.

Inspect labels:
- If `story-updated` is present → the ACs were amended after the TL annotation was written. Locate the existing `## Technical Lead Annotation` comment in the issue comments. Hold it as **current annotation** — subsequent steps will revise it, not produce a new design from scratch.
- If `story-updated` is absent → no existing annotation. Proceed with full analysis.

---

## T2 — Read the Architecture

-> Read each codebase's `CLAUDE.md`, scoped to the bug's affected area.

---

## T3 — Resolve Blocking Questions

Identify every decision that cannot be made from the code and bug report alone. Use `AskUserQuestion` to present all blocking questions in a single message. Do not proceed until every question is resolved.

---

## T4 — Design the Fix Approach

Apply the `tl` skill's **Bug Analysis Mode** to produce the fix design.

**If existing annotation found (story-updated path):**
Use the current annotation as the starting document. Evaluate each field against the AC changes — keep unaffected fields exactly, rewrite only affected fields. Do not redesign unaffected areas.

---

## T5 — Annotate the Bug Ticket

Use `render_template("comment-tl-annotation", {complexity, root_cause, scope, fix_approach, key_decisions, risk})` to produce the annotation body.

**If existing annotation (story-updated path):**
- Hold the existing comment's ID from the comments read in T1
- `update_comment(comment_id, updated_body)`

**If no existing annotation (new path):**
- `post_comment(<N>, body)`

Then `update_labels(<N>, add: [tl-reviewed], remove: [])`.

```
## Technical Review Complete

**Complexity**: <S | M | L>

---
> Pause Human gate: Review the technical annotation above.
> When ready: `/dev <N>`
```
