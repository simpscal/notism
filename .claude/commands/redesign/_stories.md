# Decompose Stories + Priority Implementation Table

## Inputs

```xml
<inputs>
  <surfaces>                                       <!-- $SURFACES -->
    <surface><name>...</name><slug>...</slug></surface>
  </surfaces>
  <new_ds>...</new_ds>                             <!-- $NEW_DS -->
  <instructions_links>                             <!-- $INSTRUCTIONS_LINKS -->
    <link surface="..."><url>...</url></link>
  </instructions_links>
  <mock_links>                                     <!-- $MOCK_LINKS -->
    <link surface="..."><url>...</url></link>
  </mock_links>
</inputs>
```

## Step 1 — Discovery Synthesis

Synthesise from the inputs above. State the design goal in one sentence. Surface any remaining ambiguity before decomposition.

## Step 2 — Decompose into Stories

Produce stories. Apply INVEST. Two natural categories emerge — keep them as distinct rows in the priority table, not as labels:

1. **Design-primitives stories** — work that other stories depend on:
   - Refactor / update shared components to match `$NEW_DS.components.<name>` (Button, Input, Card, Badge, etc.).
   - Wire up token changes from the revised `DESIGN.md` into theme config / CSS variables.
   - Migrate shared layout primitives (page wrapper, nav shell, sidebar) where multiple per-page stories will reuse them.

2. **Per-page stories** — one or more per surface in `$SURFACES`. Sliced by surface + meaningful state when a surface has too much work for a single story.

### AC format

- `As a <user>, I want <action> so that <benefit>`
- Keep ACs **simple**. Default AC: `The surface matches the linked design instructions and mockup.` Add extra ACs only when something non-visual must hold (e.g. preserves an existing behaviour, satisfies a specific WCAG pair). Do NOT enumerate every visible area — the design links carry that detail.

### Notes per story

- Link to the relevant design-instructions file via `$INSTRUCTIONS_LINKS` and the relevant mock HTML via `$MOCK_LINKS`. These links are the source-of-truth for what to build; the ACs lean on them rather than restating them.
- For per-page stories: list which design-primitives stories they depend on.
- For design-primitives stories: list which per-page stories they unblock.

## Step 3 — Validate

- Every surface in `$SURFACES` has at least one per-page story.
- Every shared component, token group, or layout primitive in `$NEW_DS` that the per-page stories rely on has at least one design-primitives story.
- No story duplicates another's scope.
- No story implies backend or devops work; halt and reshape if found.
- Every per-page story can be implemented after its listed design-primitives dependencies merge.

## Step 4 — Emit Story Specs

Return `$STORIES` as a list of story specs. Each spec has the shape:

```yaml
- title: "[Story] <title>"
  type: Design Primitives | Page
  user_story: "As a <user>, I want <action> so that <benefit>"
  acceptance_criteria:
    - "The surface matches the linked design instructions and mockup."
    # Add extra ACs only when something non-visual must hold (preserves existing behaviour, specific WCAG pair, etc.)
  surfaces: ["<surface-slug>", ...]   # one or more, by surface from $SURFACES
  notes:
    design_instructions: "<INSTRUCTIONS_LINKS[surface]>"
    mock_ui: "<MOCK_LINKS[surface]>"
    depends_on_titles: ["<title of design-primitives story>", ...]  # by title; caller resolves to issue refs
```

Order specs so all `Design Primitives` precede all `Page`, primitives-by-dependency-depth, then by user value. Caller is responsible for persisting these specs and resolving `depends_on_titles` to concrete references.

## Step 5 — Emit Priority Implementation Table

Produce `$PRIORITY_TABLE` in this exact markdown shape:

```
| Priority | Story | Type | Depends on | Reason |
|---------:|-------|------|------------|--------|
| 1 | <story title> | Design Primitives | — | <reason> |
| 2 | <story title> | Design Primitives | <title> | <reason> |
| 3 | <story title> | Page | <title>, <title> | <reason> |
| … |
```

- Sort: all `Design Primitives` rows above all `Page` rows. Within each group, order by dependency depth (no-dep first) then by user value.
- `Type` is either `Design Primitives` or `Page`.
- `Depends on` lists the dependency story titles from rows above; use `—` for none. Caller may rewrite titles to concrete references when persisting.
- `Reason` is one sentence — why this priority?

## Output

Return `$STORIES` (story specs) and `$PRIORITY_TABLE` (rendered markdown).
