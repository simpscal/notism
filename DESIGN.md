---
version: alpha
name: Notism
description: Notism positions itself as a warm, appetite-forward food-ordering platform — a stark white canvas anchored by a saturated tangerine-orange primary that turns every CTA, every active state, and every brand moment into a visual cue to "order now." The system uses Noto Sans across all surfaces, leans on a 12px base radius for an approachable rounded feel, and pairs photographic food cards with quiet utility chrome (admin tables, settings panels). Coverage spans the marketing landing page, food catalog and detail surfaces, cart and checkout, order tracking, customer settings, and the admin operations console.

colors:
  primary: "#ed6e30"
  on-primary: "#ffffff"
  primary-soft: "#fff1e8"
  primary-ring: "#ed6e30"
  canvas: "#ffffff"
  surface: "#f5f5f6"
  surface-soft: "#fafafa"
  hairline: "#e7e7eb"
  hairline-soft: "#eeeef1"
  ink: "#18181b"
  ink-strong: "#000000"
  charcoal: "#27272a"
  slate: "#52525b"
  steel: "#71717a"
  stone: "#a1a1aa"
  muted: "#d4d4d8"
  success-bg: "#e8f7ec"
  success-text: "#1f7a3a"
  warning-bg: "#fff4e0"
  warning-text: "#a35d00"
  info-bg: "#e6f0ff"
  info-text: "#1d4ed8"
  destructive: "#dc2626"
  destructive-bg: "#fee2e2"
  on-dark: "#ffffff"
  dark-canvas: "#0d0d10"
  dark-surface: "#1a1a1f"
  chart-1: "#e76538"
  chart-2: "#1ba48a"
  chart-3: "#1d4ed8"
  chart-4: "#e8b341"
  chart-5: "#d56a2a"
  footer-bg: "#0d0d10"

typography:
  hero-display:
    fontFamily: Noto Sans
    fontSize: 64px
    fontWeight: 700
    lineHeight: 1.10
    letterSpacing: -1.5px
  display-lg:
    fontFamily: Noto Sans
    fontSize: 48px
    fontWeight: 700
    lineHeight: 1.15
    letterSpacing: -1px
  heading-lg:
    fontFamily: Noto Sans
    fontSize: 36px
    fontWeight: 700
    lineHeight: 1.20
    letterSpacing: -0.5px
  heading-md:
    fontFamily: Noto Sans
    fontSize: 28px
    fontWeight: 600
    lineHeight: 1.25
    letterSpacing: -0.3px
  heading-sm:
    fontFamily: Noto Sans
    fontSize: 22px
    fontWeight: 600
    lineHeight: 1.30
  card-title:
    fontFamily: Noto Sans
    fontSize: 18px
    fontWeight: 600
    lineHeight: 1.40
  subtitle:
    fontFamily: Noto Sans
    fontSize: 16px
    fontWeight: 500
    lineHeight: 1.50
  body-md:
    fontFamily: Noto Sans
    fontSize: 15px
    fontWeight: 400
    lineHeight: 1.55
  body-md-medium:
    fontFamily: Noto Sans
    fontSize: 15px
    fontWeight: 500
    lineHeight: 1.55
  body-sm:
    fontFamily: Noto Sans
    fontSize: 14px
    fontWeight: 400
    lineHeight: 1.50
  body-sm-medium:
    fontFamily: Noto Sans
    fontSize: 14px
    fontWeight: 500
    lineHeight: 1.50
  caption:
    fontFamily: Noto Sans
    fontSize: 13px
    fontWeight: 400
    lineHeight: 1.45
  caption-bold:
    fontFamily: Noto Sans
    fontSize: 12px
    fontWeight: 600
    lineHeight: 1.40
    letterSpacing: 0.2px
  micro:
    fontFamily: Noto Sans
    fontSize: 11px
    fontWeight: 500
    lineHeight: 1.40
    letterSpacing: 0.3px
  button-md:
    fontFamily: Noto Sans
    fontSize: 14px
    fontWeight: 500
    lineHeight: 1.40
  price-display:
    fontFamily: Noto Sans
    fontSize: 24px
    fontWeight: 700
    lineHeight: 1.20

rounded:
  xs: 4px
  sm: 6px
  md: 8px
  lg: 12px
  xl: 16px
  xxl: 20px
  xxxl: 24px
  hero: 32px
  full: 9999px

spacing:
  xxs: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 20px
  xl: 24px
  xxl: 32px
  xxxl: 40px
  section-sm: 48px
  section: 64px
  section-lg: 80px
  hero: 96px

components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    typography: "{typography.button-md}"
    rounded: "{rounded.md}"
    padding: "8px 16px"
    height: 36px
  button-primary-pressed:
    backgroundColor: "#d65a1f"
    textColor: "{colors.on-primary}"
  button-primary-disabled:
    backgroundColor: "{colors.hairline}"
    textColor: "{colors.stone}"
  button-secondary:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink}"
    typography: "{typography.button-md}"
    rounded: "{rounded.md}"
    padding: "8px 16px"
    height: 36px
  button-outline:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    typography: "{typography.button-md}"
    rounded: "{rounded.md}"
    padding: "8px 16px"
    height: 36px
    border: "1px solid {colors.hairline}"
  button-ghost:
    backgroundColor: "transparent"
    textColor: "{colors.ink}"
    typography: "{typography.button-md}"
    rounded: "{rounded.md}"
    padding: "8px 16px"
    height: 36px
  button-link:
    backgroundColor: "transparent"
    textColor: "{colors.primary}"
    typography: "{typography.button-md}"
    padding: "0"
  button-destructive:
    backgroundColor: "{colors.destructive}"
    textColor: "{colors.on-dark}"
    typography: "{typography.button-md}"
    rounded: "{rounded.md}"
    padding: "8px 16px"
    height: 36px
  button-icon-square:
    backgroundColor: "transparent"
    textColor: "{colors.charcoal}"
    rounded: "{rounded.md}"
    size: 36px
    border: "1px solid {colors.hairline}"
  button-pill-cta:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    typography: "{typography.button-md}"
    rounded: "{rounded.full}"
    padding: "12px 24px"
    height: 44px
  food-card:
    backgroundColor: "{colors.canvas}"
    rounded: "{rounded.xl}"
    padding: "{spacing.md}"
    border: "1px solid {colors.hairline}"
  food-card-featured:
    backgroundColor: "{colors.canvas}"
    rounded: "{rounded.xxl}"
    padding: "{spacing.lg}"
    border: "1px solid {colors.hairline}"
  food-card-image:
    rounded: "{rounded.lg}"
    aspect: "4/3"
    backgroundColor: "{colors.surface}"
  card-base:
    backgroundColor: "{colors.canvas}"
    rounded: "{rounded.lg}"
    padding: "{spacing.xl}"
    border: "1px solid {colors.hairline}"
  card-section:
    backgroundColor: "{colors.surface-soft}"
    rounded: "{rounded.lg}"
    padding: "{spacing.xl}"
  cart-line-item:
    backgroundColor: "{colors.canvas}"
    rounded: "{rounded.md}"
    padding: "{spacing.md}"
    border: "0 0 1px {colors.hairline-soft} solid"
  promo-banner:
    backgroundColor: "{colors.primary-soft}"
    textColor: "{colors.primary}"
    typography: "{typography.body-sm-medium}"
    rounded: "{rounded.md}"
    padding: "{spacing.sm} {spacing.md}"
  promo-cta-card:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    rounded: "{rounded.xxl}"
    padding: "{spacing.section}"
  text-input:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    typography: "{typography.body-sm}"
    rounded: "{rounded.md}"
    padding: "{spacing.xs} {spacing.sm}"
    border: "1px solid {colors.hairline}"
    height: 36px
  text-input-focused:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    border: "1px solid {colors.primary}"
    ring: "3px {colors.primary} 30% opacity"
  text-input-error:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    border: "1px solid {colors.destructive}"
  search-input:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.charcoal}"
    typography: "{typography.body-sm}"
    rounded: "{rounded.md}"
    padding: "{spacing.xs} {spacing.md}"
    height: 40px
    border: "1px solid transparent"
  textarea:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    typography: "{typography.body-sm}"
    rounded: "{rounded.md}"
    padding: "{spacing.sm} {spacing.md}"
    border: "1px solid {colors.hairline}"
    minHeight: 80px
  select-trigger:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    typography: "{typography.body-sm}"
    rounded: "{rounded.md}"
    padding: "{spacing.xs} {spacing.sm}"
    height: 36px
    border: "1px solid {colors.hairline}"
  segmented-tab:
    backgroundColor: "transparent"
    textColor: "{colors.steel}"
    typography: "{typography.body-sm-medium}"
    padding: "{spacing.sm} {spacing.md}"
    border: "0 0 2px transparent solid"
  segmented-tab-active:
    backgroundColor: "transparent"
    textColor: "{colors.primary}"
    border: "0 0 2px {colors.primary} solid"
  pill-tab:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.steel}"
    typography: "{typography.body-sm-medium}"
    rounded: "{rounded.full}"
    padding: "{spacing.xs} {spacing.md}"
    border: "1px solid {colors.hairline}"
  pill-tab-active:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    rounded: "{rounded.full}"
    border: "1px solid {colors.primary}"
  category-chip:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.charcoal}"
    typography: "{typography.body-sm-medium}"
    rounded: "{rounded.full}"
    padding: "{spacing.xs} {spacing.md}"
  category-chip-active:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
  badge-success:
    backgroundColor: "{colors.success-bg}"
    textColor: "{colors.success-text}"
    typography: "{typography.caption-bold}"
    rounded: "{rounded.full}"
    padding: "2px 10px"
  badge-warning:
    backgroundColor: "{colors.warning-bg}"
    textColor: "{colors.warning-text}"
    typography: "{typography.caption-bold}"
    rounded: "{rounded.full}"
    padding: "2px 10px"
  badge-info:
    backgroundColor: "{colors.info-bg}"
    textColor: "{colors.info-text}"
    typography: "{typography.caption-bold}"
    rounded: "{rounded.full}"
    padding: "2px 10px"
  badge-destructive:
    backgroundColor: "{colors.destructive-bg}"
    textColor: "{colors.destructive}"
    typography: "{typography.caption-bold}"
    rounded: "{rounded.full}"
    padding: "2px 10px"
  badge-new:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    typography: "{typography.caption-bold}"
    rounded: "{rounded.full}"
    padding: "2px 10px"
  badge-discount:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    typography: "{typography.caption-bold}"
    rounded: "{rounded.sm}"
    padding: "2px 8px"
  qty-stepper:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    typography: "{typography.body-sm-medium}"
    rounded: "{rounded.full}"
    padding: "{spacing.xxs} {spacing.xs}"
    border: "1px solid {colors.hairline}"
    height: 32px
  qty-stepper-button:
    backgroundColor: "transparent"
    textColor: "{colors.charcoal}"
    rounded: "{rounded.full}"
    size: 24px
  data-table:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    typography: "{typography.body-sm}"
    rounded: "{rounded.lg}"
    border: "1px solid {colors.hairline}"
  data-table-header:
    backgroundColor: "{colors.surface-soft}"
    textColor: "{colors.steel}"
    typography: "{typography.caption-bold}"
    padding: "{spacing.sm} {spacing.md}"
  data-table-row:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    typography: "{typography.body-sm}"
    padding: "{spacing.md}"
    border: "0 0 1px {colors.hairline-soft} solid"
  sidebar-region:
    backgroundColor: "{colors.surface-soft}"
    textColor: "{colors.charcoal}"
    border: "0 1px 0 0 {colors.hairline} solid"
    padding: "{spacing.md} {spacing.sm}"
  sidebar-nav-item:
    backgroundColor: "transparent"
    textColor: "{colors.charcoal}"
    typography: "{typography.body-sm}"
    rounded: "{rounded.md}"
    padding: "{spacing.xs} {spacing.sm}"
  sidebar-nav-item-active:
    backgroundColor: "{colors.primary-soft}"
    textColor: "{colors.primary}"
    typography: "{typography.body-sm-medium}"
  top-nav-region:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    border: "0 0 1px {colors.hairline-soft} solid"
    padding: "{spacing.sm} {spacing.xl}"
    height: 64px
  cart-summary-card:
    backgroundColor: "{colors.canvas}"
    rounded: "{rounded.lg}"
    padding: "{spacing.xl}"
    border: "1px solid {colors.hairline}"
  cart-summary-total:
    typography: "{typography.price-display}"
    textColor: "{colors.primary}"
  order-status-pill:
    backgroundColor: "{colors.primary-soft}"
    textColor: "{colors.primary}"
    typography: "{typography.caption-bold}"
    rounded: "{rounded.full}"
    padding: "4px 12px"
  order-timeline-step:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.charcoal}"
    typography: "{typography.body-sm}"
    padding: "{spacing.sm} 0"
  empty-state:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.steel}"
    typography: "{typography.body-md}"
    padding: "{spacing.section-sm} {spacing.xl}"
  hero-band-marketing:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    typography: "{typography.hero-display}"
    rounded: "0"
    padding: "{spacing.hero} {spacing.xl}"
  food-grid:
    backgroundColor: "{colors.canvas}"
    padding: "{spacing.xxl} 0"
  footer-region:
    backgroundColor: "{colors.footer-bg}"
    textColor: "{colors.on-dark}"
    typography: "{typography.body-sm}"
    padding: "{spacing.section} {spacing.xxl}"
  footer-link:
    backgroundColor: "transparent"
    textColor: "{colors.muted}"
    typography: "{typography.body-sm}"
    padding: "{spacing.xxs} 0"
  toast-default:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.on-dark}"
    typography: "{typography.body-sm}"
    rounded: "{rounded.md}"
    padding: "{spacing.sm} {spacing.md}"
  toast-success:
    backgroundColor: "{colors.success-bg}"
    textColor: "{colors.success-text}"
    typography: "{typography.body-sm-medium}"
    rounded: "{rounded.md}"
    padding: "{spacing.sm} {spacing.md}"
  toast-error:
    backgroundColor: "{colors.destructive-bg}"
    textColor: "{colors.destructive}"
    typography: "{typography.body-sm-medium}"
    rounded: "{rounded.md}"
    padding: "{spacing.sm} {spacing.md}"
  dialog-surface:
    backgroundColor: "{colors.canvas}"
    rounded: "{rounded.xl}"
    padding: "{spacing.xl}"
    border: "1px solid {colors.hairline}"
  dialog-overlay:
    backgroundColor: "rgba(0, 0, 0, 0.5)"
---

## Overview

Notism stages itself as a friendly, appetite-driven food-ordering platform. The brand voice is warm and pragmatic — close to a neighborhood restaurant's menu in tone but engineered for fast, repeat ordering. The visual language anchors in a stark white canvas, near-black ink, and a saturated tangerine-orange primary (`{colors.primary}`) that signals action everywhere it appears: every CTA, every active tab, every selected category chip, every order-status pill. Where premium AI brands lean on typographic spectacle, Notism leans on photographic food cards and a tight grid that lets the dishes themselves carry the visual weight.

Noto Sans anchors every surface — chosen for legibility across the bilingual product (en/vi) where Vietnamese diacritics sit alongside Latin characters in catalog descriptions, address forms, and order receipts. Buttons default to a 8px-radius rectangular pill with 36px height (the shadcn baseline); a `{rounded.full}` pill variant is reserved for the marketing landing page's primary "Order Now" CTA. Food cards use `{rounded.xl}` (16px) corner softening for the everyday catalog and `{rounded.xxl}` (20px) for featured/promoted items. Admin and operations surfaces (kitchen kanban, orders table, settings) use the same chrome with denser spacing.

**Key Characteristics:**
- White canvas (`{colors.canvas}`) with near-black ink (`{colors.ink}`) — broken open by a single signature accent: tangerine `{colors.primary}` (#ed6e30)
- The orange primary owns ALL action moments: CTAs, active states, selected chips, order status, brand badges. There is no secondary accent color competing for attention.
- Noto Sans across the entire system; supports en/vi diacritics natively
- 8px-radius default buttons (shadcn standard); `{rounded.full}` pill reserved for hero/marketing CTAs and stepper controls
- Food cards use 16–20px corner softening with 4:3 photographic imagery; admin tables use 12px corner softening with dense type
- Three layout shells coexist: `client` (catalog/cart/order), `admin` (sidebar + table dashboards), and `auth` (centered single-column forms)
- Light + dark theme parity (the system ships both); orange primary stays unchanged across modes

## Colors

> Source: `src/app/assets/styles/index.css` (`:root` and `.dark` token blocks). All values are expressed as hex approximations of the OKLCH source values.

### Brand & Accent
- **Primary** (`{colors.primary}`): The single signature accent. Tangerine-orange. Used on every primary CTA, active tab, selected category chip, order-status pill, link emphasis, focus ring. The brand has only one accent color — orange does all the work.
- **On-Primary** (`{colors.on-primary}`): White text/icons rendered on top of orange surfaces.
- **Primary Soft** (`{colors.primary-soft}`): Pale-orange tint used on `sidebar-nav-item-active` background, badge backgrounds, promo banners, and order-status pills. Lets the brand color whisper instead of shout.

### Surface
- **Canvas** (`{colors.canvas}`): Primary page background and card surface (white).
- **Surface** (`{colors.surface}`): Subtle section backgrounds, search input rest, button-secondary fill.
- **Surface Soft** (`{colors.surface-soft}`): Quieter section divisions, table-header fill, sidebar-region background.
- **Hairline** (`{colors.hairline}`): 1px input border and primary divider.
- **Hairline Soft** (`{colors.hairline-soft}`): Quieter table-row divider and secondary section break.

### Text
- **Ink** (`{colors.ink}`): Primary headline and CTA text — the brand's near-black anchor.
- **Ink Strong** (`{colors.ink-strong}`): Pure black for hero displays where maximum contrast is required.
- **Charcoal** (`{colors.charcoal}`): Body text on light surfaces, sidebar-nav rest.
- **Slate** (`{colors.slate}`): Secondary text, metadata, food-card descriptions.
- **Steel** (`{colors.steel}`): Tertiary text, table headers, segmented-tab inactive labels.
- **Stone** (`{colors.stone}`): Muted captions, placeholder text.
- **Muted** (`{colors.muted}`): Footer link rest, disabled label text.

### Semantic
- **Success** (`{colors.success-bg}` / `{colors.success-text}`): Order-completed badges, "Available" pill, payment-confirmed toast.
- **Warning** (`{colors.warning-bg}` / `{colors.warning-text}`): "Low stock", "Pending" intermediate states.
- **Info** (`{colors.info-bg}` / `{colors.info-text}`): Informational toasts, side notices.
- **Destructive** (`{colors.destructive}` / `{colors.destructive-bg}`): Delete actions, validation errors, order-cancelled badges.

### Chart Palette
- `{colors.chart-1}` through `{colors.chart-5}` cover admin dashboard chart series. The first chart color intentionally echoes the brand orange so revenue charts feel native to the brand without re-using the exact CTA tone.

### Dark Mode
- **Dark Canvas** (`{colors.dark-canvas}`): Page background in dark mode.
- **Dark Surface** (`{colors.dark-surface}`): Card surface in dark mode.
- The orange primary, semantic tones, and chart colors stay constant across modes — only canvas/surface/ink invert.

## Typography

### Font Family
**Noto Sans** (primary): Geometric humanist sans-serif. Used across every surface, every role. Fallbacks: `ui-sans-serif`, `system-ui`, `sans-serif`, plus emoji families (`Apple Color Emoji`, `Segoe UI Emoji`, `Segoe UI Symbol`, `Noto Color Emoji`).

Noto Sans was chosen for its broad script coverage — Notism is bilingual (en/vi) and Vietnamese diacritics render cleanly without falling back to a system face. The neutral, slightly humanist character is approachable on food cards (where descriptive copy must read like a human wrote it) and dense enough on admin tables (where 12–14px rows demand legibility).

### Hierarchy

| Token | Size | Weight | Line Height | Letter Spacing | Use |
|---|---|---|---|---|---|
| `{typography.hero-display}` | 64px | 700 | 1.10 | -1.5px | Marketing landing hero ("Order what you crave") |
| `{typography.display-lg}` | 48px | 700 | 1.15 | -1px | Section openers, page heroes |
| `{typography.heading-lg}` | 36px | 700 | 1.20 | -0.5px | Page-level titles ("Your Cart", "Foods") |
| `{typography.heading-md}` | 28px | 600 | 1.25 | -0.3px | Subsection headers ("Recommended", "Recent Orders") |
| `{typography.heading-sm}` | 22px | 600 | 1.30 | 0 | Card group titles, dialog headers |
| `{typography.card-title}` | 18px | 600 | 1.40 | 0 | Food-card titles, settings-row labels |
| `{typography.subtitle}` | 16px | 500 | 1.50 | 0 | Section subtitles, lead body |
| `{typography.body-md}` | 15px | 400 | 1.55 | 0 | Primary body text, food descriptions |
| `{typography.body-md-medium}` | 15px | 500 | 1.55 | 0 | Body emphasis |
| `{typography.body-sm}` | 14px | 400 | 1.50 | 0 | Secondary body, table cells, navigation |
| `{typography.body-sm-medium}` | 14px | 500 | 1.50 | 0 | Active sidebar nav, button labels |
| `{typography.caption}` | 13px | 400 | 1.45 | 0 | Form helper text, metadata |
| `{typography.caption-bold}` | 12px | 600 | 1.40 | 0.2px | Badge labels, table-header text |
| `{typography.micro}` | 11px | 500 | 1.40 | 0.3px | Footer microcopy, fine print |
| `{typography.button-md}` | 14px | 500 | 1.40 | 0 | Button labels |
| `{typography.price-display}` | 24px | 700 | 1.20 | 0 | Cart total, food price emphasis |

### Principles
- **Tight hero leading** (1.10) and -1.5px letter-spacing on display sizes give marketing headlines a poster-grade impact.
- **Generous body leading** (1.50–1.55) keeps food descriptions and order receipts comfortable to scan.
- **Weight discipline:** 400 (body), 500 (medium emphasis), 600 (headings/buttons), 700 (display). Heavier weights are not used.
- **Single typeface** strategy — never mix Noto Sans with another sans-serif. Code samples (when shown in admin) use a system monospace fallback, but no second typeface enters the brand canvas.
- **Price display** is its own token (`{typography.price-display}`) — prices are brand moments and earn weight 700 + tight leading wherever they appear.

## Layout

### Spacing System
- **Base unit**: 4px (8px primary increment).
- **Tokens**: `{spacing.xxs}` (4px) · `{spacing.xs}` (8px) · `{spacing.sm}` (12px) · `{spacing.md}` (16px) · `{spacing.lg}` (20px) · `{spacing.xl}` (24px) · `{spacing.xxl}` (32px) · `{spacing.xxxl}` (40px) · `{spacing.section-sm}` (48px) · `{spacing.section}` (64px) · `{spacing.section-lg}` (80px) · `{spacing.hero}` (96px).
- **Section rhythm**: Marketing pages separate at `{spacing.hero}` (96px) above-fold, then `{spacing.section-lg}` (80px) below; client app surfaces tighten to `{spacing.section}` (64px); admin tables and settings panels compress to `{spacing.xxl}` (32px) between sections.
- **Card internal padding**: Standard food cards use `{spacing.md}` (16px); featured cards use `{spacing.lg}` (20px); cart/checkout summary cards expand to `{spacing.xl}` (24px); promo CTA strips push to `{spacing.section}` (64px).

### Grid & Container
- Marketing/client pages use a 1280px max-width with 24px gutters.
- Food catalog renders a 4-column grid on desktop with `{spacing.lg}` (20px) gaps; collapses 3 / 2 / 1 column at tablet / large mobile / mobile.
- Cart pages use a 2-column split: 7-of-12 cart line items + 5-of-12 sticky `cart-summary-card`.
- Admin pages use a 2-column shell: fixed 240px `sidebar-region` + fluid main area. Tables span the full main width.
- Auth pages center a single 400px-wide form card vertically and horizontally.
- Order detail uses a 2-column split: order-line items + order-summary card with timeline component below.

### Whitespace Philosophy
Marketing surfaces give photographic food imagery generous breathing room — `{spacing.hero}` (96px) above-the-fold creates visual oxygen for the 64px hero display. Inside the client app, whitespace tightens to product-density: catalog rows pack at `{spacing.lg}` (20px) gaps so users see more dishes per scroll. Admin surfaces tighten further — table rows pack down to `{spacing.md}` (16px), and the sidebar nav uses `{spacing.xs}` (8px) vertical rhythm.

## Elevation & Depth

The system runs predominantly flat. Elevation is reserved for floating overlays: dropdowns, dialogs, drawers, toasts, and the rare sticky cart summary on scroll.

| Level | Treatment | Use |
|---|---|---|
| 0 (flat) | No shadow; `{colors.hairline}` border | Default cards, table rows, form inputs |
| 1 (subtle) | `rgba(0, 0, 0, 0.04) 0px 1px 2px 0px` | Food cards on hover, sticky cart summary |
| 2 (card) | `rgba(0, 0, 0, 0.08) 0px 4px 6px -1px` | Dropdowns, popovers, select menus |
| 3 (atmospheric) | `rgba(0, 0, 0, 0.10) 0px 10px 15px -3px` | Floating action elements, sticky drawers |
| 4 (modal) | `rgba(0, 0, 0, 0.15) 0px 20px 25px -5px` | Dialogs, sheets, command palettes |

### Decorative Depth
- Food card images carry their own depth via the photograph itself — no shadow needed; the food does the work.
- Hover/focus brings a 3px ring in `{colors.primary}` at 30% opacity around inputs and selectable cards. This is the system's only interactive elevation cue beyond flat → subtle.
- Toast notifications float at level 3 and slide in from the bottom-right (or top-center on mobile).

## Shapes

### Border Radius Scale

| Token | Value | Use |
|---|---|---|
| `{rounded.xs}` | 4px | Inline code chips, micro indicators |
| `{rounded.sm}` | 6px | Compact controls, small badges |
| `{rounded.md}` | 8px | Buttons, inputs, selects, dropdowns — the system default |
| `{rounded.lg}` | 12px | Standard cards (radius var base), data tables, dialogs |
| `{rounded.xl}` | 16px | Food cards, food-card image insets |
| `{rounded.xxl}` | 20px | Featured food cards, promo CTA cards |
| `{rounded.xxxl}` | 24px | Hero promotional surfaces |
| `{rounded.hero}` | 32px | Reserved (full-bleed hero photographic surfaces) |
| `{rounded.full}` | 9999px | Marketing pill CTAs, badges, category chips, qty steppers, avatar circles |

### Photography Geometry
- Food card photography is treated as a 4:3 aspect-ratio image with `{rounded.lg}` (12px) inset rounding inside a `{rounded.xl}` (16px) outer card frame. The doubled-radius nested treatment is the catalog's visual signature.
- Featured/promo cards push to `{rounded.xxl}` (20px) outer with `{rounded.lg}` (12px) inset.
- Avatar circles (user profile, admin staff list) are `{rounded.full}` — perfect circles.
- The default radius variable (`--radius`) resolves to `{rounded.lg}` (12px) — `xs/sm/md/xl` derive from it.

## Components

> Per the no-hover policy, hover states are NOT documented. Default and pressed/active/disabled states only.

### Buttons

**`button-primary`** — Orange-fill primary CTA, the dominant action across all surfaces.
- Background `{colors.primary}`, text `{colors.on-primary}`, typography `{typography.button-md}`, padding `8px 16px`, height 36px, rounded `{rounded.md}`.
- Pressed state `button-primary-pressed` darkens to a deeper tangerine.
- Disabled state `button-primary-disabled` flattens to `{colors.hairline}` background with `{colors.stone}` text.

**`button-secondary`** — Surface-fill quieter action, paired with primary in dual-CTA layouts.
- Background `{colors.surface}`, text `{colors.ink}`, typography `{typography.button-md}`, padding `8px 16px`, height 36px, rounded `{rounded.md}`.

**`button-outline`** — Bordered white-fill button for tertiary actions and toolbar utilities.
- Background `{colors.canvas}`, text `{colors.ink}`, border `1px solid {colors.hairline}`, typography `{typography.button-md}`, padding `8px 16px`, height 36px, rounded `{rounded.md}`.

**`button-ghost`** — Borderless transparent button for inline actions inside cards and toolbars.
- Background transparent, text `{colors.ink}`, typography `{typography.button-md}`, padding `8px 16px`, height 36px, rounded `{rounded.md}`.

**`button-link`** — Inline orange-text link. Underlines on activation.
- Background transparent, text `{colors.primary}`, typography `{typography.button-md}`.

**`button-destructive`** — Delete/remove action.
- Background `{colors.destructive}`, text `{colors.on-dark}`, typography `{typography.button-md}`, padding `8px 16px`, height 36px, rounded `{rounded.md}`.

**`button-icon-square`** — 36×36px square utility button (close, expand, more-actions).
- Background transparent, text `{colors.charcoal}`, border `1px solid {colors.hairline}`, rounded `{rounded.md}`.

**`button-pill-cta`** — Reserved for marketing landing hero "Order Now" CTA.
- Background `{colors.primary}`, text `{colors.on-primary}`, typography `{typography.button-md}`, padding `12px 24px`, height 44px, rounded `{rounded.full}`. Pill shape signals "this is the brand moment."

### Food Cards & Containers

**`food-card`** — Standard catalog tile.
- Background `{colors.canvas}`, rounded `{rounded.xl}` (16px), padding `{spacing.md}`, border `1px solid {colors.hairline}`.
- Layout: `food-card-image` (4:3, 12px inset rounding) → title in `{typography.card-title}` → 2-line description in `{typography.body-sm}` `{colors.slate}` → price/qty-stepper row.
- Optional badges top-right: `badge-discount` (orange) or `badge-new` (orange).

**`food-card-featured`** — Promoted/recommended catalog tile.
- Background `{colors.canvas}`, rounded `{rounded.xxl}` (20px), padding `{spacing.lg}`, border `1px solid {colors.hairline}`.
- Carries a slightly larger image (16:10 instead of 4:3) and an inline `badge-new` over the image top-left.

**`food-card-image`** — The photographic frame inside food cards.
- Aspect 4:3, rounded `{rounded.lg}` (12px), background `{colors.surface}` (skeleton placeholder).

**`card-base`** — Standard utility card (settings rows, order summary, payment forms).
- Background `{colors.canvas}`, rounded `{rounded.lg}` (12px), padding `{spacing.xl}`, border `1px solid {colors.hairline}`.

**`card-section`** — Quieter section panel on light surface (e.g., grouped settings, order details).
- Background `{colors.surface-soft}`, rounded `{rounded.lg}`, padding `{spacing.xl}`.

**`cart-line-item`** — Single line in the cart list.
- Background `{colors.canvas}`, padding `{spacing.md}`, bottom border `1px solid {colors.hairline-soft}`.
- Layout: 64×64px square image (rounded `{rounded.md}`) → title + variant in `{typography.body-md}` → qty stepper + line total. Compact, dense.

**`promo-banner`** — Pale-orange tinted strip ("Free delivery over $25") above the catalog.
- Background `{colors.primary-soft}`, text `{colors.primary}`, typography `{typography.body-sm-medium}`, rounded `{rounded.md}`, padding `{spacing.sm} {spacing.md}`.

**`promo-cta-card`** — Bright orange full-width promo strip ("Get 20% off your first order").
- Background `{colors.primary}`, text `{colors.on-primary}`, rounded `{rounded.xxl}`, padding `{spacing.section}`. Embedded button uses a white-on-orange `button-outline` variant.

### Inputs & Forms

**`text-input`** — Standard text field.
- Background `{colors.canvas}`, text `{colors.ink}`, typography `{typography.body-sm}`, border `1px solid {colors.hairline}`, rounded `{rounded.md}`, padding `{spacing.xs} {spacing.sm}`, height 36px.

**`text-input-focused`** — Activated state.
- Border switches to `1px solid {colors.primary}`; 3px outer focus ring at 30% primary opacity.

**`text-input-error`** — Validation error state.
- Border switches to `1px solid {colors.destructive}`; error label below in matching red `{typography.caption}`.

**`search-input`** — Catalog top-bar search.
- Background `{colors.surface}`, text `{colors.charcoal}`, typography `{typography.body-sm}`, rounded `{rounded.md}`, padding `{spacing.xs} {spacing.md}`, height 40px, transparent border (focuses to `{colors.primary}`).
- Often paired with a leading magnifying-glass icon in `{colors.steel}`.

**`textarea`** — Multi-line input.
- Same chrome as `text-input` but min-height 80px, padding `{spacing.sm} {spacing.md}`.

**`select-trigger`** — Select-dropdown trigger.
- Same chrome as `text-input` with trailing chevron icon in `{colors.steel}`.

### Tabs & Filters

**`segmented-tab`** + **`segmented-tab-active`** — Underline-style tab navigation (Order Detail: Items / Timeline / Receipt; Admin: Pending / Preparing / Completed).
- Inactive: text `{colors.steel}`, transparent background, padding `{spacing.sm} {spacing.md}`.
- Active: text shifts to `{colors.primary}`, 2px bottom border in `{colors.primary}`.

**`pill-tab`** + **`pill-tab-active`** — Pill-style filter (settings sections, account tabs).
- Inactive: background `{colors.canvas}`, text `{colors.steel}`, border `1px solid {colors.hairline}`, padding `{spacing.xs} {spacing.md}`, rounded `{rounded.full}`.
- Active: background `{colors.primary}`, text `{colors.on-primary}`, no visible border.

**`category-chip`** + **`category-chip-active`** — Horizontal-scroll category filter at the top of the food catalog (Pizza, Burgers, Drinks…).
- Inactive: background `{colors.surface}`, text `{colors.charcoal}`, typography `{typography.body-sm-medium}`, rounded `{rounded.full}`, padding `{spacing.xs} {spacing.md}`.
- Active: background `{colors.primary}`, text `{colors.on-primary}`.

### Quantity Stepper

**`qty-stepper`** — Pill-shaped +/- control on food cards and cart lines.
- Outer pill: background `{colors.canvas}`, border `1px solid {colors.hairline}`, rounded `{rounded.full}`, height 32px, padding `{spacing.xxs} {spacing.xs}`.
- Inner buttons: 24×24px circular minus and plus, transparent background, `{colors.charcoal}` text — disabled states drop to `{colors.muted}`.
- The numeric quantity in the middle uses `{typography.body-sm-medium}`.

### Badges & Status

**`badge-success`** — Pale-green confirmation badge ("Available", "Delivered").
- Background `{colors.success-bg}`, text `{colors.success-text}`, typography `{typography.caption-bold}`, rounded `{rounded.full}`, padding `2px 10px`.

**`badge-warning`** — Pale-amber "Preparing" / "Low stock" pill.
- Background `{colors.warning-bg}`, text `{colors.warning-text}`, typography `{typography.caption-bold}`, rounded `{rounded.full}`.

**`badge-info`** — Pale-blue "Info" / "Updated" pill.
- Background `{colors.info-bg}`, text `{colors.info-text}`.

**`badge-destructive`** — Pale-red "Cancelled" / error pill.
- Background `{colors.destructive-bg}`, text `{colors.destructive}`.

**`badge-new`** — Solid orange "NEW" pill on featured food cards.
- Background `{colors.primary}`, text `{colors.on-primary}`, typography `{typography.caption-bold}`, rounded `{rounded.full}`.

**`badge-discount`** — Solid orange "−20%" rectangular chip on food card image overlay.
- Background `{colors.primary}`, text `{colors.on-primary}`, typography `{typography.caption-bold}`, rounded `{rounded.sm}`.

**`order-status-pill`** — Pale-orange status indicator on order rows ("Confirmed", "Out for delivery").
- Background `{colors.primary-soft}`, text `{colors.primary}`, typography `{typography.caption-bold}`, rounded `{rounded.full}`, padding `4px 12px`.

### Data Tables (Admin)

**`data-table`** — Admin orders/foods/users table.
- Background `{colors.canvas}`, text `{colors.ink}`, typography `{typography.body-sm}`, rounded `{rounded.lg}`, border `1px solid {colors.hairline}`.

**`data-table-header`** — Top header row.
- Background `{colors.surface-soft}`, text `{colors.steel}`, typography `{typography.caption-bold}`, padding `{spacing.sm} {spacing.md}`.

**`data-table-row`** — Body rows.
- Background `{colors.canvas}`, text `{colors.ink}`, typography `{typography.body-sm}`, padding `{spacing.md}`, bottom border `1px solid {colors.hairline-soft}`.

### Navigation

**`top-nav-region` (Client)** — Sticky white bar with logo, link list, search, cart, and account.
- Background `{colors.canvas}`, height 64px, bottom border `1px solid {colors.hairline-soft}`, padding `{spacing.sm} {spacing.xl}`.
- Left: Notism wordmark + horizontal link list (Foods, Orders, Settings).
- Center: `search-input`.
- Right: language switcher + cart-icon button (with item-count badge in orange) + avatar.

**`sidebar-region` (Admin)** — Fixed 240px left rail.
- Background `{colors.surface-soft}`, right border `1px solid {colors.hairline}`, padding `{spacing.md} {spacing.sm}`.
- Top: Notism wordmark.
- Body: `sidebar-nav-item` list grouped into sections (Operations, Catalog, Settings).

**`sidebar-nav-item`** + **`sidebar-nav-item-active`** — Sidebar link entries.
- Inactive: background transparent, text `{colors.charcoal}`, typography `{typography.body-sm}`, rounded `{rounded.md}`, padding `{spacing.xs} {spacing.sm}`.
- Active: background `{colors.primary-soft}`, text `{colors.primary}`, typography `{typography.body-sm-medium}`. Optional 2px left-edge accent in `{colors.primary}`.

### Cart & Checkout Signature Components

**`cart-summary-card`** — Sticky right-rail card with line totals and CTA.
- Background `{colors.canvas}`, rounded `{rounded.lg}`, padding `{spacing.xl}`, border `1px solid {colors.hairline}`.
- Sections: subtotal · delivery · tax · separator · total (in `cart-summary-total`) · `button-primary` "Checkout" (full-width).

**`cart-summary-total`** — The grand-total row inside the summary card.
- Typography `{typography.price-display}`, color `{colors.primary}`. The orange total is the visual climax of the cart page.

### Order Tracking Signature Components

**`order-timeline-step`** — Single step in the order-status timeline ("Order placed → Confirmed → Preparing → Out for delivery → Delivered").
- Layout: 12px `{colors.primary}` filled circle (or `{colors.hairline}` for upcoming) + 2px vertical line connector + step label in `{typography.body-sm-medium}` + timestamp in `{typography.caption}` `{colors.steel}`.

### Toasts & Dialogs

**`toast-default`** — Black-fill informational toast.
- Background `{colors.ink}`, text `{colors.on-dark}`, typography `{typography.body-sm}`, rounded `{rounded.md}`, padding `{spacing.sm} {spacing.md}`.

**`toast-success`** — Pale-green success toast ("Item added to cart").
- Background `{colors.success-bg}`, text `{colors.success-text}`.

**`toast-error`** — Pale-red error toast.
- Background `{colors.destructive-bg}`, text `{colors.destructive}`.

**`dialog-surface`** — Modal dialog inner surface.
- Background `{colors.canvas}`, rounded `{rounded.xl}` (16px), padding `{spacing.xl}`, border `1px solid {colors.hairline}`. Hosts the level-4 modal shadow above `dialog-overlay`.

**`dialog-overlay`** — Scrim behind dialogs.
- Background `rgba(0, 0, 0, 0.5)`. Click-outside dismisses unless dialog is locked.

### Empty States

**`empty-state`** — "No orders yet", "Cart is empty", "No foods found" centered placeholder.
- Background `{colors.canvas}`, padding `{spacing.section-sm} {spacing.xl}`, centered.
- Layout: 80×80px illustration → heading in `{typography.heading-sm}` → body in `{typography.body-md}` `{colors.steel}` → optional `button-primary` to recover.

### Marketing Signature Components

**`hero-band-marketing`** — Centered landing hero with 64px display and dual-CTA pair.
- Layout: centered headline in `{typography.hero-display}` `{colors.ink}`, centered subtitle in `{typography.subtitle}` `{colors.steel}`, centered button row (`button-pill-cta` "Order Now" + `button-outline` "Browse Menu").
- Background often pairs with a 4-column food-photo collage running across the bottom.

**`food-grid`** — The 4-column catalog body.
- Background `{colors.canvas}`, padding `{spacing.xxl} 0`. Grid gap `{spacing.lg}`. Card variant alternates between `food-card` and `food-card-featured` for visual rhythm.

**`footer-region`** — Dense black-canvas multi-column footer.
- Background `{colors.footer-bg}`, padding `{spacing.section} {spacing.xxl}`.
- Top row: Notism wordmark + tagline + social icons.
- Body: 4-column link grid (Eat / Account / Company / Legal).
- Section headers in `{typography.body-sm-medium}` `{colors.on-dark}`.

**`footer-link`** — Individual footer link.
- Background transparent, text `{colors.muted}`, typography `{typography.body-sm}`, padding `{spacing.xxs} 0`.

## Do's and Don'ts

### Do
- Use `{colors.primary}` (orange) as the dominant CTA color — it is the single brand accent and owns every action moment.
- Pair `{colors.primary}` with `{colors.primary-soft}` for tinted backgrounds on active states (sidebar, status pills, badges) — orange whispers as well as it shouts.
- Apply `{rounded.md}` (8px) to every standard button, every input, every dropdown — this is the system default.
- Reserve `{rounded.full}` for marketing pill CTAs, badges, category chips, qty steppers, and avatars.
- Pair `{rounded.xl}` (16px) standard food cards with `{rounded.xxl}` (20px) featured food cards in the same viewport — the radius contrast signals priority.
- Use `{typography.price-display}` weight 700 wherever a price is shown — prices are brand moments.
- Maintain dark/light theme parity for new tokens; the orange primary stays unchanged across modes.

### Don't
- Don't introduce a second brand accent color. Notism has one accent: orange. Greens, blues, purples appear ONLY as semantic tokens (success/info/destructive) — never as decorative or brand expressions.
- Don't over-apply `{colors.primary}` to body copy or large surfaces — it loses meaning when overused.
- Don't soften corners on standard buttons beyond `{rounded.md}`; the 8px radius is the platform's signature.
- Don't introduce a second display typeface; Noto Sans handles every role and supports en/vi.
- Don't apply heavy shadows on white cards; flat-with-borders is the default. Reserve elevation for floating overlays.
- Don't put gradients on standard buttons; the system is solid-fill only.
- Don't use a different color for active vs hover states — the active state owns `{colors.primary}`; hover stays neutral with subtle background tint.

## Responsive Behavior

### Breakpoints
| Name | Width | Key Changes |
|---|---|---|
| Mobile (small) | < 480px | Single column. Hero drops to 36px. Top nav collapses to hamburger drawer. Food grid 1-column. Footer 1-column accordion. |
| Mobile (large) | 480 – 767px | Same as small but food grid 2-column. |
| Tablet | 768 – 1023px | 3-column food grid. Admin sidebar collapses to drawer. Cart switches from 2-column to single-column with summary at bottom. |
| Desktop | 1024 – 1279px | Full 4-column food grid; admin sidebar fixed at 240px. |
| Wide Desktop | ≥ 1280px | Wider hero gutters, 1280px max-width container, larger food photography. |

### Touch Targets
- Standard buttons render at 36px effective height — bumps to 44px on mobile via padding override.
- `qty-stepper` inner buttons render at 24×24px — bumps to 32×32px on mobile (outer pill grows to 40px height).
- Form inputs render at 36px height; bumps to 44px on mobile.
- Sidebar nav items render at ~32px tall — bumps to 44px on mobile drawers.
- Category chips and pill tabs render at 32px — bumps to 40px on mobile.

### Collapsing Strategy
- **Promo banner** stays full-width; collapses to single line at < 480px with truncation.
- **Top nav** below 768px collapses to hamburger; horizontal links move into drawer; search collapses to icon-trigger.
- **Admin sidebar**: 240px fixed at desktop → drawer at < 1024px → bottom-tab bar at < 480px.
- **Food grid**: 4-column → 3-col tablet → 2-col large mobile → 1-col small mobile.
- **Cart layout**: 2-column desktop → stacked 1-column at < 1024px with `cart-summary-card` pinned to bottom on mobile.
- **Hero typography**: `{typography.hero-display}` (64px) → 48px at < 1024px → 36px at < 768px → 28px at < 480px.
- **Order timeline**: vertical at all sizes; step labels truncate to 1 line at < 480px.

### Image Behavior
- Food card imagery uses 4:3 aspect ratio with `{colors.surface}` skeleton background; lazy-loaded below the fold.
- Featured cards switch to 16:10 imagery for a more cinematic feel.
- Avatar imagery uses 1:1 aspect ratio with `{rounded.full}` masking.

## Iteration Guide

1. Focus on ONE component at a time. The system has high internal consistency.
2. Reference component names and tokens directly (`{colors.primary}`, `{component-name}-pressed`, `{rounded.full}`) — do not paraphrase.
3. Run `npx @google/design.md lint DESIGN.md` after edits to catch broken refs and contrast issues.
4. Add new variants as separate `components:` entries (`-pressed`, `-disabled`, `-active`, `-error`).
5. Default to `{typography.body-md}` for body and `{typography.subtitle}` for emphasis. Headlines step down `hero-display → display-lg → heading-lg → heading-md → heading-sm`.
6. Keep the brand orange (`{colors.primary}`) confined to actions, active states, and brand badges. If orange appears on a generic surface, ask whether it earned that surface.
7. The 8px radius button (`{rounded.md}`) is the everyday button. Reach for `{rounded.full}` only at marketing CTAs, qty steppers, badges, and category chips.
8. Both light and dark themes must stay in lockstep — when adding a token, define both modes in `src/app/assets/styles/index.css`.

## Known Gaps

- Animation/transition timings are not extracted; recommend 150–200ms ease-out for state transitions, 300ms ease-in-out for drawers and dialogs.
- Form validation success state (green ring, success badge after submit) is implied but not formalized — implement following standard `{colors.success-text}` border + success badge patterns.
- Empty-state illustrations are not formalized as a system asset library; current usage relies on individual SVG files per page.
- Code syntax highlighting palette (admin developer console, API key viewer) is not formalized; rely on a system monospace fallback with minimal coloring.
- Print stylesheet for receipts (order detail print view) is not yet captured — recommend stripping color to `{colors.ink}` on `{colors.canvas}` and bumping body to `{typography.body-md}`.
- Mobile bottom-tab bar (proposed for client surfaces below 480px) is sketched in this doc but not yet shipped in code.
