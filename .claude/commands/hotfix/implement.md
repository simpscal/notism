
Implement **one bug fix per invocation** — do not batch.

Check labels on the fetched issue:
- Must have `bug-production`. Otherwise halt: `⛔ Issue #<N> is not a bug (labels: <labels>). Use /feature implement for stories.`
- Has `story-updated` → **Revisit branch** — ACs changed after the fix began; implement the delta only.
- Otherwise → **Fresh branch** — full investigation and fix from scratch.

Both branches share Step 1 (context) and most later steps. Branch-specific steps are tagged below.

---

## Step 1 — Fetch Issue and Context

Read issue `#bug_issue_number` in full. Add label `in-progress`.

From the issue body extract:
- Bug Report (Description, Steps to Reproduce, Expected Behaviour, Actual Behaviour, Severity)
- Acceptance Criteria section

**TDD** *(optional)* — if the issue belongs to a milestone, list issues labeled `technical-design` in that milestone. If found, read in full and extract:
- High-level diagram
- Components design
- Data models
- API specification
- Security
- Failure modes

Pass extracted sections to the subagent as architectural context alongside the investigation.

---

## Step 2 — Root Cause Investigation

Inspect the relevant source files.

**Revisit branch:** Re-evaluate the root cause in light of the **updated** ACs. Produce a fresh investigation — do not carry over content from the prior investigation comment.

Derive:

- **Root Cause** — plain language: why the bug occurs (no file paths, class names, or layer names)
- **Scope** — plain language: which product area / user-facing surface is affected (no file paths or layer names)
- **Fix Approach** — technical: what to change (not how to code it); opens with `[frontend]`, `[backend]`, or `[devops]` tag
- **Risk** — `Low — logic fix only` / `Medium — migration required: <details>` / `High — <impact>`
- **Complexity** — `S` (<4h, isolated) / `M` (4-8h, one layer) / `L` (>8h, cross-cutting)

---

## Step 3 — Post Investigation Comment

Render the `comment-dev-investigation` template with `{complexity, root_cause, scope, fix_approach, risk}`.

**Fresh branch:** Post as a new comment on issue `#issue_number`.

**Revisit branch:** **Replace** the existing `## Dev Investigation` comment entirely — do not carry over old content.

---

## Step 4 — Git Setup

**Fresh branch:** `cd` into each relevant codebase path, checkout `main`, and pull latest. For multi-skill bugs, run checkout independently in each codebase path.

**Revisit branch:** Find the open bugfix PR for issue `<N>` (collect as `$FIX_PRS`). If no open PR, halt with comment: `No open bug-fix PR found. Use /hotfix implement <N> on a fresh issue state, not a revisit.` Check out the bugfix branch for issue `<N>` and pull latest from remote.

---

## Step 5 — [Revisit branch only] Diff Analysis

Fetch PR(s) from Step 4. Produce a **delta summary**:

| Section | Content |
|---------|---------|
| Already implemented / correct | Fixes still satisfied — do not change |
| New / changed ACs | ACs in the updated issue not yet satisfied |
| Removed ACs | ACs from original PR no longer in the updated issue |
| Affected files | Files already in the PR — do not duplicate work |

---

## Step 6 — Dispatch Agents

Spawn only agents whose domain matches the `[tag]` in Fix Approach (e.g. `[backend]` → `backend`; `[frontend]` → `frontend`; `[devops]` → `devops`). For multi-domain fixes, spawn all matching agents in a single parallel message.

Pass context as a `<context>` XML block with `<decisions type="investigation">` containing Root Cause, Scope, Fix Approach, Risk verbatim.

**Revisit branch:** Also include `<constraints>` containing the delta summary and:

```xml
<instruction>Implement the delta only. Revert code for removed ACs. Add code for new/changed ACs. Do not modify files already correct under the new ACs.</instruction>
```

---

## Step 7 — [Fresh branch only] Git Branch Setup

For each subagent that returned `<no_work>` — skip, no branch needed.

For each subagent that completed work:
- Derive the bugfix branch name from the issue number and title
- Create bug branch in that codebase path

---

## Step 8 — Commit and Push

Commit and push all changed files in each codebase path using the files each subagent reported.

**Fresh branch:** `fix(#<ISSUE_NUMBER>): <imperative-tense description>`

**Revisit branch:** `fix(#<ISSUE_NUMBER>): revise bug fix per updated ACs`

---

## Step 9 — [Fresh branch only] Open PR

Open a pull request from the bug branch into `main` from inside the codebase path:

**PR title:** `fix(#<ISSUE_NUMBER>): <short description>`
**PR body:** Render the `pr-bug` template with `{root_cause, fix, acceptance_criteria, risk, parent_issue: <ISSUE_NUMBER>, parent_issue_url: $(gh issue view <ISSUE_NUMBER> --json url -q .url)}`

For multi-skill bugs, open one PR per skill — each from its own codebase path, each targeting `main`.

_(Revisit branch reuses the existing open PR — no new PR action needed.)_

---

## Step 10 — [Revisit branch only] Remove Label

Remove the `story-updated` label from the issue.

---

## Step 11 — Notify

Notify implementation complete.
