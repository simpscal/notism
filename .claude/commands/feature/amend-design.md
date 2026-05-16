
Extract `story_issue` (the token after `amend-design`).

---

## Step 1 — Load Sprint Context

Fetch issue `#$STORY_ISSUE`. From its milestone title, derive Sprint $SPRINT_N. Load Sprint Snapshot for Sprint $SPRINT_N — hold `$MILESTONE_ID`, `$STORIES`, `$REQUIREMENT`, `$TDD`.

**Mode-specific guard**: if the requirement issue has no design hub comment (no comment body starting with `## Design Navigation`) → `⛔ No design hub found on the requirement issue — run /feature create-design $SPRINT_N first.` and stop.

Read `DESIGN.md` at the orchestrator root in full. Hold `$NEW_DS`.

---

## Step 2 — Load Design Hub and Identify Target Surfaces

Fetch the design hub comment on the requirement issue (the comment whose body starts with `## Design Navigation`). Parse the `### Per-surface Artifacts` table — each row gives a surface name + slug + mock UI blob URL + design instructions blob URL. Hold this as `$HUB_SURFACES` (the authoritative inventory of surfaces in scope for Sprint $SPRINT_N).

From `$HUB_SURFACES`, identify which surface (or surfaces) the story `#$STORY_ISSUE` owns by mapping the story body + ACs against the hub rows. If the mapping is ambiguous (story touches multiple hub rows, or doesn't match any), ask via `AskUserQuestion` to pick from `$HUB_SURFACES`. Hold the result as `$TARGET_SURFACES`.

---

## Step 3 — Open Amendment Dialog

Ask a single `AskUserQuestion`:

> What changed in `#$STORY_ISSUE`'s design, and why? Describe the problem with the current per-surface design and the direction you want to go.

Hold the response as `$CHANGE_INPUT`. Use it to engage in discussion — answer trade-off questions, flag risks from `$NEW_DS` / story context. Continue iterating until the final direction is confirmed.

---

## Step 4 — Regenerate Affected Surface Files

Ensure the orchestrator's sprint branch for Sprint $SPRINT_N is checked out.

For each surface in `$TARGET_SURFACES`, spawn one subagent (parallel, max 5; usually a single surface) to regenerate `<surface-slug>.md` + `<surface-slug>.html` at `<orchestrator-root>/sprint-<$SPRINT_N>/`.

Pass context as a `<context>` XML block per the dispatch-agents protocol with per-surface `<inputs>`:

```xml
<inputs>
  <surface>
    <name>...</name>
    <slug>...</slug>
  </surface>
  <story_acs>...</story_acs>
  <new_ds>$NEW_DS</new_ds>
  <change>$CHANGE_INPUT</change>
</inputs>
```

---

## Step 5 — Commit + Push

On the orchestrator's sprint branch, commit the regenerated files (commit message: `chore(design): amend sprint-{$SPRINT_N} for story #$STORY_ISSUE`). Push. Resolve blob URLs.

---

## Step 6 — Upsert Design Hub Comment on Requirement Issue

Re-render `comment-design-hub` with the full updated per-surface table — load existing rows from the prior hub comment for every unchanged surface; replace rows for `$TARGET_SURFACES`.

Find the existing design hub comment on the requirement issue (matched by body prefix `## Design Navigation`). Edit it in place.

---

## Step 7 — Classify Scope Impact and Label Implemented Stories

From `$STORIES`, filter to stories with label `implemented`. Compare the revised per-surface design against each implemented story and classify the impact:

| Classification | Condition |
|----------------|-----------|
| `additive` | Change adds new behaviour; existing implementation remains valid. |
| `breaking` | Change conflicts with or invalidates the existing implementation. |
| `structural` | Change requires full revisit; affected files treated as blank slate. |
| `unaffected` | Story is not touched by this change. |

Produce a **Scope Classification Table**:

| Story | Title | Classification | Reason |
|-------|-------|----------------|--------|
| `#N` | title | additive / breaking / structural / unaffected | one sentence |

If any classification is ambiguous, ask before proceeding.

**Label updates**: for each story classified `additive`, `breaking`, or `structural` that carries the `implemented` label, add label `story-updated`. Run label additions in parallel.
