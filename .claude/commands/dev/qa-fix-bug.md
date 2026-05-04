# Mode: QA Fix (Bug)

The bug issue has `qa-blocked` — one or more test cases failed after the fix was deployed to staging. Fix only the failing cases. Do not re-implement already-passing work.

---

## Step 1 — Gather Context in Parallel

1. **Issue body + comments** — the ticket already fetched in Step 1 (hold it). Extract ACs.

2. **QA test cases comment** — search for comment with heading `## QA Test Cases`. Read in full. Identify all failing test cases: any `- [ ]` item that is unchecked. These are the primary scope driver — fix only what failed here.

3. **Investigation comment** — search for comment with heading `## Bug Investigation`. Extract Root Cause, Scope, Fix Approach, Risk verbatim — this is the architectural context for the fix.

---

## Step 2 — Git Setup

Checkout the existing bugfix branch for issue `<ISSUE_NUMBER>` in each in-scope codebase path.

For multi-skill bugs, run independently in each codebase path.

---

## Step 3 — Dispatch to Skill Subagent

-> Follow `_dispatch-subagent.md`

In addition to standard context, pass the following to every subagent:

| Extra context | Source |
|---------------|--------|
| Root Cause, Scope, Fix Approach, Risk | Verbatim from investigation comment |
| Failing test cases | Verbatim from QA test cases comment — all unchecked `- [ ]` items |
| Instruction | "Fix only the failing test cases. Do not re-implement already-passing work. Do not modify files unrelated to the failing cases." |

---

## Step 4 — Commit and Push

Commit and push all changed files to the existing bugfix branch.
Commit message: `fix(#<ISSUE_NUMBER>): address qa-blocked items`

---

## Step 5 — Merge to Staging

Push the bugfix branch to remote for each codebase path.

Merge the bugfix branch into the staging branch for each codebase path to deploy the fix for QA re-verification.

---

## Step 6 — Update Implementation Comment

Find the existing `## Implementation Complete` comment on issue `#ISSUE_NUMBER`.

Update only the human gate line:

```
> ⏸ Human gate: Fix deployed to staging — re-verify and run `/qa pass <ISSUE_NUMBER>` or `/qa block <ISSUE_NUMBER> <notes>`.
```

Do NOT remove `qa-blocked` label — QA re-verifies and calls `/qa pass` or `/qa block`.
