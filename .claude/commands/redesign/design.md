## Step 1 — Create Sprint Milestone + Feature Branches

List milestones in the orchestrator repo. Take the next sprint number → `$SPRINT_N`. Create milestone `Sprint N` with no goal description (the brief filed in Step 4 carries the redesign outcome summary).

Create the sprint branch for sprint `$SPRINT_N` in both:

- **Orchestrator repo** (holds DESIGN.md revision + `sprint-<N>/` previews).
- **Web codebase** (holds per-story implementations; path from `config.md` Codebases table).

---

## Step 2 — Discover Surfaces

Read `config.md` to find the web codebase path. Scan that codebase's routes / pages tree to enumerate every user-facing surface. Compile a list — for each surface: human-readable name, kebab-case slug, current route path.

Present the list to the user via `AskUserQuestion`:

- **Confirm list** — accept as-is.
- **Edit list** — collect free-text additions, removals, or renames; re-present until confirmed.

Hold `$SURFACES`.

---

## Step 3 — Build Design System and Design Catalog

### 3a — Derive + Apply DESIGN.md

Spawn a subagent to derive and apply the new design system. Pass context as a `<context>` XML block per the dispatch-agents protocol with the following `<inputs>`:

```xml
<inputs>
  <design_md_path><orchestrator-root>/DESIGN.md</design_md_path>
  <sprint_branch>$SPRINT_BRANCH</sprint_branch>
  <feedback>$FEEDBACK</feedback>           <!-- empty on first pass; populated on iteration loops with the user's free-text feedback -->
</inputs>
```

The subagent runs the design-direction interview (atmosphere, layout pattern, references) with the user, derives a concrete token set, and rewrites `DESIGN.md` at `<design_md_path>` as a full redesign on the orchestrator's sprint branch. On iteration passes, the subagent honours `<feedback>` when reshaping the direction.

Subagent returns:

- `$NEW_DS` — the two-layer object (YAML frontmatter + markdown body) reconstructed from the freshly written `DESIGN.md`.
- `$DESIGN_DIRECTION` — the locked atmosphere / layout pattern / references, for Step 4 to summarise into the brief.

### 3b — Generate Design Catalog

Spawn a subagent to generate the design system catalog HTML for this sprint. Pass context as a `<context>` XML block per the dispatch-agents protocol with the following `<inputs>`:

```xml
<inputs>
  <new_ds>$NEW_DS</new_ds>
</inputs>
```

Subagent returns `index.html`; place it at `<orchestrator-root>/sprint-<$SPRINT_N>/index.html` on the orchestrator's sprint branch (local-only).

### 3c — Surface for review

Present both local paths to the user:

- `<orchestrator-root>/DESIGN.md` — the revised tokens + components.
- `<orchestrator-root>/sprint-<$SPRINT_N>/index.html` — open locally in a browser.

### 3d — Approval gate

Use `AskUserQuestion`:

- **Approve design system + design catalog** — proceed to 3e.
- **Iterate** — collect free-text feedback into `$FEEDBACK`. Revert local changes to `DESIGN.md` and delete the local design catalog file. Loop back to 3a; the re-spawned subagent picks up `$FEEDBACK` and reshapes the direction, then 3b regenerates the design catalog. Cap at 5 iterations; if not converged, halt and ask the user whether to proceed anyway.

### 3e — Commit + Push (on approve)

On the orchestrator's sprint branch, commit `DESIGN.md` and `sprint-<N>/index.html` together (e.g. `chore(redesign): sprint-{N} design system and design catalog`). Push. Resolve the blob URLs into `$DESIGN_MD_LINK` and `$CATALOG_LINK`.

---

## Step 4 — Create Redesign Brief Issue

Render the body from the `issue-redesign-brief` template with `{atmosphere}`, `{layout_pattern}`, `{references}` — from `$DESIGN_DIRECTION`.

Create the issue with title `[Redesign Brief] <concise outcome title>` (derived from the atmosphere + layout pattern), labels `redesign`, milestone `Sprint $SPRINT_N`. Hold the resulting issue number as `$BRIEF_ISSUE_NUMBER`.

The brief is the scope-of-record for this sprint and the parent of every redesign story created in Step 6.

---

## Step 5 — Generate Design Instructions + Mockups

Place every emitted file in `<orchestrator-root>/sprint-<$SPRINT_N>/` on the orchestrator's sprint branch (flat, no subdirs).

### 5a — Spawn per-surface subagents (parallel, max 5 concurrent)

For each surface in `$SURFACES`, spawn one subagent — **maximum 5 in parallel**. If `$SURFACES` has more than 5 entries, run in batches of up to 5 (send one message with up to 5 Agent tool calls; wait for the batch to complete; send the next batch). Each subagent owns one surface and emits two files to `<orchestrator-root>/sprint-<$SPRINT_N>/`:

- `<surface-slug>.md` — per-surface design instructions for the surface.
- `<surface-slug>.html` — per-surface HTML mockup for the surface.

Pass context as a `<context>` XML block per the dispatch-agents protocol with the following per-surface `<inputs>`:

```xml
<inputs>
  <surface>
    <name>...</name>
    <slug>...</slug>
  </surface>
  <new_ds>$NEW_DS</new_ds>
</inputs>
```

After all subagents finish, gather their returned paths into `$INSTRUCTIONS_LINKS` (`.md` paths) and `$MOCK_LINKS` (`.html` paths).

### 5b — Surface for review

Present a per-surface bullet list of every `sprint-<N>/<surface>.md` and `sprint-<N>/<surface>.html` local path to the user.

### 5c — Approval gate

Use `AskUserQuestion`:

- **Approve design instructions + mockups** — proceed to 5d.
- **Iterate** — collect per-surface feedback (which surface needs what changed). Re-spawn 5a subagents in parallel for the affected surfaces only. Cap at 5 iterations.

### 5d — Commit + Push (on approve)

On the orchestrator's sprint branch, commit every `sprint-<N>/<surface>.md` and `sprint-<N>/<surface>.html` (e.g. `chore(redesign): sprint-{N} design instructions and mockups`). Push. Resolve blob URLs into `$INSTRUCTIONS_LINKS` and `$MOCK_LINKS`.

---

## Step 6 — Decompose Stories + Priority Table

### 6a — Decompose

Spawn a subagent to perform `_stories.md`. Pass context as a `<context>` XML block per the dispatch-agents protocol, including the `_stories.md` instructions and the following `<inputs>`:

```xml
<inputs>
  <surfaces>
    <surface><name>...</name><slug>...</slug></surface>
  </surfaces>
  <new_ds>$NEW_DS</new_ds>
  <instructions_links>
    <link surface="..."><url>...</url></link>
  </instructions_links>
  <mock_links>
    <link surface="..."><url>...</url></link>
  </mock_links>
</inputs>
```

Subagent returns `$STORIES` (specs) and `$PRIORITY_TABLE` ranking Design Primitives rows above Page rows. The subagent does NOT touch GitHub.

### 6b — Persist Stories

For each spec in `$STORIES`, create a GitHub issue:

- Title: spec.title (`[Story] <title>`).
- Labels: `user-story`.
- Body: `issue-user-story` template with `{user_story: spec.user_story, acceptance_criteria: spec.acceptance_criteria, notes: spec.notes (Design Instructions + Mock UI + Depends on), requirement_issue: $BRIEF_ISSUE_NUMBER}` — the brief is the scope-of-record and parent of redesign stories.
- Milestone: `Sprint $SPRINT_N` (created in Step 1).

After all issues exist, back-fill `Depends on` titles in each story's Notes section to issue-number references.

### 6c — Rewrite `$PRIORITY_TABLE`

Replace each `Story` cell's title-form with the matching `#<n> — <title>` ref using the issues just created. Replace each `Depends on` cell's titles with `#<n>` refs.

---

## Step 7 — Post Design Navigation Comment on Brief Issue

Merge `$MOCK_LINKS` and `$INSTRUCTIONS_LINKS` by surface key into a single `per_surface_artifacts` table (one row per surface: name + mock URL + design-instructions URL).

Render the hub comment by calling `render_template('comment-redesign-hub', { preview_ui: $CATALOG_LINK, per_surface_artifacts, priority_table: $PRIORITY_TABLE })`.

Post the rendered body as a **comment** on the brief issue `#$BRIEF_ISSUE_NUMBER`. The brief issue is now the navigation hub for the sprint — no separate design issue is created.

---

## Step 8 — Open PR + Notify

### 8a — Open PR

On the orchestrator repo, open a pull request from the sprint branch targeting the default branch. The PR bundles every commit landed in this phase: the revised `DESIGN.md` + design catalog (Step 3e) and every per-surface design-instructions + mockup file (Step 5d).

- **Title**: `chore(redesign): sprint-<$SPRINT_N> design system, design catalog, per-surface artifacts`.
- **Body**: include the brief issue ref, the revised `DESIGN.md` blob link, the design catalog blob link, and the per-surface artifact count. End with a brief test plan (open design catalog + spot-check a couple of mock files).

Hold the PR URL in `$DESIGN_PR_LINK`.

### 8b — Post notification comment

Post a comment on the brief issue `#$BRIEF_ISSUE_NUMBER` summarising completion and linking the PR:

```
🎨 Design phase complete.

- PR: <$DESIGN_PR_LINK>
- Sprint milestone: <sprint milestone URL>
- Preview UI: <$CATALOG_LINK>
- DESIGN.md (revised): <$DESIGN_MD_LINK>
```
