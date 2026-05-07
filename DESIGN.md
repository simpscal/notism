---
version: alpha
name: Notism
description: A clean, fast food ordering platform built for everyday customers who want a frictionless experience from browse to checkout.
colors:
  primary: "#ff5500"
  primary-foreground: "#ffffff"
  secondary: "#f3f3f4"
  secondary-foreground: "#141418"
  muted: "#f3f3f4"
  muted-foreground: "#70707b"
  accent: "#f3f3f4"
  accent-foreground: "#141418"
  background: "#fefefe"
  foreground: "#09090b"
  card: "#fefefe"
  card-foreground: "#09090b"
  popover: "#fefefe"
  popover-foreground: "#09090b"
  border: "#e4e4e7"
  input: "#e4e4e7"
  ring: "#ff5500"
  destructive: "#e7000a"
  success: "#005a00"
  warning: "#873f00"
  info: "#005b9e"
  sidebar: "#f9f9f9"
  sidebar-foreground: "#09090b"
  sidebar-primary: "#ff5500"
  sidebar-border: "#e4e4e7"
  chart-1: "#f44900"
  chart-2: "#009689"
  chart-3: "#104e64"
  chart-4: "#ffb900"
  chart-5: "#fd9900"
  background-dark: "#030303"
  foreground-dark: "#f9f9f9"
  card-dark: "#111114"
  secondary-dark: "#1a1a1d"
  muted-dark: "#1a1a1d"
  muted-foreground-dark: "#9e9ea9"
  destructive-dark: "#ff6366"
  sidebar-dark: "#111114"
  success-dark: "#52a052"
  warning-dark: "#a86520"
  info-dark: "#3d8ace"
typography:
  h1:
    fontFamily: Noto Sans
    fontSize: 36px
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: -0.01em
  h2:
    fontFamily: Noto Sans
    fontSize: 28px
    fontWeight: 600
    lineHeight: 1.25
  h3:
    fontFamily: Noto Sans
    fontSize: 22px
    fontWeight: 600
    lineHeight: 1.3
  body-lg:
    fontFamily: Noto Sans
    fontSize: 16px
    fontWeight: 400
    lineHeight: 1.6
  body-md:
    fontFamily: Noto Sans
    fontSize: 14px
    fontWeight: 400
    lineHeight: 1.5
  body-sm:
    fontFamily: Noto Sans
    fontSize: 13px
    fontWeight: 400
    lineHeight: 1.5
  label-md:
    fontFamily: Noto Sans
    fontSize: 14px
    fontWeight: 500
    lineHeight: 1.4
  label-sm:
    fontFamily: Noto Sans
    fontSize: 12px
    fontWeight: 500
    lineHeight: 1.4
  caption:
    fontFamily: Noto Sans
    fontSize: 12px
    fontWeight: 400
    lineHeight: 1.4
rounded:
  sm: 8px
  md: 10px
  lg: 12px
  xl: 16px
  full: 9999px
spacing:
  base: 16px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  2xl: 64px
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.primary-foreground}"
    rounded: "{rounded.md}"
    height: 36px
    padding: 16px
  button-primary-hover:
    backgroundColor: "#e64c00"
  button-secondary:
    backgroundColor: "{colors.secondary}"
    textColor: "{colors.secondary-foreground}"
    rounded: "{rounded.md}"
    height: 36px
  button-outline:
    backgroundColor: "{colors.background}"
    textColor: "{colors.foreground}"
    rounded: "{rounded.md}"
    height: 36px
  button-destructive:
    backgroundColor: "{colors.destructive}"
    textColor: "#ffffff"
    rounded: "{rounded.md}"
    height: 36px
  button-ghost:
    backgroundColor: "transparent"
    textColor: "{colors.foreground}"
    rounded: "{rounded.md}"
    height: 36px
  button-sm:
    height: 32px
    padding: 12px
  button-lg:
    height: 40px
    padding: 24px
  input:
    backgroundColor: "transparent"
    textColor: "{colors.foreground}"
    rounded: "{rounded.md}"
    height: 36px
    padding: 12px
  badge:
    rounded: "{rounded.md}"
    padding: 8px
  card:
    backgroundColor: "{colors.card}"
    textColor: "{colors.card-foreground}"
    rounded: "{rounded.lg}"
  sidebar-item:
    backgroundColor: "transparent"
    textColor: "{colors.sidebar-foreground}"
    rounded: "{rounded.md}"
  sidebar-item-active:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.primary-foreground}"
---

# Notism Design System

## Overview

Notism is a clean, fast food ordering platform built for everyday customers who want a frictionless experience from browse to checkout. The UI is confident and direct — vibrant orange drives attention to primary actions while neutral surfaces stay out of the way. The experience should feel fast, honest, and accessible: no decorative noise, no ambiguous states, no friction between a customer and their next meal. Light and dark themes are fully supported across all surfaces.

## Colors

The palette is anchored by a bold orange primary and a near-neutral gray surface scale.

- **Primary (#ff5500):** A high-energy orange used exclusively for primary actions (CTA buttons, active states, focus rings, sidebar highlights). Signals urgency and appetite.
- **Secondary (#f3f3f4):** A light warm gray for secondary buttons, muted surfaces, and chip backgrounds.
- **Muted (#f3f3f4) / Muted Foreground (#70707b):** Used for placeholder text, helper copy, disabled labels, and metadata.
- **Background (#fefefe):** Near-white page surface — clean and unobtrusive.
- **Card (#fefefe):** Same as background in light mode; surfaces elevate in dark mode (#111114).
- **Destructive (#e7000a):** Reserved for delete actions, error states, and critical alerts.
- **Success (#005a00) / Warning (#873f00) / Info (#005b9e):** Semantic feedback colors for toast messages, inline validation, and status badges.
- **Sidebar (#f9f9f9):** Slightly off-white sidebar surface with orange active item highlights.
- **Dark mode:** Background drops to near-black (#030303), cards to #111114, secondary surfaces to #1a1a1d. Primary orange remains unchanged across themes.

## Typography

All text is set in **Noto Sans**, a humanist sans-serif with broad language coverage (weights 300–700). Weight variation creates hierarchy without switching typefaces.

- **Headings (h1–h3):** Semi-bold to Bold at 22–36px with tight line-height for impact.
- **Body:** Regular weight at 14–16px with generous line-height for reading comfort.
- **Labels:** Medium (500) at 12–14px for form labels, table headers, and UI copy.
- **Captions:** Regular at 12px for metadata, timestamps, and secondary annotations.

## Layout

Client and admin surfaces use a responsive sidebar + main-content shell. The sidebar is persistent on desktop and collapsible on smaller viewports. Content areas use a 24px gutter with a 16px base spacing unit. The foods catalog uses a responsive grid (2–4 columns depending on viewport). Modals and drawers use full screen height on mobile.

The spacing scale follows an 8px base unit. Micro-spacing (4px) is reserved for icon gaps and inline items only.

## Elevation & Depth

Depth is expressed through **tonal layering**, not heavy shadows. In light mode, cards share the background color and are delineated by a 1px `border` (#e4e4e7). In dark mode, cards rise to #111114 against a near-black (#030303) page, creating contrast without drop shadows. Dialogs and drawers use a subtle backdrop overlay. No decorative shadows on interactive components.

## Shapes

All interactive elements use the **lg radius (12px)** as the default corner. Smaller components (badges, chips, xs buttons) use **sm (8px)**. Pills and avatar badges use `full` (9999px). Never mix sharp and rounded corners within the same component group.

## Components

**Buttons** drive interaction through the primary orange. Variants: `default` (primary fill), `secondary` (muted fill), `outline` (border only), `ghost` (hover fill only), `destructive` (red fill), `link` (underline). Sizes: `xs` (h-6 / 24px), `sm` (h-8 / 32px), `default` (h-9 / 36px), `lg` (h-10 / 40px). Icon-only variants match each size.

**Inputs** are 36px tall with a 1px border, rounded-md corners, and a 3px orange ring on focus. Error state uses destructive color for border and ring.

**Cards** group related content with rounded-lg corners and card-foreground text. Admin list pages use card-wrapped tables; client detail pages use card sections with labeled fields.

**Badges** convey status (order state, food availability). Use semantic colors: destructive for cancelled, success for completed, muted for pending/processing.

**Sidebar** is persistent in admin and client layouts. Active nav item has primary background and primary-foreground text. Inactive items show ghost hover.

**Kanban** and **timeline** components appear in admin order management for visual workflow tracking.

**Tables** are used across all admin list pages (foods, categories, orders, users). Rows support hover highlight and checkbox selection.

**Toast (Sonner)** handles all user feedback — food added to cart, order placed, payment confirmed. Use success/destructive/info variants only; never raw alerts.

**Spinner** and **skeleton** cover async loading states for all data-fetched views.

## Do's and Don'ts

- Do use primary orange only for the single most important CTA per screen
- Don't use primary orange for decorative purposes or body text links
- Do use the `destructive` variant only for genuinely destructive actions (delete, cancel order)
- Don't create color values outside the token set — use opacity modifiers (e.g., `primary/90`) for variations
- Do maintain WCAG AA contrast for all text (4.5:1 for normal text, 3:1 for large)
- Don't mix `rounded-full` and `rounded-md` elements in the same horizontal row
- Do use `muted-foreground` for secondary metadata; never hardcode gray literals
- Don't use more than two font weights on a single card or form section
