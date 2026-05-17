---
name: design-mockup
description: Use when generating or amending a per-surface HTML mockup (`sprint-<N>/mockups/<surface-slug>.html`) — a viewable wireframe for human review.
tools: Read, Write, Edit
---

# Design Mockup Contract

A per-surface HTML mockup is a sketch — a viewable wireframe for human review.

## Body Layout

Wrap each per-state region in a `<main>` container and stack states with `<hr>` + `<h3>` separators. Compose using sketch primitives — every component region is a `.sketch-component` box with a `.sketch-label` naming the component, variant, and size; image / media regions are `.sketch-placeholder` boxes.

```html
<main class="page stack">
  <div class="sketch-placeholder">[Image: hero photo, 16:9]</div>

  <div class="sketch-component">
    <span class="sketch-label">Card</span>
    <h1>Pad Thai</h1>
    <p>Short description placeholder.</p>
    <div class="row">
      <div class="sketch-component">
        <span class="sketch-label">Button · outline · md</span>
        Add to favourites
      </div>
      <div class="sketch-component">
        <span class="sketch-label">Button · primary · md</span>
        Order now
      </div>
    </div>
  </div>
</main>

<hr style="border: none; border-top: 1px dashed #CCC; margin: 2rem 0;" />
<h3 class="page">Loading state</h3>
<main class="page stack">…</main>

<hr style="border: none; border-top: 1px dashed #CCC; margin: 2rem 0;" />
<h3 class="page">Empty state</h3>
<main class="page stack">…</main>
```

## Sketch Primitives

```css
.sketch-component { border: 1px dashed #999; padding: 0.75rem;
                    border-radius: 4px; background: #FFF; }
.sketch-label { display: block; font-size: 0.7rem; color: #777;
                text-transform: uppercase; letter-spacing: 0.05em;
                margin-bottom: 0.25rem; }
.sketch-placeholder { background: #EEE; color: #999;
                      display: flex; align-items: center; justify-content: center;
                      aspect-ratio: 16 / 9; }
```

## Rules

- **Sketch, not production.** Plain greys, dashed component outlines, simple labels.
- **Components are hinted, not implemented.** Wrap each component region in a `.sketch-component` box with a `.sketch-label` naming the component, variant, and size (e.g. `Button · primary · md`, `Input · email`, `Card`, `Badge · success`).
- **No token-to-class mapping.** No `bg-{token}`, `text-{token}`, `component-{name}-{variant}-{size}`. Use the sketch primitives (`.sketch-component`, `.sketch-label`, `.sketch-placeholder`) and minimal layout helpers.
- **No external CSS, fonts, images, or JavaScript.** Inline `<style>`; CSS-only placeholders for images.
- **Stack states in one file.** Default first, then Loading, Empty, Error, Success, Mobile/Tablet/Desktop variants. Use `<hr>` dividers + `<h3>` labels.
- **File naming**: kebab-case `<surface-slug>.html`. Slug matches the paired `<surface-slug>.md`. File location: `sprint-<N>/mockups/<surface-slug>.html` (paired instructions live at `sprint-<N>/instructions/<surface-slug>.md`).
