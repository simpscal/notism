
Extract `sprint_number` (the token after `sync-design`).

---

## Step 1 — Load Sprint Context

Load Sprint Snapshot for Sprint $SPRINT_N (github skill). Hold `$MILESTONE_ID`, `$STORIES`, `$REQUIREMENT`, `$TDD`.

**Precondition checks** (stop immediately if any fail):

- `$REQUIREMENT` absent → `⛔ No requirement issue found in Sprint $SPRINT_N. Cannot sync design without a requirement.`
- `$STORIES` empty → `⛔ No user stories found in Sprint $SPRINT_N. Run /feature create-stories <requirement_issue> first.`
- No design hub comment on the requirement issue (no comment body starting with `## Design Navigation`) → `⛔ No design hub found on the requirement issue — run /feature create-design $SPRINT_N first.`

Identify **changed stories** in `$STORIES`: those with label `story-updated` or `story-removed`, plus any newly-added UI stories with no per-surface artifacts yet on the sprint branch.

If no changed stories exist, report `No story changes found — design is already in sync.` and stop.

---

## Step 2 — Identify Affected Surfaces

Read `DESIGN.md` at the orchestrator root in full. Hold `$NEW_DS`.

For each changed story, determine which UI surfaces are affected. Build a Change Plan Table:

| Affected Surface | Story | Classification | Planned Action |
|------------------|-------|----------------|----------------|
| `<slug>` | `#N` | New / Modified / Removed | Generate / Regenerate / Delete |

- **New surface** — story introduces a UI not yet on the sprint branch.
- **Modified surface** — `story-updated` changes an existing surface.
- **Removed surface** — `story-removed` dropped a surface that has files on the sprint branch.

If any classification is ambiguous, ask for clarification before proceeding.

Hold the deduped affected surfaces as `$AFFECTED_SURFACES`.

Ensure the orchestrator's sprint branch for Sprint $SPRINT_N is checked out.

---

## Step 3 — Re-spawn Per-Surface Subagents for Affected Surfaces Only (parallel, max 5)

For each surface in `$AFFECTED_SURFACES`, spawn one subagent — max 5 in parallel, batched if needed. Each subagent emits the surface's two files to `<orchestrator-root>/sprint-<$SPRINT_N>/`:

- **New** / **Modified** — regenerate `<surface-slug>.md` + `<surface-slug>.html`.
- **Removed** — delete `<surface-slug>.md` and `<surface-slug>.html` from the sprint branch.

Pass context per the dispatch-agents protocol with the same per-surface `<inputs>` shape used by `create-design.md` (surface, story_acs, new_ds).

Unaffected surfaces from prior `create-design` runs are not touched.

---

## Step 4 — Approval Gate

Present a per-surface bullet list of every regenerated / deleted path to the user.

Use `AskUserQuestion`:

- **Approve** — proceed to Step 5.
- **Iterate** — collect per-surface feedback. Re-spawn Step 3 subagents for the affected surfaces only. Cap at 5 iterations.

---

## Step 5 — Commit + Push

On the orchestrator's sprint branch, commit the regenerated / deleted files (commit message: `chore(design): sync sprint-{$SPRINT_N} after story changes`). Push. Resolve blob URLs.

---

## Step 6 — Upsert Design Hub Comment on Requirement Issue

Re-render `comment-design-hub` with the **full** updated per-surface table — load existing rows from the prior hub comment for every surface that is unaffected; replace rows for `$AFFECTED_SURFACES`; drop rows for `Removed` surfaces.

Find the existing design hub comment on the requirement issue (matched by body prefix `## Design Navigation`). Edit it in place. If for any reason it is absent, create a new one with the same body.
