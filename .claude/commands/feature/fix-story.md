
The issue has `qa-blocked` — one or more test cases failed. Fix only the failing cases. Do not re-implement already-passing work.

---

## Step 1 — Determine Type and Gather Context in Parallel

Check issue labels:
- Has `bug-production` AND `qa-blocked` → **Type = Bug**
- Has `qa-blocked` (without `bug-production`) → **Type = Story**

Gather in parallel:

1. **Issue body** (already fetched). Extract ACs.
2. **QA test cases comment** — search for comment with heading `## QA Test Cases`. Read in full. Identify all failing test cases: any `- [ ]` item that is unchecked. These are the primary scope driver — fix only what failed here.
3. **[Bug path only] Investigation comment** — search for comment with heading `## Dev Investigation`. Extract Root Cause, Scope, Fix Approach, Risk verbatim.
4. **TDD** *(optional)* — list issues labeled `technical-design` in the milestone. If found, read in full and extract: components design, API specification, data models, failure modes.
5. **Design Instructions** (frontend only) — derive the requirement issue from the story's milestone. Find the design hub comment on the requirement issue (matched by body prefix `## Design Navigation`) and locate the row(s) for the story's surface(s). For each affected surface, read `<orchestrator-root>/sprint-<N>/instructions/<surface-slug>.md` from the orchestrator's sprint branch.

---

## Step 2 — Git Setup

**Story path:** Checkout the existing story branch for issue `<ISSUE_NUMBER>`.
**Bug path:** Checkout the existing bugfix branch for issue `<ISSUE_NUMBER>`.

For multi-skill: run independently per codebase path.

---

## Step 3 — Dispatch Agents

**Story path:** Spawn `backend`, `frontend`, and `devops` in a single parallel message. Pass context per dispatch-agents protocol with `<constraints>` containing:

```xml
<constraints>
  <failing_test_cases>[verbatim unchecked - [ ] items from QA test cases comment]</failing_test_cases>
  <instruction>Fix only the failing test cases. Do not re-implement already-passing work. Do not modify files unrelated to the failing cases.</instruction>
</constraints>
```

**Bug path:** Spawn only agents matching the `[tag]` in Fix Approach. Pass `<decisions type="investigation">` with Root Cause, Scope, Fix Approach, Risk verbatim, and `<constraints>` containing:

```xml
<constraints>
  <failing_test_cases>[verbatim unchecked - [ ] items from QA test cases comment]</failing_test_cases>
  <instruction>Fix only the failing test cases. Do not re-implement already-passing work. Do not modify files unrelated to the failing cases.</instruction>
</constraints>
```

---

## Step 4 — Commit and Push

Commit and push all changed files to the existing branch.
Commit message: `fix(#<ISSUE_NUMBER>): address qa-blocked items`

---

## Step 5 — Update Implementation Comment

Find the existing `## Implementation Complete` comment on issue `#ISSUE_NUMBER`.

Update only the human gate line:

```
> ⏸ Human gate: Fix deployed to staging — re-verify and run `/qa pass <ISSUE_NUMBER>` or `/qa block <ISSUE_NUMBER> <notes>`.
```

Do NOT remove `qa-blocked` label — QA re-verifies and calls `/qa pass` or `/qa block`.
