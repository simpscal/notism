
Extract `story_issue` (the token after `amend-design`).

---

## Step 1 — Load Sprint Context

Fetch issue `#$STORY_ISSUE`. From its milestone title, derive Sprint $SPRINT_N. Load Sprint Snapshot for Sprint $SPRINT_N — hold `$MILESTONE_ID`, `$STORIES`, `$BRIEF` (the `[Redesign Brief]` issue this sprint's stories parent to via their `requirement_issue` slot).

**Hub-comment guard**: if the brief issue has no design navigation comment (no comment body starting with `## Redesign Navigation`) → `⛔ No design hub found on the brief issue — design phase must run first.` and stop.

Check out the orchestrator's sprint branch for Sprint $SPRINT_N. Every commit landed by this command targets that branch.

Read `DESIGN.md` at the orchestrator root in full. Parse it into the two-layer object shape defined by the design-authoring skill (`yaml` frontmatter + `markdown` body) and hold as `$BASELINE_DS`.

---

## Step 2 — Load Design Hub, Surfaces, and Priority Table

Fetch the design navigation comment on the brief issue (the comment whose body starts with `## Redesign Navigation`). Parse two pieces:

- `$HUB_SURFACES` — rows from the `### Per-surface Artifacts` table; each row gives a surface name + slug + mock UI blob URL + design instructions blob URL. This is the authoritative surface inventory for Sprint $SPRINT_N.
- `$PRIORITY_TABLE_ROWS` — rows from the `### Priority Implementation Table`. Each row: priority, story (`#<n>`), type (`Design Primitives` or `Page`), depends-on, reason. Used as the candidate pool in Step 7.

The hub comment is never re-rendered by this command — its blob URLs are branch-ref (`sprint-<N>/...`) and stay valid once Steps 4 / 5 commit the new content to the same branch.

From `$HUB_SURFACES`, identify which surface (or surfaces) the story `#$STORY_ISSUE` owns by mapping the story body + ACs against the hub rows. If the mapping is ambiguous (story touches multiple hub rows, or doesn't match any), ask via `AskUserQuestion` to pick from `$HUB_SURFACES`. Hold the result as `$TARGET_SURFACES`.

---

## Step 3 — Open Amendment Dialog and Classify Scope

Ask a single `AskUserQuestion`:

> What changed in `#$STORY_ISSUE`'s design, and why? Describe the problem with the current design and the direction you want to go.

Hold the response as `$CHANGE_INPUT`. Use it to engage in discussion — answer trade-off questions, flag risks from `$BASELINE_DS` / story context. Continue iterating until the final direction is confirmed.

Once the direction is locked, ask a second `AskUserQuestion` to classify scope:

- **`system`** — change touches the design system (theme, atmosphere, tokens, primitives, shared components). Requires revising `DESIGN.md` and regenerating the design catalog. No per-surface regeneration.
- **`page`** — change touches the story's page surface(s) only. Design system stays as-is.
- **`both`** — change touches both the design system and specific page surfaces.

Hold the choice as `$CHANGE_TYPE`. Step 4 runs when `$CHANGE_TYPE ∈ {system, both}`; Step 5 runs when `$CHANGE_TYPE ∈ {page, both}`.

---

## Step 4 — System Pipeline

**Skip this step if `$CHANGE_TYPE == page`.**

The spawned design-authoring subagent runs in Amend mode with `$CHANGE_INPUT` as the amendment driver. Catalog regenerates from the resulting `$NEW_DS` and gates on user approval before any commit.

### 4a — Re-derive and apply DESIGN.md

Spawn a subagent to amend the design system. Pass context as a `<context>` XML block per the dispatch-agents protocol with the following `<inputs>`:

```xml
<inputs>
  <design_md_path><orchestrator-root>/DESIGN.md</design_md_path>
  <sprint_branch>$SPRINT_BRANCH</sprint_branch>
  <mode>amend</mode>
  <baseline_ds>$BASELINE_DS</baseline_ds>
  <feedback>$CHANGE_INPUT</feedback>     <!-- on iterate, the rejection feedback is appended to $CHANGE_INPUT, not replacing it -->
</inputs>
```

The `<mode>amend</mode>` signal plus the amendment-verb phrasing in `<feedback>` routes the design-authoring skill to its **Amend** workflow. The subagent applies the targeted change to `DESIGN.md` on the orchestrator's sprint branch and returns:

- `$NEW_DS` — the two-layer object reconstructed from the freshly written `DESIGN.md`.
- `$DESIGN_DIRECTION` — the (re)locked atmosphere / layout pattern / references.

### 4b — Regenerate Design Catalog

Spawn a subagent to regenerate the design catalog. Pass context as a `<context>` XML block per the dispatch-agents protocol with:

```xml
<inputs>
  <new_ds>$NEW_DS</new_ds>
</inputs>
```

Subagent overwrites `<orchestrator-root>/sprint-<$SPRINT_N>/index.html`.

### 4c — Refresh shared stylesheet

Tokens just changed; the shared mockup stylesheet must follow. Refresh the shared stylesheet for Sprint $SPRINT_N (no surfaces — style-only). Existing per-surface mockup files inherit the new tokens automatically.

### 4d — Surface for review

Present the local paths:

- `<orchestrator-root>/DESIGN.md` — the revised tokens + components.
- `<orchestrator-root>/sprint-<$SPRINT_N>/index.html` — open locally in a browser.
- The refreshed shared mockup stylesheet — drives every per-surface mockup's rendering.

### 4e — Approval gate

Use `AskUserQuestion`:

- **Approve design system + design catalog + shared style** — proceed to 4f.
- **Iterate** — collect free-text feedback into `$FEEDBACK`. **Append `$FEEDBACK` to `$CHANGE_INPUT`** so the original amendment intent survives the loop. Revert local changes to `DESIGN.md` (back to the pre-amend baseline) and delete the local design catalog file and the local shared stylesheet. Loop back to 4a; the re-spawned subagent picks up the extended `$CHANGE_INPUT` and reshapes the direction, then 4b + 4c regenerate the catalog and shared style. Cap at 5 iterations; if not converged, halt and ask the user whether to proceed anyway.

### 4f — Commit + push (on approve)

On the orchestrator's sprint branch, commit `DESIGN.md`, the regenerated design catalog, and the refreshed shared stylesheet together with message:

```
chore(redesign): amend sprint-{$SPRINT_N} design system and design catalog
```

Push.

If the user bailed at 4e without approving (5x iterate + abandon), `$NEW_DS` is undefined; downstream steps treat this as a no-op system pipeline and use `$BASELINE_DS` instead.

---

## Step 5 — Page Pipeline

**Skip this step if `$CHANGE_TYPE == system`.**

Regenerate per-surface design artifacts for `$TARGET_SURFACES`, passing each surface's `story_acs` and `$CHANGE_INPUT`. Apply the redesign-specific constraint:

> Drive layout, atmosphere, and emotional feel from the new tokens + change description only. Do NOT read, scan, or reverse-engineer from the existing surface implementation in the web codebase.

On the orchestrator's sprint branch, commit every regenerated per-surface file (plus the shared stylesheet if Step 4 did not already commit it) with message:

```
chore(redesign): amend sprint-{$SPRINT_N} for story #$STORY_ISSUE
```

Push.

---

## Step 6 — Primitives-Impact Verdict

**Skip this step if `$CHANGE_TYPE == page`** — `$PRIMITIVES_AFFECTED` defaults to `false`.

Otherwise (`system` or `both`), diff `$BASELINE_DS` against `$NEW_DS`. If Step 4 aborted at the approval gate and `$NEW_DS` is undefined, set `$PRIMITIVES_AFFECTED = false` and skip the diff.

Set `$PRIMITIVES_AFFECTED = true` iff any of the following hold; value-only changes do not count:

- `yaml.colors` / `yaml.typography` / `yaml.rounded` / `yaml.spacing` — **token names** added, removed, or renamed.
- `yaml.components.<*>` — any scalar default changed.
- `markdown.components_detail.<*>` — `variants`, `sizes`, or `states` matrices changed.
- `markdown.elevation` — shadow tokens added or removed (shadow value-only changes do not count).

Pure theme value swaps (palette retune, dark-mode value shifts, prose-only Overview edits) leave `$PRIMITIVES_AFFECTED = false`.

Produce `$PRIMITIVES_DIFF_SUMMARY` — a short bulleted list of what changed in primitives terms (one line per affected token group / component), to surface alongside the Scope Classification Table in Step 7 so the user can override the verdict.

---

## Step 7 — Identify Affected Stories

Build the candidate set per `$CHANGE_TYPE`:

```
if CHANGE_TYPE == system:
    candidates = primitives_stories  if PRIMITIVES_AFFECTED  else  []
elif CHANGE_TYPE == page:
    candidates = page_stories whose surface ∩ TARGET_SURFACES
elif CHANGE_TYPE == both:
    candidates = (primitives_stories if PRIMITIVES_AFFECTED else [])
                 ∪ (page_stories whose surface ∩ TARGET_SURFACES)
```

Where:

- `primitives_stories` = rows in `$PRIORITY_TABLE_ROWS` with `type == Design Primitives`.
- `page_stories whose surface ∩ TARGET_SURFACES` = rows with `type == Page` whose surface (looked up via the story's Notes section against `$HUB_SURFACES`) intersects `$TARGET_SURFACES`.

Filter candidates down to those carrying the `implemented` label — uncommitted stories pick up the change naturally on first implementation and do not need flagging.

Classify each surviving candidate's impact:

| Classification | Condition |
|----------------|-----------|
| `additive` | Change adds new behaviour; existing implementation remains valid. |
| `breaking` | Change conflicts with or invalidates the existing implementation. |
| `structural` | Change requires full revisit; affected files treated as blank slate. |
| `unaffected` | Despite category match, this specific story is not touched by the change. |

Produce a **Scope Classification Table** and present it together with `$PRIMITIVES_DIFF_SUMMARY` (when applicable):

| Story | Title | Type | Classification | Reason |
|-------|-------|------|----------------|--------|
| `#N` | title | Design Primitives / Page | additive / breaking / structural / unaffected | one sentence |

The user can override here — add a story the diff missed, or remove a false-flagged one. If any classification is ambiguous, ask before proceeding.

---

## Step 8 — Apply `story-updated` Labels

For each story classified `additive`, `breaking`, or `structural`, add label `story-updated`. Stories classified `unaffected` are left alone. Run label additions in parallel. Never remove labels here — `redesign/implement.md` strips `story-updated` on its revisit branch.
