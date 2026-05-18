
Extract `sprint_number` (the token after `create-design`).

---

## Step 1 — Load Sprint Context

Load Sprint Snapshot for Sprint $SPRINT_N (github skill). Hold `$MILESTONE_ID`, `$STORIES`, `$REQUIREMENT`, `$TDD`.

**Mode-specific guard**: if the requirement issue already carries a design hub comment (a comment whose body starts with `## Design Navigation`), stop with:

> Design hub already exists on the requirement issue — run `/feature sync-design $SPRINT_N` to refresh affected surfaces or `/feature amend-design <story_issue>` for a single-story change.

From `$STORIES`, filter to stories with user-facing UI changes. If none, report `No UI work found in this milestone — skipping design phase.` and stop. Hold the result as `$UI_STORIES`.

---

## Step 2 — Create Feature Branch on Orchestrator Repo

Check whether the orchestrator's sprint branch for Sprint $SPRINT_N already exists. If absent, create it from the default branch. Check it out locally — subsequent steps write per-surface artifacts to this branch and commit them here.

---

## Step 3 — Identify Affected Surfaces

Read `DESIGN.md` at the orchestrator root in full. Hold `$NEW_DS` (current tokens + components).

From `$UI_STORIES` plus the web codebase's routes / pages tree (path from the Codebases table), enumerate every UI surface in scope. For each surface, capture: human-readable name + kebab-case slug.

Present the list to the user via `AskUserQuestion`:

- **Confirm list** — accept as-is.
- **Edit list** — collect free-text additions, removals, or renames; re-present until confirmed.

Hold `$SURFACES`.

---

## Step 4 — Generate per-surface design artifacts

Generate per-surface design instructions, HTML mockups, and the shared stylesheet for `$SURFACES`, passing each surface's `story_acs`.

Gather returned paths into `$INSTRUCTIONS_LINKS` and `$MOCK_LINKS`.

---

## Step 5 — Approval Gate

Present a per-surface bullet list of every emitted local path to the user (instructions, mockup, plus the shared stylesheet).

Use `AskUserQuestion`:

- **Approve design instructions + mockups** — proceed to Step 6.
- **Iterate** — collect per-surface feedback (which surface needs what changed). Re-run Step 4 with the affected surfaces only. Cap at 5 iterations.

---

## Step 6 — Commit + Push

On the orchestrator's sprint branch for Sprint $SPRINT_N, commit the shared stylesheet and every per-surface instructions and mockup file (commit message: `chore(design): sprint-{$SPRINT_N} design instructions and mockups`). Push. Resolve blob URLs into `$INSTRUCTIONS_LINKS` and `$MOCK_LINKS`.

---

## Step 7 — Open PR

On the orchestrator repo, open a pull request from the sprint branch for Sprint $SPRINT_N targeting the default branch. The PR bundles the per-surface design instructions + mockup files committed in Step 6.

- **Title**: `chore(design): sprint-<$SPRINT_N> design instructions and mockups`.
- **Body**: include a reference to the requirement issue `#$REQUIREMENT`, the per-surface artifact count, and a brief test plan (open each per-surface mockup locally + spot-check that named classes resolve to the expected `DESIGN.md` tokens).

Hold the PR URL in `$DESIGN_PR_LINK`.

---

## Step 8 — Notify

Merge `$MOCK_LINKS` and `$INSTRUCTIONS_LINKS` by surface key into a single `per_surface_artifacts` table (one row per surface: name + mock UI blob URL + design-instructions blob URL).

Render the hub comment by calling `render_template('comment-design-hub', { per_surface_artifacts })`.

Post the rendered body as a **comment** on the requirement issue `#$REQUIREMENT`. The requirement issue is now the design navigation hub for Sprint $SPRINT_N — no separate design issue is created. Implementers consume the per-surface files directly from the orchestrator's sprint branch.

Follow up with a brief completion comment on the same requirement issue linking the PR:

```
🎨 Design phase complete.

- PR: <$DESIGN_PR_LINK>
- Sprint milestone: <sprint milestone URL>
```
