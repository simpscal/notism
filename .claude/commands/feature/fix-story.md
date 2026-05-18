## Step 1 — Parse Arguments

Parse `$ARGUMENTS` as `<story_issue> <bug_spec>`.

- `story_issue` — issue number of the story being patched.
- `bug_spec` — free-text describing the regression (what's broken, repro steps, expected vs actual).

If `story_issue` is missing, halt and ask for it.

If `bug_spec` is empty, ask once via `AskUserQuestion` for a free-text description of the regression. Hold the verbatim text as `$BUG_SPEC`.

---

## Step 2 — Fetch Story and Gather Context in Parallel

Run in parallel:

1. **Story issue body** — fetch issue `#<story_issue>` in full. Verify the issue has the `user-story` label. Otherwise halt:
   ```
   ⛔ Issue #<N> is not a story (labels: <labels>). Use /hotfix fix-bug for bug issues.
   ```
   Extract current ACs.
2. **TDD** *(optional)* — list issues labeled `technical-design` in the story's milestone. If found, read in full and extract: components design, API specification, data models, failure modes.
3. **Design Instructions** (frontend only) — derive the requirement issue from the story's milestone. Find the design hub comment on the requirement issue (matched by body prefix `## Design Navigation`) and locate the row(s) for the story's surface(s). For each affected surface, read `<orchestrator-root>/sprint-<N>/instructions/<surface-slug>.md` from the orchestrator's sprint branch.

---

## Step 3 — Git Setup

Checkout the existing story branch for issue `<story_issue>`.

For multi-skill: run independently per codebase path.

---

## Step 4 — Dispatch Agents

Spawn `backend`, `frontend`, and `devops` in a single parallel message. Pass context per dispatch-agents protocol with `<constraints>` containing:

```xml
<constraints>
  <bug_spec>[verbatim $BUG_SPEC]</bug_spec>
  <instruction>Fix only what is required by the bug spec. Do not re-implement already-correct work. Do not modify files unrelated to the bug.</instruction>
</constraints>
```

---

## Step 5 — Commit and Push

Commit and push all changed files to the existing branch.
Commit message: `fix(#<STORY_ISSUE>): <imperative-tense description derived from bug_spec>`

---

## Step 6 — Update Implementation Comment

Find the existing `## Implementation Complete` comment on issue `#<story_issue>`.

Update only the human gate line to:

```
> ⏸ Fix pushed to staging — please re-verify.
```
