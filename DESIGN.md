---
version: alpha
name: Notism

colors:
  background: "#ffffff"
  foreground: "#09090b"
  card: "#ffffff"
  card-foreground: "#09090b"
  popover: "#ffffff"
  popover-foreground: "#09090b"
  primary: "#f07316"
  primary-foreground: "#ffffff"
  secondary: "#f4f4f5"
  secondary-foreground: "#27272a"
  muted: "#f4f4f5"
  muted-foreground: "#71717a"
  accent: "#f4f4f5"
  accent-foreground: "#27272a"
  destructive: "#dc2626"
  border: "#e4e4e7"
  input: "#e4e4e7"
  ring: "#f07316"
  success: "#166534"
  warning: "#92400e"
  info: "#1d4ed8"
  sidebar: "#fafafa"
  sidebar-foreground: "#09090b"
  sidebar-primary: "#f07316"
  sidebar-primary-foreground: "#ffffff"
  sidebar-accent: "#f4f4f5"
  sidebar-accent-foreground: "#27272a"
  sidebar-border: "#e4e4e7"
  sidebar-ring: "#f07316"
  chart-1: "#ea580c"
  chart-2: "#0d9488"
  chart-3: "#1e40af"
  chart-4: "#84cc16"
  chart-5: "#eab308"

typography:
  xs:
    fontFamily: "Noto Sans, ui-sans-serif, system-ui, sans-serif"
    fontSize: 0.75rem
    fontWeight: 400
    lineHeight: 1rem
  sm:
    fontFamily: "Noto Sans, ui-sans-serif, system-ui, sans-serif"
    fontSize: 0.875rem
    fontWeight: 400
    lineHeight: 1.25rem
  base:
    fontFamily: "Noto Sans, ui-sans-serif, system-ui, sans-serif"
    fontSize: 1rem
    fontWeight: 400
    lineHeight: 1.5rem
  lg:
    fontFamily: "Noto Sans, ui-sans-serif, system-ui, sans-serif"
    fontSize: 1.125rem
    fontWeight: 600
    lineHeight: 1.75rem
  xl:
    fontFamily: "Noto Sans, ui-sans-serif, system-ui, sans-serif"
    fontSize: 1.25rem
    fontWeight: 600
    lineHeight: 1.75rem
  2xl:
    fontFamily: "Noto Sans, ui-sans-serif, system-ui, sans-serif"
    fontSize: 1.5rem
    fontWeight: 700
    lineHeight: 2rem
  3xl:
    fontFamily: "Noto Sans, ui-sans-serif, system-ui, sans-serif"
    fontSize: 1.875rem
    fontWeight: 700
    lineHeight: 2.25rem

rounded:
  sm: 0.5rem
  md: 0.625rem
  lg: 0.75rem
  xl: 1rem
  full: 9999px

spacing:
  1: 0.25rem
  2: 0.5rem
  3: 0.75rem
  4: 1rem
  6: 1.5rem
  8: 2rem
  12: 3rem
  16: 4rem

components:
  button:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.primary-foreground}"
    typography: "{typography.sm}"
    rounded: "{rounded.md}"
    height: 2.25rem
    padding: 0.5rem 1rem
  input:
    backgroundColor: "{colors.background}"
    textColor: "{colors.foreground}"
    typography: "{typography.sm}"
    rounded: "{rounded.md}"
    height: 2.25rem
    padding: 0.25rem 0.75rem
  card:
    backgroundColor: "{colors.card}"
    textColor: "{colors.card-foreground}"
    typography: "{typography.base}"
    rounded: "{rounded.xl}"
    padding: 1.5rem
  badge:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.primary-foreground}"
    typography: "{typography.xs}"
    rounded: "{rounded.full}"
    padding: 0.125rem 0.625rem
---

# Notism Design System

## Overview

Notism's visual identity is built around appetite, speed, and warmth. The interface should make users feel hungry and excited — instantly communicating that food is just a few taps away. Every design decision reinforces this: a deep, vivid orange primary energises the UI and signals action; clean white surfaces keep food and content in focus; generous but purposeful corner radii soften the experience without sacrificing efficiency.

**Visual identity:** High-contrast warm orange against clean neutral backgrounds. Flat, food-forward surfaces with minimal ornamentation. Noto Sans across all weights keeps the UI legible and friendly without feeling stiff.

**Color rationale:** Orange is the appetite colour — used broadly in food contexts globally. The primary (`#f07316`) is vivid enough to command attention on CTAs while remaining readable on white. Secondary and muted surfaces use near-neutral zinc tones so the orange always leads.

**Typographic approach:** Noto Sans (loaded at weights 300–700) provides warmth and legibility across all content densities. Body and control text sits at `sm` (14px); card titles at `lg` (18px, semibold); page headings at `2xl`–`3xl`.

**Spatial atmosphere:** Comfortable spacing (base unit 4px) with generous card padding (24px). Radius scale runs from `md` (10px) on controls to `xl` (16px) on cards to `full` on pills, giving the UI a rounded, approachable feel reminiscent of Grab/Foodpanda.

**Mode behaviour:** Light mode is the default (white backgrounds, near-black foreground). Full dark mode is supported — dark surfaces shift to near-black (`#0a0a0a` background, `#18181b` cards) with the same orange primary and updated semantic colours. Token names are identical across both modes; values are overridden via the `.dark` class.

---

## Colors

All hex values below represent light mode. Dark mode overrides are listed in the table.

### Primary palette

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `primary` | `#f07316` | `#f07316` | CTAs, active states, focus rings, key interactive elements |
| `primary-foreground` | `#ffffff` | `#ffffff` | Text/icons on primary backgrounds |

### Surfaces

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `background` | `#ffffff` | `#0a0a0a` | Page/app background |
| `foreground` | `#09090b` | `#fafafa` | Default text |
| `card` | `#ffffff` | `#18181b` | Card and popover surfaces |
| `card-foreground` | `#09090b` | `#fafafa` | Text on cards |
| `popover` | `#ffffff` | `#18181b` | Floating UI surfaces (dropdowns, tooltips) |
| `popover-foreground` | `#09090b` | `#fafafa` | Text in popovers |
| `sidebar` | `#fafafa` | `#18181b` | Sidebar surface |
| `sidebar-foreground` | `#09090b` | `#fafafa` | Sidebar text |

### Neutral / secondary

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `secondary` | `#f4f4f5` | `#27272a` | Secondary button background, alternate fills |
| `secondary-foreground` | `#27272a` | `#fafafa` | Text on secondary |
| `muted` | `#f4f4f5` | `#27272a` | Muted/inactive fills |
| `muted-foreground` | `#71717a` | `#a1a1aa` | Placeholder text, de-emphasised labels |
| `accent` | `#f4f4f5` | `#27272a` | Hover fills for ghost/outline interactions |
| `accent-foreground` | `#27272a` | `#fafafa` | Text on accent |

### Borders and inputs

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `border` | `#e4e4e7` | `rgba(255,255,255,0.1)` | Default borders |
| `input` | `#e4e4e7` | `rgba(255,255,255,0.15)` | Input field borders |
| `ring` | `#f07316` | `#f07316` | Focus ring colour (3px ring at 50% opacity) |

### Semantic

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `destructive` | `#dc2626` | `#f87171` | Errors, delete actions |
| `success` | `#166534` | `#4ade80` | Confirmed orders, payment success |
| `warning` | `#92400e` | `#d97706` | Caution states, slow delivery warning |
| `info` | `#1d4ed8` | `#60a5fa` | Informational callouts |

### Charts

| Token | Value | Usage |
|-------|-------|-------|
| `chart-1` | `#ea580c` | Primary data series (orange) |
| `chart-2` | `#0d9488` | Secondary data series (teal) |
| `chart-3` | `#1e40af` | Tertiary data series (blue) |
| `chart-4` | `#84cc16` | Quaternary data series (lime) |
| `chart-5` | `#eab308` | Quinary data series (yellow) |

---

## Typography

### Font Family

**Noto Sans** — loaded from Google Fonts at weights 300, 400, 500, 600, 700. Fallback stack: `ui-sans-serif, system-ui, sans-serif`.

### Scale

| Token | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| `xs` | 12px / 0.75rem | 400 | 1rem | Badge labels, fine print, timestamps |
| `sm` | 14px / 0.875rem | 400 | 1.25rem | Body text, button labels, input text, card descriptions |
| `base` | 16px / 1rem | 400 | 1.5rem | Primary content areas, menu item descriptions |
| `lg` | 18px / 1.125rem | 600 | 1.75rem | Card titles, section headings |
| `xl` | 20px / 1.25rem | 600 | 1.75rem | Page sub-headings, modal titles |
| `2xl` | 24px / 1.5rem | 700 | 2rem | Page headings |
| `3xl` | 30px / 1.875rem | 700 | 2.25rem | Hero / display headings |

---

## Layout

### Grid Model

Single-column on mobile, two-column on tablet (md: 768px), up to four-column on desktop (lg: 1024px) for menu grids.

### Spacing Strategy

4px base unit. Prefer spacing tokens `4` (1rem), `6` (1.5rem), `8` (2rem) for component internal padding; `12` (3rem) and `16` (4rem) for section separation.

### Responsive Breakpoints

| Breakpoint | Min-width | Typical use |
|------------|-----------|-------------|
| `sm` | 640px | Wider cards, 2-col layouts |
| `md` | 768px | Tablet — 2-col food grid |
| `lg` | 1024px | Desktop — sidebar + main content |
| `xl` | 1280px | Wide desktop |

### Overflow

`html, body` use `overflow: hidden` — scrolling is handled within child containers.

---

## Elevation and Depth

### Shadows

`shadow-sm` (0 1px 2px rgba(0,0,0,0.05)) on cards — subtle lift to distinguish content from background. Popovers and dropdowns use the standard Radix UI shadow utility — heavier shadow to indicate higher elevation. Omit shadow entirely from non-elevated surfaces.

### Borders

Used on cards (`border`), inputs (`border-input`), and dividers. Border is the primary depth signal — use it to define containers, shadow to lift them.

### Overlays

Semi-transparent dark overlay (`rgba(0,0,0,0.5)`) behind dialogs and modals.

---

## Shapes

### Radius Scale

| Token | Value | Used on |
|-------|-------|---------|
| `rounded.sm` | 8px | Small utility elements |
| `rounded.md` | 10px | Buttons (`rounded-md`), inputs, small chips |
| `rounded.lg` | 12px | Default container radius |
| `rounded.xl` | 16px | Cards (`rounded-xl`), large panels |
| `rounded.full` | 9999px | Badges (pill shape), avatar circles |

### Shape Language

The rounded-heavy scale mirrors Grab/Foodpanda's approachable aesthetic. Controls use `md` (10px) to feel tappable and friendly. Cards use `xl` (16px) to create clear visual grouping. Badges use `full` to communicate a tag/label state clearly.

---

## Components

### Button

#### Variants

Six variants. Default variant shown first.

| Property | Default | Destructive | Outline | Secondary | Ghost | Link |
|----------|---------|-------------|---------|-----------|-------|------|
| Background | `primary` | `destructive` | `background` | `secondary` | transparent | transparent |
| Text | `primary-foreground` | white | `foreground` | `secondary-foreground` | `accent-foreground` | `primary` |
| Hover | `primary` at 90% | `destructive` at 90% | `accent` at 10% + `primary/40` border | `secondary` at 80% | `accent` | underline |

#### Sizes

| Size token | Height | Padding | Text |
|------------|--------|---------|------|
| `xs` | 24px (h-6) | 0.5rem horizontal | 12px |
| `sm` | 32px (h-8) | 0.75rem horizontal | 14px |
| `default` | 36px (h-9) | 1rem horizontal | 14px |
| `lg` | 40px (h-10) | 1.5rem horizontal | 14px |
| `icon` | 36px square | — | — |

#### States

`disabled` → `opacity-50`, `pointer-events-none`. Focus visible → `border-ring` + `ring-[3px] ring-ring/50`. Invalid → `border-destructive`, `ring-destructive/20`. Radius: `rounded-md` (10px) across all sizes.

### Input

Single variant. Full-width by default.

- Height: 36px (h-9)
- Radius: `rounded.md` (10px)
- Border: `border-input` with `bg-transparent` in light mode; `bg-input/30` in dark mode
- Placeholder: `muted-foreground`
- Focus: `border-ring` + `ring-[3px] ring-ring/50`
- Error state: `border-destructive` + `ring-destructive/20`
- Disabled: `opacity-50`, `cursor-not-allowed`

### Card

Structural container component with header, content, footer, and action slots.

- Background: `card` / `card-foreground`
- Radius: `rounded.xl` (16px)
- Shadow: `shadow-sm`
- Internal gap: 24px (gap-6) between sections
- Padding: 24px vertical (py-6), 24px horizontal per slot (px-6)
- `CardTitle`: `font-semibold`, `leading-none`
- `CardDescription`: `text-sm`, `muted-foreground`

### Badge

Pill-shaped label. Variants: `default`, `secondary`, `destructive`, `outline`, `success`.

| Variant | Background | Text | Border |
|---------|-----------|------|--------|
| `default` | `primary` | `primary-foreground` | none |
| `secondary` | `secondary` | `secondary-foreground` | none |
| `destructive` | `destructive` | `destructive-foreground` | none |
| `outline` | transparent | `foreground` | current colour |
| `success` | `success/15` | `success` | `success/30` |

- Radius: `rounded.full` (pill)
- Padding: 0.125rem 0.625rem (py-0.5 px-2.5)
- Font: 12px, `font-semibold`

---

## Do's and Don'ts

### Do

- Use `primary` (`#f07316`) exclusively for the single primary CTA per view — one dominant orange action per screen keeps the eye moving toward checkout.
- Use `rounded.xl` for all card-level containers; use `rounded.md` for all control-level elements (buttons, inputs, chips).
- Use `muted-foreground` for secondary text and placeholders; never use raw grey values outside the token system.
- Use the `success` badge variant to confirm order statuses; use `destructive` for cancellation or error states.
- Maintain `shadow-sm` on cards and omit shadow from non-elevated surfaces to preserve visual hierarchy.
- Apply `font-semibold` (weight 600) at `lg` size and above for headings; `font-medium` (500) for interactive labels; `font-normal` (400) for body copy.

### Don't

- Don't use `primary` as a background colour for surfaces — it is reserved for interactive elements only.
- Don't mix radius values arbitrarily — stick to `rounded.md` for controls, `rounded.xl` for containers, `rounded.full` for pills.
- Don't use `success`, `warning`, or `info` colours for decorative purposes; they are semantic and carry status meaning.
- Don't omit the focus ring (`ring-ring/50` at 3px) on any interactive element — accessibility is non-negotiable.
- Don't render heading text below `lg` (18px semibold) — anything smaller is body copy, not a heading.
- Don't place white or `primary-foreground` text on `secondary` or `muted` backgrounds — insufficient contrast.
