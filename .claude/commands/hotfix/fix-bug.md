
## Step 1 — Parse Arguments

Parse `$ARGUMENTS` as `<bug_issue> <bug_spec>`.

- `bug_issue` — issue number of the original bug being re-fixed.
- `bug_spec` — free-text describing what's still broken after the prior fix attempt.

If `bug_issue` is missing, halt and ask for it.

If `bug_spec` is empty, ask once via `AskUserQuestion` for a free-text description of the remaining defect. Hold the verbatim text as `$BUG_SPEC`.

---

## Step 2 — Fetch Bug and Gather Context in Parallel

Run in parallel:

1. **Bug issue body** — fetch issue `#<bug_issue>` in full. Verify the issue has the `bug-production` label. Otherwise halt:
   ```
   ⛔ Issue #<N> is not a bug (labels: <labels>). Use /feature fix-story for story issues.
   ```
   Extract Bug Report and Acceptance Criteria.
2. **Investigation comment** — search for the comment with heading `## Dev Investigation`. If missing, halt:
   ```
   ⛔ Run /hotfix implement <N> first; no prior investigation to revisit.
   ```
   Extract Root Cause, Scope, Fix Approach, Risk verbatim.
3. **TDD** *(optional)* — list issues labeled `technical-design` in the milestone. If found, read in full and extract: components design, API specification, data models, failure modes.

---

## Step 3 — Git Setup

Checkout the existing bugfix branch for issue `<bug_issue>`.

For multi-skill: run independently per codebase path.

---

## Step 4 — Dispatch Agents

Spawn only agents matching the `[tag]` in Fix Approach. Pass `<decisions type="investigation">` with Root Cause, Scope, Fix Approach, Risk verbatim, plus `<constraints>` containing:

```xml
<constraints>
  <bug_spec>[verbatim $BUG_SPEC]</bug_spec>
  <instruction>Fix only what is required by the new bug spec. Do not re-implement already-correct work. Do not modify files unrelated to the bug.</instruction>
</constraints>
```

---

## Step 5 — Commit and Push

Commit and push all changed files to the existing branch.
Commit message: `fix(#<BUG_ISSUE>): revise bug fix per follow-up spec`

---

## Step 6 — Update Implementation Comment

Find the existing `## Implementation Complete` comment on issue `#<bug_issue>`.

Update only the human gate line to:

```
> ⏸ Fix pushed to staging — please re-verify.
```
