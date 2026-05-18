---
name: design-surfaces
description: Auto-triggers on per-surface design artifact work — generate, refresh, or delete the instructions markdown, HTML mockups, and shared stylesheet under `sprint-<N>/`.
tools: Read, Write, Edit, Glob, Grep, Task, Bash
---

# Design Surfaces Contract

## Resolved Paths

- Instructions: `<orchestrator_root>/sprint-<sprint_number>/instructions/<slug>.md`
- Mockups:      `<orchestrator_root>/sprint-<sprint_number>/mockups/<slug>.html`
- Shared CSS:   `<orchestrator_root>/sprint-<sprint_number>/mockups/style.css`

## Inputs

```xml
<inputs>
  <orchestrator_root>...</orchestrator_root>
  <sprint_number>...</sprint_number>
  <surfaces>                                   <!-- to generate/regenerate; may be empty -->
    <surface>
      <name>...</name>
      <slug>...</slug>
      <story_acs>...</story_acs>               <!-- optional -->
      <change>...</change>                     <!-- optional -->
    </surface>
  </surfaces>
  <removed_surfaces>                           <!-- optional -->
    <surface><slug>...</slug></surface>
  </removed_surfaces>
  <constraints>...</constraints>               <!-- optional -->
</inputs>
```

## Orchestration

1. Read `<orchestrator_root>/DESIGN.md`. Parse the two-layer object (`yaml` frontmatter + `markdown` body, including `components_detail`). Hold as `$DS`. Halt with `⛔ DESIGN.md has no components_detail — cannot derive component classes.` if missing.
2. Write the shared CSS (path above). Contents, in order:
   - `@import url('https://fonts.googleapis.com/css2?family=<font>:wght@<weights>')` — from `$DS.typography.fontFamily`.
   - `:root { --color-*, --space-*, --radius-*, --shadow-*, --font-* }` — every token resolved.
   - Page-shell utilities: `.page`, `.state-label`, `hr` reset.
   - Component classes from `$DS.components_detail` — one rule per variant × size, plus interactive-state rules per `states` entry.
3. For each surface in `<surfaces>`, spawn one subagent via Task — **maximum 5 in parallel**, batched. Each subagent receives the `<surface>` block, `$DS`, the resolved paths, and `<constraints>`. Each emits both the instructions `.md` and the mockup `.html` for its slug.
4. For each surface in `<removed_surfaces>`, delete both the instructions `.md` and the mockup `.html` for its slug.
5. Return lists of emitted + deleted paths.

Empty `<surfaces>` + no `<removed_surfaces>` = style-only refresh; stop after step 2.

---

## Instructions File Contract

### File Structure

```markdown
# <Surface name> — design instructions

## Layout — Default state

```yaml
- anchor: Header
  layout: row
  children:
    - anchor: Header-Title
      content: "Inbox"
    - anchor: ProfileMenu
      component: ProfileMenu
- anchor: Body
  layout: row
  children:
    - anchor: Nav
      component: SideNav
    - anchor: Main
      children:
        - anchor: Card-A
          component: Card
          diff: new
        - anchor: Card-B
          component: Card
```

## Layout — Loading / Empty / Error / Success states

(one YAML tree per meaningful state)

## Responsive

- Mobile (< md): …
- Tablet (md–lg): …
- Desktop (lg+): …

## Accessibility

- ARIA roles, keyboard nav, focus management, contrast pairs.

## Components used

| Anchor | Component | Variant | Size | Notes |
|--------|-----------|---------|------|-------|

## Spacing between elements

| From | To | Token | Value | Notes |
|------|----|-------|-------|-------|

## Tokens used

| Token | Group | Value | Where |
|-------|-------|-------|-------|

## Iconography

| Anchor | Icon | Set | Size | Stroke | Color token |
|--------|------|-----|------|--------|-------------|

## Imagery and Media

| Anchor | Asset type | Aspect ratio | Treatment | Placeholder |
|--------|------------|--------------|-----------|-------------|

## Elevation and Borders

| Anchor | Elevation | Border | Divider | Notes |
|--------|-----------|--------|---------|-------|

## Interactive States

| Anchor | Hover | Focus visible | Active / Pressed | Disabled |
|--------|-------|---------------|------------------|----------|

## Dark Mode Notes

- `[<Anchor>]` — surface-specific adjustments beyond token swap.
```

### Rules

- Each `## Layout — <state>` heading is followed by a fenced YAML block: list of root nodes; nesting via `children:`. Per-node keys: `anchor:` (required), `component:`, `layout:` (`column` default, `row`, `grid`), `content:`, `state:`, `diff:` (`new`/`moved`/`restyled`/`removed`), `note:`, `children:`.
- Anchor naming — singletons (`Header`, `Nav`); repeats get a `-A`/`-B` suffix. Tables reference anchors as `[Anchor]`.
- One `## Layout — <state>` per meaningful state (Default / Loading / Empty / Error / Success). Emit a full tree per state.
- Components used / Spacing / Tokens used / Iconography / Elevation / Interactive States tables reference the same anchor keys. Omit anchors with no entry for a given dimension.
- **Interactive States** inherits design-system defaults; fill rows only when this surface overrides them.
- **Dark Mode Notes** captures per-anchor adjustments token swapping can't handle. Omit when every anchor inherits cleanly.
- **Imagery and Media** dropped when the surface has no media.
- File naming: kebab-case of surface name (`comment-panel.md`, `menu-detail.md`).

---

## Mockup File Contract

### File Template

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>{Surface} — Mockup</title>
  <link rel="stylesheet" href="style.css" />
</head>
<body>
  <h2 class="state-label">Default state</h2>
  <main class="page">…surface at full fidelity…</main>

  <hr />
  <h2 class="state-label">Loading state</h2>
  <main class="page">…</main>

  <!-- Empty, Error, Success, responsive breakpoint, dark-mode variants as applicable -->
</body>
</html>
```

### Rules

- **High visual fidelity.** Reads as the final product.
- **Link `style.css`.** Every mockup `<link rel="stylesheet" href="style.css" />` from the same directory. Tokens, fonts, page-shell utilities, component classes never inlined.
- **Static.** No `<script>`, no JavaScript, no form submission. CSS-only `:hover` / `:focus` allowed.
- **Iconography.** Inline SVG from the icon set named in the paired instructions. Match size and stroke from the Iconography table.
- **Imagery.** `<img src>` to a public CDN (Unsplash, picsum.photos) or inline `data:` URIs at the aspect ratio in the instructions. `alt=""` decorative; descriptive `alt` meaningful.
- **Components rendered, not labelled.** Compose with the design-system component classes shipped in `style.css`. No `.sketch-component` boxes, no `[Component · variant · size]` text labels.
- **All states stacked, one file.** Default → Loading → Empty → Error → Success → responsive variants → dark-mode (if supported). Separate with `<hr>` + `<h2 class="state-label">`.
- **Inline `<style>` only for surface-specific overrides.** Reusable styles go to `style.css`.
- **No implementer notes inside.** Anchors, spacing tables, a11y notes, dark-mode adjustments live in the paired instructions `.md`.
