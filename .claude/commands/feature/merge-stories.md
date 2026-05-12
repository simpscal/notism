
Extract `target_issue_number` (first token after `merge-stories`) and `source_issue_numbers` (all remaining tokens).

---

## Step 1 — Fetch and Validate Issues

1. Read target issue `#target_issue_number` in full — title, body, labels, milestone.
2. Read each source issue in full — title, body, labels, milestone.
3. Validate every issue has the `user-story` label. If any does not, stop:
   > ⚠️ Cannot proceed: Issue #`<issue_number>` does not have a `user-story` label.
4. Validate all issues belong to the same sprint milestone. If they differ, stop:
   > ⚠️ Cannot proceed: Issues span multiple milestones (`<A>` and `<B>`). All stories must be in the same sprint.
5. Extract the AC baseline from each issue (`## Acceptance Criteria` section).
   - If a section is absent, treat its AC set as empty.

---

## Step 2 — Discovery: Dependency Rationale

Provide context before opening dialogue:

> "I have read **#`<target>`: `<target_title>`** (target) and **`<count>` source `<story/stories>`**: `<#N: title, ...>`. I need to understand why these stories cannot be tested independently before I consolidate them."

Synthesise first. State:
- What each story does in user-visible terms.
- The dependency relationship between them (e.g. source story relies on target's data/state to be testable).

Open dialogue via `AskUserQuestion`:
- *"Here is what I understand about each story and their dependency — please correct anything wrong."*
- Ask any unresolved questions: Is the target story the right survivor? Should any ACs from source stories be dropped rather than absorbed? Are there Notes or edge cases in source stories that are still relevant?

Do not proceed to Step 3 until the rationale and scope are unambiguous.

---

## Step 3 — Build Merge Plan

Classify every AC from every source issue:

| Source | # | AC Text (abbreviated) | Action |
|--------|---|-----------------------|--------|
| #N     | 1 | ...                   | Absorb / Drop |

- Default action is **Absorb** unless the PO explicitly said to drop an AC.
- Every **Drop** requires an explicit justification from the discovery session.

Present:
- Target story's existing ACs (unchanged, listed for completeness).
- ACs to absorb per source story.
- ACs to drop (if any) with justification.
- Source stories to be closed after merge.

---

## Step 4 — Present Merge Plan and Gate on Approval

Use `AskUserQuestion` to present:

```
## Merge Plan

**Target**: #<N> — <title>
**Sources to close**: #<N>, #<N>

**Target AC set after merge** (<total count> total):

Existing (<count>):
- [ ] <AC>

Absorbed from #<N> — <source_title> (<count>):
- [ ] <AC>

Absorbed from #<N> — <source_title> (<count>):
- [ ] <AC>

Dropped (<count>): (if any)
- <AC> ← <justification>
```

Ask: *"Please confirm this merge plan, or specify adjustments before I proceed."*

Do NOT call any mutating operation until the user confirms.

---

## Step 5 — Execute

After user approval:

1. Reconstruct target issue body:
   - Preserve `## User Story` verbatim.
   - Rewrite `## Acceptance Criteria` with: existing ACs first, then absorbed ACs grouped by source (in the order sources were provided), each group preceded by an HTML comment `<!-- Absorbed from #<N> -->`.
   - Update `## Notes`: append a line `Merged from: #<source1>[, #<source2>...] — <one-line rationale from discovery>`. Do not remove existing valid notes.
   - Preserve all other sections and the footer (`Part of #req_issue`) verbatim.

2. Update the body of issue `#target_issue_number` with the reconstructed content.

3. Add label `story-updated` to issue `#target_issue_number`.

4. For each source issue:
   - Add label `story-removed`.
   - Post comment:
     > Merged into #`<target_issue_number>` — story consolidated due to untestable dependency.

5. Report:
   ```
   Target #<N> updated: absorbed <X> ACs from <Y> stories.
   Closed: #<N>, #<N>
   ```

---

## Constraints

- Never drop ACs without explicit PO justification from discovery
- Never invent new ACs during the merge
- Never mutate any issue until the user confirms the merge plan
- The target story's `## User Story` statement is never modified
- Source stories are always closed after a successful merge — partial merges are not permitted
