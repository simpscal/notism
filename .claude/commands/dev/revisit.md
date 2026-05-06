# Mode: Revisit (Story or Bug)

The issue has `story-updated` — ACs changed after implementation began. Implement the delta only.

---

## Step 1 — Determine Type

The issue was already fetched. Check labels:
- Has `story-updated` AND `user-story` → **Type = Story**
- Has `story-updated` AND `bug-production` → **Type = Bug**
- Neither `user-story` nor `bug-production` → halt: `⛔ Issue #N has story-updated but is neither a user story nor a bug.`

---

## Step 2 — Gather Context

**Story path — run all three in parallel:**

1. Hold issue body + comments. Extract current ACs.
2. **TDD** *(optional)* — list issues labeled `technical-design` in the milestone. If found, read in full and extract:
   - Problem statement, Goals, High-level diagram, Integration flows (happy + unhappy path), Technology stack, Components design, Infrastructure design, Data models, API specification, Event schemas, Security, Failure modes, Migration plan, Implementation priority.
3. **Design Instructions** (frontend only) — list issues labeled `design` in the milestone. Read in full.

**Bug path:**

1. Hold issue body. Extract: bug report (Description, Steps to Reproduce, Expected Behaviour, Actual Behaviour, Severity) and Acceptance Criteria.
2. Find open bugfix PR for issue `<N>`. Collect as `$FIX_PRS`. Add label `in-progress`.
   - If no open PR: halt with comment — "No open bug-fix PR found. Use `/dev <N>` to start a fresh fix."

---

## Step 3 — [Bug path only] Root Cause Investigation

Evaluate the root cause in light of the new ACs. Produce a fresh investigation:

- **Root Cause** — why the bug occurs under the new ACs (plain language)
- **Scope** — which product area/user-facing surface is affected (plain language)
- **Fix Approach** — what to change; opens with `[frontend]`, `[backend]`, or `[devops]` tag
- **Risk** — Low / Medium (with migration details) / High
- **Complexity** — S (<4h) / M (4-8h) / L (>8h)

**Replace** the existing `## Dev Investigation` comment on the issue. Overwrite entirely — do not carry over old content.

---

## Step 4 — Git Setup

**Story path:** For each in-scope codebase, discover the existing PR state:

- List story branches for issue `<N>`.
- **Open PR found** → hold PR number, checkout story branch.
- **No open PR** → find merged PR, hold PR number. If sprint branch does not exist, halt. Create story branch from sprint branch.
- For multi-skill: run independently per codebase path.

**Bug path:** Check out bugfix branch for issue `<N>` and pull latest from remote.

---

## Step 5 — Diff Analysis

Fetch PR(s) from Step 4. Produce a **delta summary**:

| Section | Content |
|---------|---------|
| Already implemented / correct | ACs/fixes still satisfied — do not change |
| New / changed ACs | ACs in the updated issue not yet satisfied |
| Removed ACs | ACs from original PR no longer in the updated issue |
| TDD delta | [Story path] TDD drift from current PR — if $TDD loaded |
| Design delta | [Story path, frontend] Design drift from current PR — if $DESIGN loaded |
| Affected files | Files already in the PR — do not duplicate work |

Include TDD delta and Design delta only if they are loaded and drift exists.

---

## Step 6 — Dispatch Agents

**Story path:** Spawn `backend`, `frontend`, and `devops` in a single parallel message. Pass context per dispatch-agents protocol with `<constraints>` containing the delta summary and:

```xml
<instruction>Implement the delta only. Do not re-implement ACs already satisfied. Do not modify already-correct files unless an AC explicitly requires a change.</instruction>
```

**Bug path:** Spawn only agents matching the `[tag]` in Fix Approach. Pass `<decisions type="investigation">` with Root Cause, Scope, Fix Approach, Risk verbatim, and `<constraints>` with the delta summary and:

```xml
<instruction>Implement the delta only. Revert code for removed ACs. Add code for new/changed ACs. Do not modify files already correct under the new ACs.</instruction>
```

---

## Step 7 — Commit and Push

Commit and push all changed files in each codebase path.

**Story path:** `feat(#<ISSUE_NUMBER>): update <short description> per story change`
**Bug path:** `fix(#<ISSUE_NUMBER>): revise bug fix per updated ACs`

---

## Step 8 — [Story path only] Open or Update PR

- **Open PR case** — no PR action needed.
- **Merged PR case** — create PR for issue `<N>` targeting the sprint branch — one call per codebase path.

---

## Step 9 — Remove Label

Remove the `story-updated` label from the issue.

---

## Step 10 — [Story path — merged PR case only] Notify

Notify implementation complete.
