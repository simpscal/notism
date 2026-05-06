# Mode: Bug AC Change

## When to Use

The BA has amended the ACs on a bug issue (labeled `bug-production` + `story-updated`) that has an **open** PR. The fix must be updated to satisfy the new ACs.

## Step 1 — Gather Context

Read issue `#issue_number` in full.

List open bugfix PRs for issue `<N>` to find the open bug-fix PR. Collect as `$FIX_PRS`.

Add label `in-progress` to issue `#issue_number`.

If no open PR found: halt with a comment noting no open fix PR exists — use `fix-bug` mode for a fresh start.

---

## Step 2 — Root Cause Investigation

Evaluate the root cause in light of the new ACs.

Produce a fresh investigation with the six fields:

```
- Root Cause: why the bug occurs under the new ACs
- Scope — which product area/user-facing surface is affected by the change
- Fix Approach — technical: what to change, tagged [frontend] / [backend] / [devops]
- Risk — Low / Medium (with migration details) / High
- Complexity — S (<4h, isolated) / M (4-8h, one layer) / L (>8h, cross-cutting)
```

---

## Step 3 — Replace Investigation Comment

Replace the existing `## Dev Investigation` comment on the issue with the new investigation. Overwrite entirely — do not carry over or reference the old content.

---

## Step 4 — Diff Analysis

Fetch the open PR. Extract:

| Column | Content |
|--------|---------|
| Already correct | Fixes/code that still satisfy the new ACs — do not remove or change |
| New / changed ACs | Bug ACs that are new or different from the original — must be implemented |
| Removed ACs | Original bug ACs that no longer appear in the updated issue — must be reverted |
| Affected files | Files already modified in the existing PR — do not duplicate prior work on these unless an AC requires it |

Pass this delta summary to every subagent with an explicit instruction: **implement the delta only**. Do not re-implement what is already correct. Do not leave in place code that was removed from the ACs.

---

## Step 5 — Git Setup

Check out bugfix branch for issue `<N>` and pull latest from remote.

---

## Step 6 — Dispatch Agents

Spawn only agents whose domain matches the `[tag]` in Fix Approach. Pass context as a `<context>` XML block per the dispatch-agents protocol, with `<decisions type="investigation">` and `<constraints>` containing:

```xml
<constraints>
  <investigation>[Root Cause, Scope, Fix Approach, Risk, Complexity verbatim from new investigation]</investigation>
  <delta_summary>[delta table from Step 4]</delta_summary>
  <affected_files>
    <file>[filename from existing PR]</file>
  </affected_files>
  <instruction>Implement the delta only. Revert code for removed ACs. Add code for new/changed ACs. Do not modify files that are already correct under the new ACs.</instruction>
</constraints>
```

---

## Step 7 — Commit and Push

Commit and push all changed files from this implementation in each codebase path. Commit message: `fix(#<ISSUE_NUMBER>): revise bug fix per updated ACs`.

---

## Step 8 — Remove Label

Remove the `story-updated` label from the issue.