Implement **one story per invocation** — do not batch.

Check labels on the fetched story issue:

- Has `story-updated` → **Revisit branch** — design changed after implementation began; implement the delta only.
- Otherwise → **Fresh branch** — full implementation from scratch.

---

## Step 1 — Gather Story Context (bounded)

Run in parallel:

1. **Story issue body + comments** — the story already fetched. Extract:
   - Current ACs.
   - Design Instructions URL and Mock UI URL from the story's Notes section (embedded there during decomposition).
   - Design-primitives dependency list from the Notes section.
   - The `requirement_issue` slot in the story body points at the **brief issue** — that is also the navigation hub.

2. **Design instructions file** — check out the orchestrator repo's sprint branch (`sprint-<$SPRINT_N>`, where `$SPRINT_N` comes from the story's milestone title) and `Read` `sprint-<N>/instructions/<surface-slug>.md` from the orchestrator's working tree. The file is the source-of-truth for the coding agent: Layout per state (YAML tree with anchors), Responsive, Accessibility, Components used.

Add label `in-progress` to the story issue.

---

## Step 2 — Git Setup

**Fresh branch:**

Sprint number `$SPRINT_N`: read from the story issue's milestone title (format: `Sprint N`).

Checkout the sprint branch for sprint `$SPRINT_N` in the web codebase path (from the Codebases table; never hardcode).

**Revisit branch:**

Discover the existing PR state in the web codebase:

- List story branches for issue `<ISSUE_NUMBER>`.
- **Open PR found** → hold PR number, checkout the existing story branch.
- **No open PR** → find merged PR, hold PR number. If the sprint branch does not exist, halt. Create the story branch from the sprint branch.

---

## Step 3 — [Revisit branch only] Diff Analysis

Fetch the PR from Step 2. Produce a **delta summary**:

| Section | Content |
|---------|---------|
| Already implemented / correct | ACs still satisfied — do not change |
| New / changed ACs | ACs in the updated issue not yet satisfied |
| Removed ACs | ACs from the original PR no longer in the updated issue |
| Design delta | Design drift from current PR vs the regenerated `instructions/<surface-slug>.md` |
| Affected files | Files already in the PR — do not duplicate work |

---

## Step 4 — Dispatch Frontend Agent

Spawn `frontend` only. Pass context as a `<context>` XML block per the dispatch-agents protocol:

```xml
<context>
  <acceptance_criteria>
    <!-- the story's ACs, one per <ac> -->
    <ac>...</ac>
  </acceptance_criteria>

  <design_instructions>
    <!-- verbatim contents of orchestrator sprint-<N>/instructions/<surface-slug>.md — sole source-of-truth for the agent -->
  </design_instructions>

  <constraints>Use PRODUCTION components from the web codebase. Resolve component imports from the codebase, not from any mock.</constraints>
</context>
```

**Revisit branch:** also include `<constraints>` with the delta summary and:

```xml
<instruction>Implement the delta only. Do not re-implement ACs already satisfied. Do not modify already-correct files unless an AC explicitly requires a change.</instruction>
```

If the frontend agent returns `<no_work>`, halt — the story has nothing left to implement.

---

## Step 5 — [Fresh branch only] Git Branch Setup

Create story branch for issue `<ISSUE_NUMBER>` and `<short-description>` in the web codebase, branching off the sprint branch.

---

## Step 6 — Commit and Push

Once the subagent completes, commit and push all changed files in the web codebase.

**Fresh branch:** `feat(#<ISSUE_NUMBER>): <imperative-tense description>`

**Revisit branch:** `feat(#<ISSUE_NUMBER>): update <short description> per design change`

---

## Step 7 — Open or Update PR

**Fresh branch:** Create PR for issue `<ISSUE_NUMBER>` targeting the sprint branch on the web codebase.

- **Title:** `feat(#<ISSUE_NUMBER>): <short description>`
- **Body:** Render the `pr-story` template with `{summary, manual_verification, acceptance_criteria, parent_issue: <ISSUE_NUMBER>, parent_issue_url: $(gh issue view <ISSUE_NUMBER> --json url -q .url)}`.

**Revisit branch:**

- **Open PR case** — no PR action needed.
- **Merged PR case** — create PR for issue `<ISSUE_NUMBER>` targeting the sprint branch.

---

## Step 8 — [Revisit branch only] Remove Label

Remove the `story-updated` label from the issue.

---

## Step 9 — Notify

**Fresh branch:** Notify implementation complete.

**Revisit branch:** Notify only in the merged-PR case (the open-PR case has no new PR to announce).
