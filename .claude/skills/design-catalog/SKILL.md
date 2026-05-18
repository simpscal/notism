---
name: design-catalog
description: Use when generating or amending a design-system HTML catalog — token groups (colors, typography, spacing, rounded, shadows) plus full component variant × size matrix in one file.
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

## Dark Mode Toggle

The catalog uses a **full-page dark mode toggle**, not a separate Dark Mode section.

- Place a `<button>` with `position: fixed; top: 16px; right: 24px; z-index: 999; border-radius: 9999px` in the viewport.
- Toggle adds/removes the `dark` class on `<html>` via a single JS function. The icon flips between 🌙 and ☀️; the label flips between "Dark mode" and "Light mode".
- Dark token overrides live under `html.dark { ... }` in `<style>`, overriding every `:root` custom property with dark-mode values.
- **No separate Dark Mode section in the body.** The toggle applies the dark theme globally to all existing sections.

## Rules

- **Single file** with one Google Fonts `<link>` allowed for the design system typeface. No other external assets.
- **Resolve tokens to values.** Inline actual hex / rem values into `:root` — do not reference tokens by name in property values.
- **Every component variant × size rendered.** No abbreviated demos.
- **No dedicated Dark Mode section.** Dark mode is demonstrated via the fixed toggle button, not a separate body section.
