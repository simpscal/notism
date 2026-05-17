---
name: design-instructions
description: Use when generating or amending per-surface design-instructions markdown (`sprint-<N>/instructions/<surface-slug>.md`) — layout YAML tree per state, responsive, a11y, components, spacing, tokens, icons, media, elevation, interactive states, dark mode.
tools: Read, Write, Edit
---

# Design Instructions Contract

Single source of truth for a per-surface design-instructions markdown file. Every section the implementer relies on is enumerated below; the Rules section pins the contract that ties the YAML layout tree to the component / spacing / token tables.

## File Structure

```markdown
# <Surface name> — design instructions

> new design only

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
      children:
        - anchor: Nav-Item-1
          content: "Item 1"
        - anchor: Nav-Item-2
          content: "Item 2"
        - anchor: Nav-Item-3
          content: "Item 3"
    - anchor: Main
      children:
        - anchor: Card-A
          component: Card
          diff: new
          children:
            - anchor: Card-A-Title
              content: "Title"
            - anchor: Card-A-Body
              content: "Body"
        - anchor: Card-B
          component: Card
```

Notes:

- `Card-A` is new — replaces inline list.

## Layout — Loading state
…

## Layout — Empty state
…

## Layout — Error state
…

## Responsive

- Mobile (< md): single column, nav collapses to bottom bar
- Tablet (md–lg): 2-col grid
- Desktop (lg+): sidebar + main pattern

## Accessibility

- ARIA roles: `<list any roles required>`
- Keyboard nav: `<tab order, Enter/Escape behaviour>`
- Focus management: `<where focus lands on state changes>`
- Contrast: `<WCAG AA pairs to verify>`

## Components used

| Anchor | Component | Variant | Size | Notes |
|--------|-----------|---------|------|-------|
| `[<Anchor>]` | <component> | <variant> | <size> | <notes> |

`Anchor` matches the exact `anchor:` key used in the YAML layout tree — the implementer follows the anchor from layout position to component spec. One row per distinct anchor. This file is the implementer's source of truth — the HTML mockup is a human-review sketch and is not consumed by implementers.

## Spacing between elements

| From | To | Token | Value | Notes |
|------|----|-------|-------|-------|
| `[<Anchor>]` | `[<Anchor>]` | `space-<step>` | <rem/px> | gap / margin / padding |

`From` and `To` reference the same anchors as the YAML layout tree. List every meaningful spacing relationship — container padding, gap between siblings, margin between sections. One row per relationship.

## Tokens used

| Token | Group | Value | Where |
|-------|-------|-------|-------|
| `<token>` | colors / typography / spacing / rounded / shadow | <value> | `[<Anchor>]`, `[<Anchor>]` |

`Where` is a comma-separated list of anchors using this token. One row per distinct token referenced in this surface (colors, typography, spacing, radius, shadow).

## Iconography

| Anchor | Icon | Set | Size | Stroke | Color token |
|--------|------|-----|------|--------|-------------|
| `[<Anchor>]` | <icon name> | <icon-set, e.g. lucide / phosphor> | <px or size token> | <weight if stroke-based> | `{colors.<token>}` |

One row per icon present in any layout state. Name the icon set so the implementer imports the right symbol. Decorative icons get `aria-hidden`; meaningful ones go in the Accessibility section.

## Imagery and Media

| Anchor | Asset type | Aspect ratio | Treatment | Placeholder |
|--------|------------|--------------|-----------|-------------|
| `[<Anchor>]` | <photo / illustration / avatar / video / chart> | <e.g. 16:9, 1:1> | <radius token, border, mask, overlay> | <skeleton / blurhash / solid color> |

One row per image, avatar, illustration, or media slot. Skip if the surface contains no media.

## Elevation and Borders

| Anchor | Elevation | Border | Divider | Notes |
|--------|-----------|--------|---------|-------|
| `[<Anchor>]` | `{shadow.<token>}` or `none` | `<width> <style> {colors.<token>}` or `none` | `<top / bottom / both / none>` with `{colors.<token>}` | <z-index intent, sticky behaviour> |

One row per anchor that uses shadow, border, or divider to communicate depth or separation. Anchors with no depth treatment are omitted.

## Interactive States

| Anchor | Hover | Focus visible | Active / Pressed | Disabled |
|--------|-------|---------------|------------------|----------|
| `[<Anchor>]` | <bg/fg/border/transform change> | `ring-<width> {colors.ring}` + offset | <bg/fg/scale change> | `opacity-<N>`, `cursor-not-allowed` |

One row per interactive anchor (button, link, card-as-button, input, menu item). Static anchors are omitted. Reference the design system's component state specs by default — only override here when this surface needs a non-default treatment.

## Dark Mode Notes

- `[<Anchor>]` — <surface-specific adjustment beyond token swap, e.g. reduce shadow opacity, swap illustration to dark-mode variant, raise card background one step>.

One bullet per anchor whose dark-mode treatment is not fully captured by swapping light tokens for dark tokens. Drop the section entirely if every anchor inherits cleanly.
```

## Rules

- **Each `## Layout — <state>` heading is followed by a fenced YAML block.** The block is a list of root nodes; nesting via `children:` expresses hierarchy. Agents parse the tree deterministically; humans read it by indentation.
- **Per-node shape.** Each node may carry:
  - `anchor:` — required. The same string appears as `[<Anchor>]` in the Components used / Spacing / Tokens used tables, so an implementer can follow a node to its component / spacing / token spec without guessing.
  - `component:` — optional. The typed component this anchor renders (matches the Components used table).
  - `layout:` — optional. `column` (default), `row`, or `grid`. Describes how immediate children flow.
  - `content:` — optional. Sample copy / label rendered at this node.
  - `state:` — optional. Runtime state override (`disabled`, `loading`, `invalid`, `selected`, etc.). Cascades implicitly to descendants when set on a container.
  - `diff:` — optional. `new`, `moved`, `restyled`, `removed`. Use for changes against the previous design.
  - `note:` — optional. Short inline note.
  - `children:` — optional. Nested list of nodes.
- **Anchor naming.** Singletons read `Header`, `Nav`. Repeats use a `-A` / `-B` suffix (`Card-A`, `Card-B`). Tables reference anchors as `[Anchor]` — the brackets are the table notation, not part of the YAML key.
- One `## Layout — <state>` H2 per meaningful state of the new design (Default / Loading / Empty / Error / Success). Emit a full tree per state — each state stands alone, no merging required.
- A short **Notes** bullet list per state, describing the design intent of any `diff: new` / `diff: moved` / `diff: restyled` annotation or notable `state:` override.
- **Responsive** section lists breakpoint behaviour for this surface.
- **Accessibility** section lists ARIA, keyboard nav, focus management, contrast guarantees.
- **Components used** table is the single source-of-truth for components/variants/sizes used in this surface. The implementer reads this table to know what to build.
- **Spacing between elements** table names every meaningful gap/margin/padding using the design system's spacing tokens. The implementer should never need to guess a spacing value.
- **Tokens used** table lists every distinct design token referenced by this surface (colors, typography, spacing, radius, shadow) with its concrete value and where it applies.
- **Iconography** table names every icon by its canonical id in the chosen icon set so the implementer imports the right symbol. Size, stroke, and color token are mandatory.
- **Imagery and Media** table specifies aspect ratio and placeholder for every image / avatar / illustration / video slot. Drop the section when the surface has no media.
- **Elevation and Borders** table is per-anchor and depth-only — shadow tokens, border specs, dividers. Anchors with no depth treatment do not appear. List sticky / z-stack intent in Notes when relevant.
- **Interactive States** table specifies hover / focus-visible / active / disabled visuals per interactive anchor. Inherit the design system's component state defaults; only fill rows when this surface overrides them.
- **Dark Mode Notes** captures per-anchor adjustments that token swapping alone does not handle (shadow opacity reduction, illustration variant, surface elevation step). Omit the section when every anchor inherits cleanly.
- Short inline diagrams allowed for trivial changes (badge added to existing region) — full box-drawing only when structure changes.
- File naming: kebab-case of surface name (e.g. `comment-panel.md`, `menu-detail.md`). File location: `sprint-<N>/instructions/<surface-slug>.md`.
