# Bug Revisit — Mode: Bug AC Change

## When to Use

The BA has amended the ACs on a bug issue (labeled `bug-production` + `story-updated`) that has an **open** PR. The fix must be updated to satisfy the new ACs.

## Step 1 — Gather Context

Read issue `#issue_number` in full.

List open pull requests with branch prefix `fix/issue-{N}-` to find the open bug-fix PR. Collect as `$FIX_PRS`.

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

Check out the existing `fix/issue-{N}-` branch, pull latest from remote.

---

## Step 6 — Dispatch to Skill Subagent

Follow `_dispatch-subagent.md`. Pass:

- Updated investigation verbatim (Root Cause, Scope, Fix Approach, Risk, Complexity)
- Delta summary from Step 4
- Affected file list from Step 4
- Explicit instruction: "Implement the delta only. Revert code for removed ACs. Add code for new/changed ACs. Do not modify files that are already correct under the new ACs."

---

## Step 7 — Commit and Push

Follow `_commit-push.md`. Commit message: `fix(#<ISSUE_NUMBER>): revise bug fix per updated ACs`.

---

## Step 8 — Remove Label

Remove the `story-updated` label from the issue.