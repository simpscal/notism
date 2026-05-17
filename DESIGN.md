---
version: beta
name: Notism

colors:
  primary: "#1a7a50"
  primary-foreground: "#ffffff"
  background: "#ffffff"
  foreground: "#0f172a"
  card: "#ffffff"
  card-foreground: "#0f172a"
  popover: "#ffffff"
  popover-foreground: "#0f172a"
  sidebar: "#f8fafc"
  sidebar-foreground: "#0f172a"
  sidebar-primary: "#1a7a50"
  sidebar-primary-foreground: "#ffffff"
  sidebar-accent: "#f0fdf4"
  sidebar-accent-foreground: "#134e37"
  sidebar-border: "#e2e8f0"
  sidebar-ring: "#1a7a50"
  secondary: "#f1f5f9"
  secondary-foreground: "#1e293b"
  muted: "#f8fafc"
  muted-foreground: "#64748b"
  accent: "#f0fdf4"
  accent-foreground: "#134e37"
  border: "#e2e8f0"
  input: "#e2e8f0"
  ring: "#1a7a50"
  destructive: "#dc2626"
  success: "#16a34a"
  warning: "#d97706"
  info: "#2563eb"
  chart-1: "#1a7a50"
  chart-2: "#16a34a"
  chart-3: "#2563eb"
  chart-4: "#d97706"
  chart-5: "#dc2626"

typography:
  xs:
    fontFamily: "DM Sans, system-ui, sans-serif"
    fontSize: 12px
    fontWeight: 400
    lineHeight: 1.4
    letterSpacing: 0.01em
  sm:
    fontFamily: "DM Sans, system-ui, sans-serif"
    fontSize: 14px
    fontWeight: 400
    lineHeight: 1.5
  base:
    fontFamily: "DM Sans, system-ui, sans-serif"
    fontSize: 16px
    fontWeight: 400
    lineHeight: 1.6
  lg:
    fontFamily: "DM Sans, system-ui, sans-serif"
    fontSize: 18px
    fontWeight: 500
    lineHeight: 1.5
  xl:
    fontFamily: "DM Sans, system-ui, sans-serif"
    fontSize: 20px
    fontWeight: 500
    lineHeight: 1.4
  2xl:
    fontFamily: "DM Sans, system-ui, sans-serif"
    fontSize: 24px
    fontWeight: 600
    lineHeight: 1.3
    letterSpacing: -0.02em
  3xl:
    fontFamily: "DM Sans, system-ui, sans-serif"
    fontSize: 30px
    fontWeight: 600
    lineHeight: 1.2
    letterSpacing: -0.03em

rounded:
  sm: 4px
  md: 6px
  lg: 8px
  xl: 12px
  full: 9999px

spacing:
  1: 4px
  2: 8px
  3: 12px
  4: 16px
  6: 24px
  8: 32px
  12: 48px
  16: 64px

components:
  button:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.primary-foreground}"
    typography: "{typography.sm}"
    rounded: "{rounded.md}"
    height: 2.5rem
    padding: 0 1.25rem
  input:
    backgroundColor: "{colors.background}"
    textColor: "{colors.foreground}"
    typography: "{typography.sm}"
    rounded: "{rounded.md}"
    height: 2.25rem
    padding: 0 0.75rem
  card:
    backgroundColor: "{colors.card}"
    textColor: "{colors.card-foreground}"
    rounded: "{rounded.xl}"
    padding: 1.5rem
  badge:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.primary-foreground}"
    typography: "{typography.xs}"
    rounded: "{rounded.full}"
    padding: 0.125rem 0.625rem
---

## Overview

Notism is a food ordering platform built for speed and simplicity — serving hungry locals who want to browse, order, and pay without friction. The design is warm, approachable, and food-forward: it gets out of the way so the menu takes centre stage, then nudges customers confidently toward checkout.

**Visual identity:** Crisp white backgrounds anchor the layout, while deep emerald green (`#1a7a50`) serves as the single dominant accent — used for primary CTAs, active states, and key data highlights. Components are slightly rounded with hairline borders, creating a structured yet friendly aesthetic that scales from the customer-facing ordering flow to the admin order dashboard without visual disconnect.

**Color rationale:** Primary `#1a7a50` is a deep, natural emerald that signals freshness and quality at 5.3:1 contrast on white — choosing green over the warm orange common to food apps to differentiate the brand and evoke a sense of care and wholeness. Surfaces stay pure white so food photography and card content breathe freely. The pale green accent tint (`#f0fdf4`) marks active sidebar items and hover regions without competing with primary CTAs.

**Typographic approach:** DM Sans at regular weight (400/500/600) carries the friendly-and-fast brand voice. Its geometric-humanist construction reads cleanly at the smallest label sizes (12px badge text, timestamps) and stays approachable at display sizes (30px hero headings, food card names). Weight steps provide hierarchy; decorative or display typefaces are not used.

**Spatial atmosphere:** A 4px base unit scaled to generous section gutters (24–32px) and card padding (24px) gives each food card and action element room to breathe on both mobile and desktop. The max-width container (1120px) keeps content centred and line lengths readable on wide screens. The overall rhythm is relaxed — never cramped.

**Mode behaviour:** Full light and dark support. Light mode is the primary experience, built on pure white. Dark mode flips surfaces to `#0f172a`/`#1e293b`, preserves the primary emerald green for all CTAs and interactive states, and reverses foreground/background tokens. The spatial rhythm and component sizing are identical across both modes.

---

## Colors

### Primary Palette

| Token | Light | Dark | Usage |
|---|---|---|---|
| primary | #1a7a50 | #1a7a50 | Primary CTA buttons, active focus rings, key price highlights |
| primary-foreground | #ffffff | #ffffff | Text and icons on primary-coloured surfaces |

### Surfaces

| Token | Light | Dark | Usage |
|---|---|---|---|
| background | #ffffff | #0f172a | Page and app background |
| foreground | #0f172a | #f8fafc | Default body text and icons |
| card | #ffffff | #1e293b | Card container background |
| card-foreground | #0f172a | #f8fafc | Text inside card containers |
| popover | #ffffff | #1e293b | Dropdowns, tooltips, floating panels |
| popover-foreground | #0f172a | #f8fafc | Text inside popovers |
| sidebar | #f8fafc | #0f172a | Sidebar navigation background |
| sidebar-foreground | #0f172a | #f8fafc | Default sidebar text |
| sidebar-primary | #1a7a50 | #1a7a50 | Active sidebar item text and icon |
| sidebar-primary-foreground | #ffffff | #ffffff | Text on sidebar primary backgrounds |
| sidebar-accent | #f0fdf4 | #1e293b | Active sidebar item background |
| sidebar-accent-foreground | #134e37 | #a7f3d0 | Text on sidebar accent background |
| sidebar-border | #e2e8f0 | #334155 | Sidebar divider and section borders |
| sidebar-ring | #1a7a50 | #1a7a50 | Focus ring inside sidebar |

### Neutral / Secondary

| Token | Light | Dark | Usage |
|---|---|---|---|
| secondary | #f1f5f9 | #1e293b | Secondary button backgrounds, chip backgrounds |
| secondary-foreground | #1e293b | #f1f5f9 | Text on secondary backgrounds |
| muted | #f8fafc | #1e293b | Subtle section backgrounds, table alternating rows |
| muted-foreground | #64748b | #94a3b8 | Supporting text: descriptions, timestamps, metadata |
| accent | #f0fdf4 | #1e293b | Hover and active tint on non-CTA interactive elements |
| accent-foreground | #134e37 | #a7f3d0 | Text on accent backgrounds |

### Borders and Inputs

| Token | Light | Dark | Usage |
|---|---|---|---|
| border | #e2e8f0 | #334155 | Hairline borders on cards, inputs, dividers |
| input | #e2e8f0 | #334155 | Input field border colour |
| ring | #1a7a50 | #1a7a50 | Focus ring on all interactive elements |

### Semantic

| Token | Light | Dark | Usage |
|---|---|---|---|
| destructive | #dc2626 | #ef4444 | Error states, delete actions, cancelled order status |
| success | #16a34a | #22c55e | Confirmed, delivered, and completed states |
| warning | #d97706 | #f59e0b | Preparing, pending, and caution states |
| info | #2563eb | #3b82f6 | Informational callouts, tracking updates |

### Charts

| Token | Value | Usage |
|---|---|---|
| chart-1 | #1a7a50 | Primary data series (revenue, orders) |
| chart-2 | #16a34a | Secondary data series (completed, growth) |
| chart-3 | #2563eb | Tertiary data series (users, sessions) |
| chart-4 | #d97706 | Quaternary data series (pending, warnings) |
| chart-5 | #dc2626 | Quinary data series (cancellations, errors) |

---

## Typography

### Font Family

DM Sans — a geometric humanist sans-serif with friendly curves that communicate approachability without sacrificing readability. Loaded weights: 300, 400, 500, 600. Fallback stack: `DM Sans, system-ui, -apple-system, sans-serif`.

### Scale

| Token | Size | Weight | Line Height | Usage |
|---|---|---|---|---|
| xs | 12px | 400 | 1.4 | Badge labels, category chips, fine print, timestamps |
| sm | 14px | 400 | 1.5 | Button labels, input text, table cells, card metadata |
| base | 16px | 400 | 1.6 | Body copy, food descriptions, form field content |
| lg | 18px | 500 | 1.5 | Card titles, section headings, food item names |
| xl | 20px | 500 | 1.4 | Page sub-headings, modal titles |
| 2xl | 24px | 600 | 1.3 | Page headings, dashboard section titles |
| 3xl | 30px | 600 | 1.2 | Hero headings, landing page headline |

---

## Layout

### Grid Model

Single-column on mobile (< 640px). Two-column on tablet (640–1023px) for food card grids and settings forms. Three- to four-column on desktop (≥ 1024px) for the foods listing grid and admin data tables. Admin views use a fixed 220px sidebar plus a fluid main content area.

### Spacing Strategy

Base unit is 4px (0.25rem). All spacing values are multiples of this unit. Spacing token `4` (16px) is the default inner padding for tight components (badge horizontal padding, button horizontal padding); token `6` (24px) is the standard card and section padding; token `8` (32px) separates major page sections. Generous whitespace is the default — prefer `spacing.6` or `spacing.8` between distinct regions.

### Responsive Breakpoints

| Breakpoint | Min-width | Typical use |
|---|---|---|
| sm | 640px | 2-column food card grid, wider form layouts |
| md | 768px | Tablet layout, horizontal nav visibility |
| lg | 1024px | 3-column food grid, full sidebar-plus-content layout |
| xl | 1280px | 4-column admin tables, max container width |

### Overflow

`html` and `body` have `overflow: hidden` on the x-axis and `overflow: auto` on y. Individual scroll containers (food listing, orders table, cart) scroll on `overflow-y: auto` with visible scrollbars on desktop and momentum scrolling (`-webkit-overflow-scrolling: touch`) on mobile.

---

## Elevation and Depth

### Shadows

| Level | Value | Used on |
|---|---|---|
| sm | 0 1px 2px rgba(0,0,0,0.05) | Food cards, form panels, sidebar sections |
| md | 0 4px 12px rgba(0,0,0,0.08) | Popovers, dropdowns, floating menus |

### Borders

Hairline borders (`1px solid border`) define structural separation between list items, form regions, table rows, and card edges. Shadow is the elevation signal — cards sit above the page via `shadow-sm`; popovers float via `shadow-md`. Do not combine shadow and border on the same element unless both are structurally necessary.

### Overlays

Modal and dialog backdrops: `rgba(0, 0, 0, 0.5)`. Applied as a full-viewport overlay behind the modal container. Dark mode uses the same value.

---

## Shapes

### Radius Scale

| Token | Value | Used on |
|---|---|---|
| sm | 4px | Small chips, tags, inner radius of compound controls |
| md | 6px | Buttons, inputs, select fields, small action menus |
| lg | 8px | Popovers, dropdowns, notification toasts |
| xl | 12px | Food cards, panel containers, page-level containers |
| full | 9999px | Pill badges, avatar circles, loading indicators |

### Shape Language

The slightly-rounded aesthetic (4–12px) anchors the design between the sharp grids of enterprise dashboards and the pill-heavy softness of consumer apps. Controls (buttons, inputs) use `rounded-md` (6px) — visible but understated. Cards use `rounded-xl` (12px) for a softer, modern food-app feel. Badges and status indicators use `rounded-full` for instant visual distinction from rectangular content blocks.

---

## Components

### Button

#### Variants

| Variant | Background | Text | Hover | Border |
|---|---|---|---|---|
| default | #1a7a50 (primary) | #ffffff | opacity 90% | none |
| destructive | #dc2626 | #ffffff | opacity 90% | none |
| outline | transparent | #0f172a (foreground) | #f8fafc (muted) | 1px #e2e8f0 (border) |
| secondary | #f1f5f9 (secondary) | #1e293b | secondary/80 | none |
| ghost | transparent | #0f172a (foreground) | #f8fafc (muted) | none |
| link | transparent | #1a7a50 (primary) | underline decoration | none |

#### Sizes

| Size | Height | Padding | Text size |
|---|---|---|---|
| xs | 28px | 0 10px | xs (12px) |
| sm | 32px | 0 14px | sm (14px) |
| default | 40px | 0 20px | sm (14px) |
| lg | 48px | 0 28px | base (16px) |
| icon | 40px × 40px | 0 | — |

#### States

- **Disabled:** `opacity-50`, `pointer-events-none`. Applied to all variants.
- **Focus visible:** `outline-none`, `border-ring`, `ring-[3px] ring-ring/50`. Ring uses primary green at 50% opacity.
- **Invalid:** Not applicable to Button — the destructive variant serves as the visual signal for dangerous actions.

---

### Input

#### Sizing

Height 36px, horizontal padding 12px (0.75rem), border-radius `rounded-md` (6px).

#### Border

1px solid `input` token (`#e2e8f0` light / `#334155` dark). Background is transparent in light mode; `bg-input/30` in dark mode.

#### Placeholder

`muted-foreground` (#64748b light / #94a3b8 dark).

#### States

- **Focus:** `border-ring` (#1a7a50), `ring-[3px] ring-ring/15` — primary green ring at 15% opacity.
- **Error:** `border-destructive` (#dc2626), `ring-[3px] ring-destructive/20`.
- **Disabled:** `opacity-50`, `cursor-not-allowed`, `pointer-events-none`.

---

### Card

#### Sizing

Padding 24px (1.5rem) on all sides. Border-radius `rounded-xl` (12px). Shadow `shadow-sm`. Internal gap between slots: 16px (spacing.4).

#### Slots

- **CardHeader:** Contains `CardTitle` (typography `lg`, weight 600) and `CardDescription` (typography `sm`, `muted-foreground`). Bottom padding 16px.
- **CardContent:** Body area. Typography `base`. No additional padding beyond card default.
- **CardFooter:** Action area. Flex row, gap 8px. Optional top hairline border.
- **CardAction:** Optional element in header for secondary controls (icon buttons, status badges). Positioned with `ml-auto`.

---

### Badge

#### Variants

| Variant | Background | Text | Border |
|---|---|---|---|
| default | #1a7a50 (primary) | #ffffff | none |
| secondary | #f1f5f9 (secondary) | #1e293b | 1px #e2e8f0 (border) |
| destructive | #fee2e2 | #991b1b | none |
| outline | transparent | #0f172a (foreground) | 1px #e2e8f0 (border) |
| success | #dcfce7 | #166534 | none |

#### Sizing

Padding 2px 10px. Border-radius `rounded-full` (9999px) — always pill-shaped. Font: `typography.xs` (12px, weight 500). Text is never truncated; badges shrink to content width.

---

## Do's and Don'ts

### Do

- Use `primary` (#1a7a50) exclusively for the dominant CTA on each screen — one primary button per view at most.
- Apply generous padding (≥ 24px via `spacing.6`) between distinct page sections and inside card containers.
- Use `border-border` (1px hairline) to separate list items, table rows, and form regions — provides structure without visual weight.
- Use `muted-foreground` for supporting text: descriptions, timestamps, prices, and category labels against white or light surfaces.
- Rely on `shadow-sm` to elevate food cards above the page — shadow is the primary depth signal for cards.
- Apply semantic badge variants (`success`, `warning`, `destructive`) consistently for order status throughout the admin and customer order views.
- Use `rounded-xl` (12px) on all card-like containers: food cards, order panels, settings sections.

### Don't

- Don't use the primary green as a background for decorative or non-interactive elements — it signals action and must remain meaningful.
- Don't apply `shadow-md` or `shadow-sm` to buttons, inputs, or nav elements — shadow is reserved for cards and floating surfaces.
- Don't introduce raw hex values in component styles — always reference a design token.
- Don't use font weights above 600 — no extra-bold (700+) or black weights in the DM Sans scale.
- Don't constrain input width below 100% of its parent column — inputs are always full-width within their layout column.
- Don't place two `default` (primary) buttons adjacent to each other — pair primary with `outline` or `ghost` when two actions appear side-by-side.
- Don't use the `accent` tint (#f0fdf4) as a page background — reserved for hover and active highlights on interactive elements only.
