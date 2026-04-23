# Design System — Notism Web

## 1. Visual Theme & Atmosphere

Notism's interface is a clean, modern food-ordering marketplace — efficient, bright, and appetizing. The entire experience is built on pure white and near-white card surfaces that provide maximum contrast for food imagery and content. Where many platforms use flat or muted palettes, Notism's primary accent is a vivid orange-amber — energetic, warm, and appetite-stimulating — that punctuates an otherwise neutral cool-gray canvas.

The UI leans on shadcn/ui's New York style: crisp borders, tight rounded corners (not pill-shaped), and understated shadows. The type stack is Noto Sans — a workhorse geometric humanist that reads crisply at any weight. Weight carries the entire hierarchy: `font-medium` for labels, `font-semibold` for card titles, `font-bold` for section headers, `font-black` with `tracking-tight` for page-level titles. This escalating weight ladder gives every heading a clear identity without needing size jumps alone.

Pages arrive with gradient hero banners — a vertical fade from `primary/20` through `primary/5` to `background` — anchored by large decorative blurred blobs of `primary/20`. This technique adds visual depth on what would otherwise be flat white sections. Below the hero, content lives in bordered white cards on the same white page background; depth is achieved through borders and `shadow-sm` rather than layered surfaces.

Dark mode is fully supported: the entire color system flips via CSS custom properties, with no component-level exceptions needed.

**Key Characteristics:**
- White/near-white surface stack (`oklch(1 0 0)` → `oklch(0.967 ...)`) with cool-toned gray neutrals
- Orange-amber primary (`oklch(68.6% 0.236 46.2)`) — vivid, warm, used for all brand moments and interactive highlights
- Noto Sans type family — single font, weight-based hierarchy (`medium` → `semibold` → `bold` → `black`)
- Gradient hero banners with decorative blurred primary blobs as section openers
- Card-heavy layouts: `rounded-xl border shadow-sm` cards on flat white backgrounds
- Cool-toned neutral scale — every gray has a slightly blue undertone (OKLCH hue 285–286)
- `backdrop-blur` overlays on image cards for semi-transparent badge layering
- Full dark mode via CSS custom property inversion

## 2. Color Palette & Roles

### Primary
- **Orange Amber** (`oklch(68.6% 0.236 46.2)`): The brand color. Used for primary buttons, active states, links, focus rings, and all brand-identity moments. In light mode it's a vivid warm orange; in dark mode it stays the same — the one color that doesn't flip.
- **Primary Foreground** (`oklch(1 0 0)`): Pure white — text on primary-colored surfaces.

### Surfaces & Backgrounds
- **Background** (`oklch(1 0 0)` / dark: `oklch(0.1 0.001 0)`): Page canvas — pure white in light, near-black in dark.
- **Card** (`oklch(1 0 0)` / dark: `oklch(0.18 0.006 285.885)`): Card surfaces — same as background in light mode; lifted dark gray in dark mode.
- **Sidebar** (`oklch(0.985 0 0)` / dark: `oklch(0.18 0.006 285.885)`): Sidebar background — off-white in light.
- **Popover** (`oklch(1 0 0)` / dark: `oklch(0.18 0.006 285.885)`): Dropdown and popover surfaces — same as card.

### Neutral & Text
- **Foreground** (`oklch(0.141 0.005 285.823)` / dark: `oklch(0.985 0 0)`): Primary text — near-black with a subtle cool undertone.
- **Muted** (`oklch(0.967 0.001 286.375)` / dark: `oklch(0.22 0.006 286.033)`): Subtly tinted near-white — chip backgrounds, tags, secondary surfaces.
- **Muted Foreground** (`oklch(0.552 0.016 285.938)` / dark: `oklch(0.705 0.015 286.067)`): Secondary text — medium cool gray. Used for captions, placeholders, de-emphasized metadata.
- **Secondary** (`oklch(0.967 0.001 286.375)` / dark: `oklch(0.22 0.006 286.033)`): Same value as muted — secondary button backgrounds.
- **Accent** (`oklch(0.967 0.001 286.375)` / dark: `oklch(0.22 0.006 286.033)`): Hover highlight backgrounds on ghost elements.

### Interactive
- **Border / Input** (`oklch(0.92 0.004 286.32)` / dark: `oklch(1 0 0 / 10%)`): All structural borders and input borders — light cool gray.
- **Ring** (`oklch(68.6% 0.236 46.2)` — same as primary): Focus outline ring color. Applied at `ring-[3px]` weight.

### Semantic
- **Destructive** (`oklch(0.577 0.245 27.325)` / dark: `oklch(0.704 0.191 22.216)`): Errors, deletions, irreversible actions — warm red.
- **Success** (`oklch(0.4 0.15 145)` / dark: `oklch(0.65 0.12 145)`): Confirmations, completed states — forest green.
- **Warning** (`oklch(0.45 0.15 70)` / dark: `oklch(0.65 0.12 70)`): Cautions and alerts — amber/ochre.
- **Info** (`oklch(0.45 0.15 240)` / dark: `oklch(0.65 0.12 240)`): Informational states — cool blue.

### Data Visualization (light / dark)
| Token | Light | Dark | Character |
|-------|-------|------|-----------|
| `--chart-1` | `oklch(0.646 0.222 41.116)` | `oklch(0.488 0.243 264.376)` | Orange (light) / Blue-violet (dark) |
| `--chart-2` | `oklch(0.6 0.118 184.704)` | `oklch(0.696 0.17 162.48)` | Teal |
| `--chart-3` | `oklch(0.398 0.07 227.392)` | `oklch(0.769 0.188 70.08)` | Navy / Amber |
| `--chart-4` | `oklch(0.828 0.189 84.429)` | `oklch(0.627 0.265 303.9)` | Yellow / Violet |
| `--chart-5` | `oklch(0.769 0.188 70.08)` | `oklch(0.645 0.246 16.439)` | Warm yellow / Red |

### Sidebar Variants
All sidebar tokens mirror the main system; `--sidebar-primary` = orange amber; `--sidebar-primary-foreground` differs per mode.

### Opacity Modifiers (Tailwind pattern)
Notism uses **no gradient color stops**. Visual gradients are achieved via Tailwind opacity suffixes on token names:
- `primary/20`, `primary/5` — hero section gradient
- `background/90` — card overlay with backdrop blur
- `background/60` — out-of-stock dimming overlay
- `ring/50` — focus ring at half opacity
- `destructive/20` — error ring glow

## 3. Typography Rules

### Font Family
**All text**: `Noto Sans`, fallback: `ui-sans-serif, system-ui, sans-serif`, then emoji fallbacks.

*Single font family. No serif. No monospace except in code blocks. Noto Sans handles all weights 400–900.*

### Hierarchy

| Role | Tailwind Classes | Size | Weight | Line Height | Letter Spacing | Notes |
|------|-----------------|------|--------|-------------|----------------|-------|
| Page Title | `text-3xl font-black tracking-tight sm:text-4xl` | 30px → 36px | 900 | tight | -0.025em | Primary hero headings |
| Section Header | `text-2xl font-bold` | 24px | 700 | tight | normal | Admin page titles, section anchors |
| Card Title | `text-xl font-semibold` | 20px | 600 | tight | normal | Card headings, feature titles |
| Sub-heading | `text-lg font-semibold` | 18px | 600 | snug | normal | Subsection headers |
| Body Large | `text-base` | 16px | 400 | normal | normal | Form inputs, primary body text |
| Body Standard | `text-sm` | 14px | 400 | normal | normal | Default UI text, button labels |
| Caption | `text-sm text-muted-foreground` | 14px | 400 | normal | normal | Metadata, subtitles, helper text |
| Label | `text-sm font-medium` | 14px | 500 | normal | normal | Form labels, column headers |
| Badge | `text-xs font-semibold` | 12px | 600 | normal | normal | All Badge components |
| Small | `text-xs text-muted-foreground` | 12px | 400 | normal | normal | Fine print, timestamps |

### Principles
- **Weight drives hierarchy**: Size escalation alone is insufficient. Page titles must use `font-black`; section headers `font-bold`; card titles `font-semibold`; labels `font-medium`. Never use weight below `font-medium` for anything interactive.
- **`tracking-tight` for headings**: All `text-2xl` and above use `tracking-tight` (-0.025em). This compresses large headings to look intentional rather than loose.
- **`text-muted-foreground` for secondary text**: Captions, subtitles, and helper text always use `text-muted-foreground`. Never use raw gray colors.
- **`text-sm` is the default**: Most UI text (`td`, button labels, form items) is `text-sm`. Only hero subtitles and body paragraphs reach `text-base`.
- **Responsive type**: Page titles scale with `sm:text-4xl`. Nothing else uses responsive font sizing unless in a hero section.

## 4. Component Stylings

### Buttons

**Default (Primary)**
- Classes: `bg-primary text-primary-foreground hover:bg-primary/90`
- Base: `h-9 px-4 py-2 rounded-md text-sm font-medium`
- Orange amber fill, white text. The single highest-emphasis interactive element on any page.
- Hover: fades to 90% primary opacity.

**Destructive**
- Classes: `bg-destructive text-white hover:bg-destructive/90`
- Red fill, white text. Reserved exclusively for irreversible actions (delete, remove).
- Always paired with a Dialog confirmation — never placed as a primary action without a guard.

**Outline**
- Classes: `border bg-background text-foreground hover:bg-accent/10 hover:border-primary/40`
- Bordered, transparent background. Secondary actions, cancel buttons, non-primary CTAs.
- Hover introduces a whisper of accent tint and a touch of primary on the border.

**Secondary**
- Classes: `bg-secondary text-secondary-foreground hover:bg-secondary/80`
- Uses the muted near-white background — visually quiet, used for tag-adjacent actions.

**Ghost**
- Classes: `hover:bg-accent hover:text-accent-foreground`
- Invisible until hover. Navigation actions, icon-only toolbars, inline table actions.

**Link**
- Classes: `text-primary underline-offset-4 hover:underline`
- Looks like a hyperlink. Used for navigation CTAs in text contexts.

**Sizes**
| Size | Classes | Height | Notes |
|------|---------|--------|-------|
| `default` | `h-9 px-4 py-2` | 36px | Standard action button |
| `sm` | `h-8 px-3` | 32px | Toolbar buttons, compact actions |
| `lg` | `h-10 px-6` | 40px | Primary hero CTAs |
| `xs` | `h-6 px-2 text-xs` | 24px | Inline chip-like actions |
| `icon` | `size-9` | 36px | Icon-only, square |
| `icon-sm` | `size-8` | 32px | Compact icon-only |
| `icon-lg` | `size-10` | 40px | Prominent icon-only |
| `icon-xs` | `size-6` | 24px | Tight icon-only |

**Universal button traits**: `inline-flex items-center gap-2 whitespace-nowrap rounded-md transition-all disabled:pointer-events-none disabled:opacity-50`. SVG icons inside buttons auto-size to `size-4` (16px) via `[&_svg:not([class*='size-'])]:size-4`.

---

### Cards

**Standard Card**
- Classes: `bg-card text-card-foreground flex flex-col gap-6 rounded-xl border py-6 shadow-sm`
- White surface, `rounded-xl` (16px), 1px border, gentle `shadow-sm`. Default container for all grouped content.
- Subcomponents: `CardHeader` (px-6, grid layout for title + action), `CardTitle` (`font-semibold leading-none`), `CardDescription` (`text-sm text-muted-foreground`), `CardContent` (px-6), `CardFooter` (px-6, flex row), `CardAction` (col-2 slot in header grid).

**Sticky Summary Card** (Cart, Order Detail)
- Same `Card` component with `className="sticky top-4"` applied by the parent.
- Placed in the right column of a `lg:grid-cols-3` layout. Left 2 columns = main content, right 1 = sticky summary.

**Data Table Container** (Admin pages)
- Card wrapping: `<Card><CardHeader>...</CardHeader><CardContent className="p-0"><Table>...</Table></CardContent></Card>`
- No card padding on table content (`p-0` override); padding stays only in the header area.

---

### Badges

- Base classes: `inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors`
- Variants:

| Variant | Classes | Use |
|---------|---------|-----|
| `default` | `bg-primary text-primary-foreground` | Primary label |
| `secondary` | `bg-secondary text-secondary-foreground` | Neutral tag |
| `destructive` | `bg-destructive text-destructive-foreground` | Error/critical status |
| `outline` | `text-foreground border` (shows border only) | Subtle label |
| `success` | `border-success/30 bg-success/15 text-success` | Completed/active status |

**Custom inline badge pattern** (not Badge component): `rounded-full bg-primary/10 px-3 py-0.5 text-sm font-semibold text-primary` — used for count indicators and hero pill labels.

---

### Inputs & Forms

**Input**
- Classes: `border-input h-9 w-full rounded-md border bg-transparent px-3 py-1 text-base shadow-xs placeholder:text-muted-foreground`
- Height 36px, `rounded-md` (10px), transparent background (inherits card/page surface).
- Focus: `focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]` — orange ring at half opacity.
- Error: `aria-invalid:ring-destructive/20 aria-invalid:border-destructive`.
- Disabled: `disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50`.

**InputGroup with Addon**
- `InputGroup` wraps `Input` with an `InputGroupAddon` (icon or text prefix/suffix).
- Search bars always use `max-w-md` constraint on the wrapping element.

---

### Overlays on Images (Food Cards)

**Discount / Status Badge**
- `absolute top-2 left-2 bg-destructive text-white rounded-full text-xs font-semibold px-2 py-0.5`

**Category Badge** (semi-transparent)
- `absolute bottom-2 right-2 bg-background/90 backdrop-blur-sm rounded-full text-xs`

**Out-of-Stock Dimming**
- Full-card overlay: `absolute inset-0 bg-background/60 backdrop-blur-[2px] rounded-xl flex items-center justify-center`

**Image Hover Scale**
- On the image container: `overflow-hidden rounded-xl` with `transition-all duration-500 hover:scale-105` on the inner `<img>`.

---

### Navigation

**Active NavLink Pattern** (Settings tabs)
- Uses `buttonVariants` with dynamic variant: `isActive ? 'default' : 'outline'`
- Provides button-styled links that visually show the active route with primary fill vs. bordered outline.

**Sidebar Navigation**
- Uses `Sidebar` component with `SidebarMenu`, `SidebarMenuItem`, `SidebarMenuButton`.
- Active item: primary-colored indicator via `isActive` prop.

**Sticky Header**
- `sticky top-0 z-50 bg-background/90 backdrop-blur border-b` — blurred translucent header.

---

### Tables (Admin Pages)

Standard pattern:
1. `Table` → `TableHeader` → `TableRow` → `SortableTableHead` (column headers with sort trigger)
2. `TableBody` → `TableRow` → `TableCell`
3. Row actions: `DropdownMenu` containing `DropdownMenuItem` (edit) + destructive `DropdownMenuItem` (delete)
4. Delete action always triggers a `Dialog` with confirmation before calling the mutation.
5. `TablePagination` component placed below `Table`.
6. Empty state: `<ErrorState>` component centered in a full-height container.

---

### Dialogs & Confirmations

- `Dialog` → `DialogContent` → `DialogHeader` + `DialogFooter`
- Destructive confirm dialogs: footer has `Button variant="outline"` (cancel) + `Button variant="destructive"` (confirm).
- Non-destructive dialogs: footer has `Button variant="outline"` (cancel) + `Button variant="default"` (confirm).

---

### State Components

- **Loading**: `<Skeleton>` matching the shape of the final UI; use `animate-shimmer` class for pulsing effect on custom skeleton shapes.
- **Error / Empty**: `<ErrorState>` component centered in a flex container — includes icon, title, description.
- **Spinner**: `<Spinner>` for inline loading indicators within buttons or small containers.
- **Progress**: `<Progress>` for determinate loading bars.

## 5. Layout Principles

### Spacing System

Base unit: 4px (Tailwind's default scale — `space-1` = 4px). Common values:

| Token | Size | Typical Use |
|-------|------|-------------|
| `gap-1` | 4px | Tight icon-text groups |
| `gap-2` | 8px | Badge content, button icon gaps |
| `gap-3` | 12px | Form field vertical spacing |
| `gap-4` | 16px | Default section/card gap |
| `gap-6` | 24px | Card internal sections |
| `gap-8` | 32px | Page-level layout gaps |
| `py-6` | 24px | Card vertical padding |
| `px-6` | 24px | Card horizontal padding |
| `py-8` | 32px | Page container vertical padding |
| `px-4` | 16px | Page container horizontal padding (mobile-safe) |

### Container

Every page uses: `container mx-auto max-w-7xl px-4`

Max-width: 1280px. Centered. 16px horizontal padding (safe for mobile). This is non-negotiable — all page content lives inside this wrapper.

### Grid Patterns

**Food Listing Grid**
- `grid grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-4`
- Mobile: 2 columns. Tablet: 3 columns. Desktop wide: 4 columns.

**Content + Summary (Cart, Order)**
- `grid grid-cols-1 lg:grid-cols-3 gap-8`
- Mobile: stacked. Desktop: main content in left 2 cols (`lg:col-span-2`), sticky summary in right 1 col.

**Admin Table Page**
- Full-width within the container. No multi-column grid — table takes all available width.

**Settings**
- Vertical tabs nav (left or top depending on breakpoint) + content area side by side on desktop.

### Hero Section Pattern

Used on: Foods, Cart, Landing, Order Detail.

```
<div className="relative overflow-hidden bg-gradient-to-b from-primary/20 via-primary/5 to-background">
  {/* Decorative blob 1 */}
  <div className="absolute top-0 right-0 h-64 w-64 rounded-full bg-primary/20 blur-[80px]" />
  {/* Decorative blob 2 */}
  <div className="absolute bottom-0 left-0 h-48 w-48 rounded-full bg-primary/20 blur-[60px]" />
  
  <div className="container mx-auto max-w-7xl px-4 py-12">
    <Badge variant="secondary" className="gap-2 mb-4">
      <Icon className="h-4 w-4" /> Section Label
    </Badge>
    <h2 className="text-3xl font-black tracking-tight sm:text-4xl">Page Title</h2>
    <p className="text-sm text-muted-foreground sm:text-base">Subtitle text</p>
  </div>
</div>
```

### Responsive Sidebar → Sheet Pattern

Desktop: `<Sidebar>` component sticky on the left, content grid fills the rest.
Mobile: sidebar collapses. Trigger button (`Button variant="outline" size="sm"`) opens a `<Sheet side="left">` containing the same sidebar content.

### Whitespace Philosophy

- Card internal padding is consistent: `py-6 px-6` via CardContent and CardHeader.
- Page content padding: `py-8 px-4`.
- Sections within a page are separated by `gap-8` in grid/flex layouts — never ad-hoc margins.
- Sticky elements use `top-4` not `top-0` to give visual breathing room from the sticky header.

## 6. Depth & Elevation

| Level | Treatment | Use |
|-------|-----------|-----|
| Flat (0) | No shadow, no border | Page background |
| Bordered (1) | `border` (1px `--border`) | Standard cards, inputs, table rows |
| Elevated (2) | `border shadow-sm` | Standard `Card` components |
| Elevated High (3) | `border shadow-lg` | Modals, dialogs, drawer panels |
| Overlay (4) | `backdrop-blur-sm bg-background/90` | Semi-transparent image badges |
| Deep Overlay (5) | `backdrop-blur-[2px] bg-background/60` | Out-of-stock dimming on image cards |

**Shadow Philosophy**: Notism is border-first, not shadow-first. Most depth comes from the `border` token (`oklch(0.92 ...)`) creating clean separation between white surfaces. Shadows are sparse — `shadow-sm` on cards to just slightly lift them off the page; `shadow-lg` only for dialogs and sheets that float above all content.

### Motion & Animation

- `transition-all duration-300` — standard hover transitions for interactive elements (buttons, links).
- `transition-all duration-500` — image card scale on hover (`hover:scale-105`).
- `animate-shimmer` — skeleton loading state. Uses a sweeping gradient (`accent → white 20% opacity → accent`) over 2s infinite linear.
- `backdrop-blur` — applied to overlaid elements; not animated, purely visual.

### Focus System

All interactive elements share: `focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]`

The 3px ring at 50% opacity of the primary orange creates a highly visible but not aggressive focus indicator — WCAG AA compliant on white and dark backgrounds.

### Custom Scrollbar

Webkit-only. Track: `--muted`. Thumb: `--muted-foreground`. No scrollbar on Firefox (falls back to native). Applied globally via `scrollbar.css`.

## 7. Do's and Don'ts

### Do
- Use semantic token names for all colors — `text-primary`, `bg-destructive`, `text-muted-foreground`, never raw hex or oklch values.
- Use `rounded-md` for buttons and inputs (10px effective), `rounded-xl` for all Card components (16px), `rounded-full` for badges and circular elements only.
- Apply `tracking-tight` to all headings `text-2xl` and above.
- Use `font-black` for page-level titles (h1/h2 in heroes), `font-bold` for section headers, `font-semibold` for card titles, `font-medium` for labels.
- Maintain focus ring pattern: `focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]`.
- Use `disabled:pointer-events-none disabled:opacity-50` on all disabled interactive elements.
- Size icons at `h-4 w-4` (16px) by default. Use `h-5 w-5` in section headers. Button SVG icons auto-size via `[&_svg:not([class*='size-'])]:size-4`.
- Wrap all user-facing text in `useTranslation()` — `t('namespace.key')` — never hardcoded strings.
- Use `container mx-auto max-w-7xl px-4` on every page.
- Guard all destructive actions with a Dialog confirmation before firing the mutation.
- Always pair a hero gradient section with decorative blurred primary blobs.
- Use `animate-shimmer` for loading skeleton effects, not a generic `animate-pulse`.

### Don't
- Don't use raw hex colors, oklch values, or arbitrary pixel values in className strings — always token names.
- Don't use `rounded-full` on cards, buttons, or inputs — only badges and circular icon buttons (`icon` size).
- Don't use `font-black` below page-title context — it becomes visually overwhelming at card-title scale.
- Don't place `shadow-lg` on cards — that is reserved for dialogs and sheets. Cards use `shadow-sm`.
- Don't apply `backdrop-blur` without a matching semi-transparent background token (always pair with `bg-background/90` or similar).
- Don't invent new components — use existing shadcn/ui primitives. If something doesn't exist, flag it.
- Don't hardcode width/height in px — use Tailwind's scale or `size-*` utilities.
- Don't place destructive actions (delete buttons) without a Dialog confirmation step.
- Don't bypass `max-w-7xl` container — all content lives within it.
- Don't mix chart colors into UI chrome — chart tokens (`--chart-*`) are for data visualization only.
- Don't use `text-foreground` override when `text-muted-foreground` is semantically correct — secondary information must be visually subordinate.
- Don't use `success`, `warning`, or `info` semantic colors outside their intended contexts (status indicators, alerts, feedback messages).

## 8. Responsive Behavior

### Breakpoints

| Name | Width | Key Layout Changes |
|------|-------|-------------------|
| Mobile (default) | 0–639px | Single column, all sidebars in `Sheet` drawer, compact hero text |
| `sm` | 640px+ | Hero text scales up (`sm:text-4xl`, `sm:text-base` for subtitles) |
| `md` | 768px+ | Food grid expands to 3 columns, some nav adjustments |
| `lg` | 1024px+ | Sidebar becomes sticky inline panel; content + summary switch to side-by-side (`lg:grid-cols-3`); data table toolbars go horizontal |
| `xl` | 1280px+ | Food grid expands to 4 columns |

### Touch Targets

- Minimum button height: `h-8` (32px for `sm` size) — avoid `h-6` (`xs`) as the sole interactive target on touch screens.
- Card surfaces act as large touch targets for food items — the entire card area is tappable, not just the button.
- Navigation items in the sidebar use full-width `SidebarMenuButton` for easy thumb navigation.

### Collapsing Strategy

- **Sidebar → Sheet**: `Sidebar` (desktop sticky) hidden on mobile; trigger button appears that opens `<Sheet side="left">` with identical content.
- **Multi-column Grid → Single**: Food grid collapses `xl:grid-cols-4 → md:grid-cols-3 → grid-cols-2` (never single column for food cards).
- **Side-by-side → Stacked**: Cart/Order summary `lg:grid-cols-3` → `grid-cols-1` (summary stacks below main content on mobile).
- **Admin Toolbar**: Search + action button go `flex-col` on mobile, `flex-row` on `md+`.
- **Hero Typography**: `text-3xl → sm:text-4xl` (page title), `text-sm → sm:text-base` (subtitle).

### Dark Mode

Full dark mode via `.dark` class on `<html>`. All color tokens flip automatically — no component needs dark mode overrides except:
- `dark:bg-input/30` — input backgrounds become semi-transparent.
- `dark:bg-destructive/60` — destructive buttons desaturate slightly.
- `dark:hover:bg-input/50` — outline button hover in dark.
- `dark:aria-invalid:ring-destructive/40` — error ring opacity increases in dark.

## 9. Agent Prompt Guide

### Quick Token Reference

| Intent | Token | Tailwind Class |
|--------|-------|---------------|
| Brand action | Primary orange | `bg-primary`, `text-primary`, `border-primary` |
| Page background | White / near-black | `bg-background` |
| Card surface | White / dark card | `bg-card`, `text-card-foreground` |
| Neutral fill | Light gray | `bg-muted`, `bg-secondary` |
| Secondary text | Cool gray | `text-muted-foreground` |
| Borders | Light gray | `border-border` (or just `border`) |
| Focus ring | Orange at 50% | `ring-ring/50`, `border-ring` |
| Destructive | Red | `bg-destructive`, `text-destructive` |
| Success | Green | `text-success`, `bg-success/15` |
| Warning | Amber | `text-warning` |
| Info | Blue | `text-info` |

### Example Component Prompts

- **Hero Section**: "A gradient hero using `bg-gradient-to-b from-primary/20 via-primary/5 to-background` with two decorative `bg-primary/20 blur-[80px] rounded-full absolute` blobs. Inside: a `Badge variant='secondary'` with an icon, a `text-3xl font-black tracking-tight sm:text-4xl` heading in `text-foreground`, and a `text-sm text-muted-foreground sm:text-base` subtitle."

- **Food Card**: "A `rounded-xl border shadow-sm overflow-hidden` card with an aspect-square image container using `hover:scale-105 transition-all duration-500`. Absolute badge `top-2 left-2 bg-destructive text-white rounded-full text-xs font-semibold px-2 py-0.5` for discount. Category label `bottom-2 right-2 bg-background/90 backdrop-blur-sm rounded-full`. Card body: `text-sm font-semibold` title, `text-sm text-muted-foreground` description, `text-primary font-black` price, `Button variant='default' size='sm'`."

- **Admin Data Table Page**: "Page title `text-2xl font-bold` with `text-sm text-muted-foreground` subtitle. Toolbar: `InputGroup` search with `max-w-md` and `Button variant='default'` action. `Card` with `CardContent className='p-0'` wrapping a `Table` → `SortableTableHead` columns → `TableBody` rows → row `DropdownMenu` with edit + destructive delete guarded by `Dialog`. `TablePagination` below. Empty state: `<ErrorState>` centered."

- **Sticky Summary Card**: "In a `grid grid-cols-1 lg:grid-cols-3 gap-8` layout: main content in `lg:col-span-2`, summary in `<Card className='sticky top-4'>` using `CardHeader` (title + `CardAction` icon button) and `CardContent`. Price rows: `flex justify-between text-sm`, total row: `flex justify-between font-black text-xl`. `Button variant='default' size='lg' className='w-full'` CTA."

- **Status Badge in Table**: "`<Badge variant='success'>` for active, `<Badge variant='destructive'>` for suspended, `<Badge variant='secondary'>` for pending. Never use `<Badge variant='default'>` in table status cells — too visually heavy."

- **Confirmation Dialog**: "`<Dialog>` with `<DialogHeader>` containing title + description. `<DialogFooter>`: `Button variant='outline'` (Cancel) + `Button variant='destructive'` (Confirm Delete). The destructive button fires only after Dialog confirmation — never expose it directly."

### Iteration Tips

1. Always name tokens explicitly — "use `text-muted-foreground`" not "use gray text."
2. Specify component variants by exact name — "`Button variant='outline'`" not "a bordered button."
3. For badge status patterns, always use the semantic variant (`success`, `destructive`) — never `default` for status indicators.
4. When describing layout, specify the breakpoint where the switch happens — "single column on mobile, `lg:grid-cols-3` on desktop."
5. All heading-level text gets `tracking-tight`; do not omit this.
6. Shadcn/ui Card always uses `rounded-xl` — do not override to `rounded-lg` or `rounded-md` on Card components.
7. For loading states, use `<Skeleton>` matching the shape of the final content — not generic rectangular placeholders.
