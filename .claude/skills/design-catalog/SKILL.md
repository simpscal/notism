---
name: design-catalog
description: >
  Canonical contract for a standalone HTML catalog of a design system —
  renders every token group (colors / typography / spacing / rounded /
  shadows) and the full component variant × size matrix in one file.
  Apply when a flow generates, emits, produces, regenerates, or amends
  a design system catalog HTML.
tools: Read, Write, Edit
---

# Design System Catalog Contract

## Body Layout

```html
<button class="mode-toggle" onclick="document.documentElement.classList.toggle('dark')">Toggle dark mode</button>

<section><h2>Colors</h2>
  <!-- one swatch per color token, light + dark side-by-side. Each swatch is a <div> with
       background = var(--token), label = token name, value = hex -->
</section>

<section><h2>Typography</h2>
  <!-- one line per scale token (xs → 3xl) showing sample text "The quick brown fox..."
       styled with the scale token; label = token name + (size, weight, line-height) -->
</section>

<section><h2>Spacing</h2>
  <!-- horizontal bars sized by each spacing token; label = token + value -->
</section>

<section><h2>Rounded</h2>
  <!-- one square per radius token, with radius applied; label = token + value -->
</section>

<section><h2>Shadows + Elevation</h2>
  <!-- one card per shadow token, each demonstrating the elevation -->
</section>

<section><h2>Components</h2>
  <!-- One row per component (Button, Input, Card, Badge). For each: all variants × all sizes
       rendered side-by-side using component classes. Hover/focus/disabled/invalid demos. -->
</section>
```

## Token Resolution (head `<style>`)

```css
:root {
  --background: #...;
  --foreground: #...;
  --primary: #...;
  /* ...all colors */

  --space-1: ...;
  /* ...through space-16 */

  --radius-sm: ...;
  /* ...through radius-full */

  --shadow-sm: ...;
  /* ...all shadow tokens */
}

.dark { --background: #...; --foreground: #...; /* ... */ }

body { font-family: <typography.base.fontFamily>;
       background: var(--background); color: var(--foreground); margin: 0; }
section { padding: var(--space-8) var(--space-6); border-top: 1px solid var(--border); }
section h2 { font-size: 1.5rem; font-weight: 700; margin: 0 0 var(--space-4); }
```

## Rules

- **Single file.** No external CSS, fonts, scripts, or images. Use CSS-only swatches.
- **Resolve tokens to values.** Inline actual hex / rem values into `:root` — do not reference tokens by name in property values.
- **Every component variant × size rendered.** No abbreviated demos.
