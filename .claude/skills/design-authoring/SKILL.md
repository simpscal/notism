---
name: design-authoring
description: >
  Canonical authoring path for the project's `DESIGN.md` design-system file.
  Owns the contract (file structure, frontmatter, sections, tokens, apply rules,
  linter) and the two end-to-end workflows that produce it (Create and Amend).
  Apply when the user wants to create, set up, write, generate, regenerate,
  redesign, overhaul, rewrite, amend, update, edit, or change `DESIGN.md` —
  including its tokens (colors, typography, rounded, spacing, components) or
  any of its markdown sections.
tools: Read, Edit, Write, Glob, Grep, Bash, AskUserQuestion, WebSearch, WebFetch
---

# DESIGN.md Authoring

Single source of truth for authoring the DESIGN.md file. Two workflows (Create, Amend) produce or modify the file; the rest of this skill defines the contract those workflows must satisfy (structure, tokens, constraints, output shape, apply rules, linter).

## Workflows

- **Create** — write a new DESIGN.md from scratch via interview + token source (codebase scan, user-described, or clone-from-app).
- **Amend** — targeted edit to an existing DESIGN.md driven by a single change request.

## Mode Detection

Decide the branch before doing anything else:

| DESIGN.md present? | Intent verb in the request                              | Branch                                  |
|--------------------|---------------------------------------------------------|-----------------------------------------|
| no                 | create / set up / generate / init                       | Workflow: Create                        |
| yes                | create / generate / regenerate                          | Ask Skip / Regenerate (default: Skip)   |
| yes                | redesign / overhaul / rewrite                           | Workflow: Create — overwrite in place   |
| yes                | amend / update / change / edit / add / remove / rename  | Workflow: Amend                         |

If the conversation has already supplied a redesign brief (goals + scope) and the file exists, treat it as redesign intent.

---

## Workflow: Create

Goal: write `DESIGN.md` at the repo root as the single, agent-readable source of truth that downstream agents (designer, frontend) reference for consistent UI output.

### Step 1 — Existence check

Check the repo root for `DESIGN.md`. If it exists, use `AskUserQuestion` to ask whether to **Skip** (keep current) or **Regenerate** (overwrite). Default: Skip.

If the user chooses Skip, exit with: `` `DESIGN.md` already exists — no changes made. ``

### Step 2 — Load product context

Read `PRODUCT.md` if it exists. Extract **Vision**, **Target Users**, and **Strategic Direction** — hold these in context for Steps 3 and 5. They inform the visual tone, audience-appropriate aesthetic, and design priorities.

If invoked from a redesign flow that already captured `$GOALS` and `$SCOPE` in the conversation, also fold those into context here.

### Step 3 — Design direction interview

Use `AskUserQuestion` with three questions in one call:

1. "Give a one-sentence brand voice description (tone, audience, what the product does). Skip to derive from product context."
2. "How should users feel when using this product? Describe the emotional atmosphere or mood (e.g. 'confident and efficient', 'calm and focused', 'playful and approachable')."
3. "Are there any products, apps, or interfaces whose visual style you admire or want to draw inspiration from? (Optional — skip to proceed without references.)"

After each answer, assess whether it is specific enough to inform visual decisions. If a response is vague or ambiguous — e.g. "nice" for mood, "modern" for brand voice — ask a focused follow-up. Keep iterating until every answer is concrete and unambiguous. Only then proceed to Step 4.

Use the answers alongside the product context from Step 2 to shape the visual tone and prose. If the user skips question 1, derive the brand voice from the Vision and Target Users in PRODUCT.md.

### Step 4 — Theme source selection

Use `AskUserQuestion` with a single question:

> "How should we source the visual theme for this design system?"

Options:

- **Use existing codebase tokens** — scan the repo for CSS variables, Tailwind config, theme objects, etc.
- **I'll describe the theme** — skip scanning; provide hex colors, font, radius, and spacing verbally.
- **Clone from an existing app** — name an app or URL; the agent infers its visual signature.

Whichever source is used, the resulting token set must align with the Design Direction captured in Step 3. If a conflict is detected (e.g. playful direction + corporate grey palette), flag it and ask the user to resolve before continuing.

### Step 5 — Detect / collect theme tokens

Run the sub-path that matches the user's choice in Step 4.

#### 5A — Codebase scan

Search the web codebase for existing design tokens. Use `Glob`, `Grep`, and `Read` to locate them. Common locations (framework-agnostic — adapt to whatever the codebase uses):

- **CSS variables**: any `*.css`, `*.scss`, `*.less` file containing `@theme`, `:root`, `.dark`, `--color-*`, `--radius`, `--font-*` declarations.
- **Utility-first config**: `tailwind.config.*`, `unocss.config.*`, `windicss.config.*` — extract color, font, radius, spacing scales.
- **Theme objects in code**: any file matching `theme.*`, `tokens.*`, `design-tokens.*`, `palette.*` exporting a token map (CSS-in-JS, styled-system, Chakra, MUI, etc.).
- **Design-system registries**: `components.json`, `theme.json`, or similar config files.
- **Font loading**: HTML entry points and framework font imports (Google Fonts links, `next/font`, `expo-font`, `@font-face` rules).
- **Component primitives**: locate the project's primitives directory by reading its config (e.g. `components.json` `aliases`, framework conventions, or by globbing for `button.*`, `input.*`, `card.*`, `badge.*`). Observe default radius, height, padding to confirm detected tokens.

Convert OKLCH / HSL / RGB values to hex (sRGB) — the spec requires hex. Record: primary + accent palettes, surface / neutral, semantic (error and any others), font family + fallbacks, radius scale, spacing scale, default control height + radius, component variants and their state suffixes.

If NO tokens are found, fall back to `AskUserQuestion` for: brand name, primary hex color, font family, default radius, light / dark mode support.

**Preserve detected token names exactly as found in the codebase.**

#### 5B — User describes

Run a short brainstorm to surface the desired visual outcome before collecting any token values. The goal is to understand what the user is trying to achieve — not to collect specs up front.

**Phase 1 — Explore visual specifics.** The brand voice and emotional feel were captured in Step 3 — do not re-ask those. Use the Step 3 answers as a foundation and brainstorm through all remaining visual dimensions. Run three rounds of `AskUserQuestion`, assessing specificity after each. If any answer is vague, probe with a concrete follow-up before moving to the next round.

**Round 1 — Color and Mode** (4 questions):

1. "Is there a colour family you're drawn to — or one to avoid? Any specific hue, temperature (warm/cool), or saturation level?"
2. "How should surfaces and backgrounds feel — crisp bright white, warm off-white, a deep dark, or something with a hint of colour?"
3. "For semantic signals (errors, success, warnings) — do standard traffic-light colours (red/green/amber) feel right, or do you want something more on-brand?"
4. "Light mode only, dark mode only, or both?"

**Round 2 — Typography and Layout** (4 questions):

1. "How should the typeface feel — neutral and functional (e.g. Inter, DM Sans), editorial and expressive (e.g. Playfair, Fraunces), humanist and warm (e.g. Nunito, Lato), or geometric/technical (e.g. Space Grotesk, IBM Plex)?"
2. "Weight preference: light and airy, regular and balanced, or heavy and assertive?"
3. "How dense should the UI feel — generous whitespace and room to breathe, compact and information-rich, or balanced?"
4. "Layout width: constrained and centred (max-width container), full-bleed edge-to-edge, or a sidebar-plus-content model?"

**Round 3 — Shapes, Elevation, and Components** (4 questions):

1. "Corner radius: sharp and square (0–2px), slightly rounded (4–8px), generously rounded (12–16px), or pill-shaped buttons and full rounding?"
2. "Elevation and depth: flat with no shadows, soft and subtle layering, or pronounced shadows with clear stacking hierarchy?"
3. "Borders: borderless surfaces, hairline/subtle borders, or defined structural borders?"
4. "Component style direction: minimal and stripped-back, structured with clear affordances, or expressive and branded?"

After all three rounds are complete and all answers are concrete, proceed to Phase 2.

**Phase 2 — Synthesise and propose.** Based on the brainstorm and the Design Direction from Step 3, derive a candidate token set and present it back to the user in plain language before committing to it. Example:

> "Based on what you've described, I'm thinking: a deep navy primary (`#1B2A4A`), warm white surface (`#FAF9F7`), Inter typeface at medium weight, rounded corners (sm: 4px, md: 8px, lg: 16px), and light mode only. Does this match your vision, or would you like to adjust anything?"

Iterate on the proposal until the user confirms. Only then move to Phase 3.

**Phase 3 — Fill gaps.** Use `AskUserQuestion` to collect any token values not yet resolved:

- Exact hex for primary, accent, surface / neutral if not confirmed above.
- Font family and weights.
- Spacing base unit.
- Light / dark mode support (yes / no / both).

Derive the final token set from the confirmed values. Token names are invented (no codebase source), so use generic names: `primary`, `accent`, `surface`, `neutral`, `foreground`, etc.

#### 5C — Clone from existing app

Ask the user via `AskUserQuestion`:

1. App name or URL to reference.
2. Which aspects to replicate: color, typography, shape, or all.

Use `WebSearch` / `WebFetch` to research the app's public design language if a URL is given. Otherwise rely on known brand signatures (e.g. Notion's off-white, Linear's indigo, Vercel's monochrome). Construct a token set that matches the reference's visual character.

Note in the DESIGN.md Overview that the theme is inspired by [app name].

### Step 6 — Write and validate

Author `DESIGN.md` using the tokens and prose gathered in Steps 1–5, following the contract sections below (File Structure, YAML Frontmatter Spec, Markdown Body Sections, Token Group Coverage, Constraints, Apply Rules).

Sourcing-specific guardrails:

- **Preserve detected token names.** Keep token names exactly as found in the codebase (5A only). Do not rename to match spec recommendations.
- **Do not invent.** Components, palettes, and signature features must come from Step 5. If something isn't sourced, it doesn't go in DESIGN.md.
- **Overview prose.** Draw on the brand voice and emotional atmosphere from Step 3 and the strategic tone from `PRODUCT.md`. Keep the prose focused on how the UI looks and feels.

Validate the written file with the linter (see `## Linter` below), fix every error, and re-run until clean.

---

## Workflow: Amend

Goal: apply a targeted change to an existing `DESIGN.md` without touching anything else.

### Step 1 — File-exists guard

Check the repo root for `DESIGN.md`. If absent, branch to Workflow: Create instead.

### Step 2 — Load current state

Read `DESIGN.md` in full. Capture:

- Every color token name and hex value.
- Every typography scale name and its properties.
- Every rounded, spacing, and component token.
- The prose in every markdown section.

Hold this as the **baseline**. Do not proceed until the full file is loaded.

### Step 3 — Open amendment dialog

Ask a single `AskUserQuestion`:

> What do you want to change? Describe the addition, update, or removal — for tokens, components, or prose sections.

Hold the response as **$CHANGE_INPUT**.

If $CHANGE_INPUT is ambiguous (e.g. "update the colors" with no specifics), ask one follow-up to clarify the exact target and direction before proceeding.

### Step 4 — Apply changes and validate

Apply $CHANGE_INPUT to `DESIGN.md` as a targeted edit, following the contract's Apply Rules (`## Apply Rules` below), specifically the *Targeted edits* clause.

Amend-specific rules:

- Edit only the entries and prose sections affected by $CHANGE_INPUT. Every untouched token and section must come through verbatim.
- New tokens go in the correct YAML group; add a matching entry in the relevant prose section.
- Removed tokens disappear from frontmatter **and** from every component or prose reference — no dangling `{colors.*}` / `{typography.*}` / `{rounded.*}` / `{spacing.*}`.
- Do not invent. New tokens or components must come from the codebase or be explicitly provided by the user.
- Preserve existing token names. Do not rename to match spec recommendations.

Validate the edited file with the linter, fix every error, and re-run until clean.

### Step 5 — Report

Show a concise summary of what changed:

```
Tokens: Added <N> · Updated <N> · Removed <N>
Components: Added <N> · Updated <N> · Removed <N>
Sections updated: <list>
Linter: <N> errors · <N> warnings
```

---

# Contract

The sections below define the contract every Create / Amend run must satisfy.

## File Structure

Two parts, in this order:

1. **YAML frontmatter** at top — machine-readable tokens.
2. **Markdown body** below — human-readable rationale and detail tables.

Section order in the markdown body is immutable.

## YAML Frontmatter Spec

```yaml
---
version: <string — bumped on every change, e.g. alpha → beta>
name: <project name — preserve across edits>

colors:
  <token-name>: "#hexvalue"        # hex sRGB only — no oklch, hsl, rgb()
  # light-mode values only; dark values live in the markdown body

typography:
  <scale-token>:                   # xs, sm, base, lg, xl, 2xl, 3xl
    fontFamily: <string>
    fontSize: <dimension>          # px, em, or rem
    fontWeight: <number>
    lineHeight: <dimension or unitless number>
    letterSpacing: <dimension>     # optional
    fontFeature: <string>          # optional
    fontVariation: <string>        # optional

rounded:
  <scale-level>: <dimension>       # sm, md, lg, xl, full

spacing:
  <numeric-key>: <dimension>       # 1, 2, 3, 4, 6, 8, 12, 16

components:
  <component-name>:                # button, input, card, badge by default
    backgroundColor: "{colors.<token>}"
    textColor: "{colors.<token>}"
    typography: "{typography.<token>}"
    rounded: "{rounded.<token>}"
    padding: <dimension>
    height: <dimension>            # omit for card (content-sized)
    width: <dimension>
    size: <dimension>
---
```

Token reference syntax: `{section.token-name}` (e.g. `{colors.primary}`, `{rounded.md}`). YAML `components` carry **scalar defaults only** — variants, sizes, and states matrices live in the markdown body.

## Markdown Body Sections

Eight canonical sections in this order. Each lists its required child sub-sections. Duplicate section headings are rejected by the linter.

### 1. Overview
Flat prose. **No `###` headings.** Use bold inline labels in this order:
- Opening brand-personality paragraph (no label)
- `**Visual identity:**`
- `**Color rationale:**`
- `**Typographic approach:**`
- `**Spatial atmosphere:**`
- `**Mode behaviour:**`

### 2. Colors
`###` sub-sections, each a token table with columns `Token | Light | Dark | Usage` (Charts table uses `Token | Value | Usage` — single-value, no dark column):
- **Primary Palette** — `primary`, `primary-foreground`
- **Surfaces** — `background`, `foreground`, `card`, `card-foreground`, `popover`, `popover-foreground`, `sidebar`, `sidebar-foreground`, `sidebar-primary`, `sidebar-primary-foreground`, `sidebar-accent`, `sidebar-accent-foreground`, `sidebar-border`, `sidebar-ring`
- **Neutral / Secondary** — `secondary` + foreground, `muted` + foreground, `accent` + foreground
- **Borders and Inputs** — `border`, `input`, `ring`
- **Semantic** — `destructive`, `success`, `warning`, `info`
- **Charts** — `chart-1`..`chart-5` (omit section if no chart tokens)

### 3. Typography
- **Font Family** — typeface name, weights loaded, fallback stack
- **Scale** — table with columns `Token | Size | Weight | Line Height | Usage` (typically 6–15 levels)

### 4. Layout
- **Grid Model** — column count per breakpoint (mobile / tablet / desktop)
- **Spacing Strategy** — base unit (4px / 0.25rem) rationale + preferred tokens per use
- **Responsive Breakpoints** — table with columns `Breakpoint | Min-width | Typical use` (`sm`, `md`, `lg`, `xl`)
- **Overflow** — scroll strategy for `html`, `body`, and child scroll containers

### 5. Elevation and Depth
- **Shadows** — shadow values per elevation tier (cards, popovers)
- **Borders** — border-as-depth-signal vs shadow-as-elevation policy
- **Overlays** — backdrop colour + opacity for modals/dialogs (e.g. `rgba(0,0,0,0.5)`)

### 6. Shapes
- **Radius Scale** — table with columns `Token | Value | Used on`
- **Shape Language** — rationale for radius choices; reference visual style

### 7. Components
One `###` sub-section per component (default inventory: Button, Input, Card, Badge). Each contains:
- `####` **Variants** — matrix with variant rows × `Background | Text | Hover | Border` columns
- `####` **Sizes** — table with `Size | Height | Padding | Text size` (omit if component has no size variants; Card has none)
- `####` **States** — `disabled`, focus visible, invalid, hover behaviour
- Component-specific specs: Card has `CardTitle`/`CardDescription` typography rules; Badge has pill-shape rule

### 8. Do's and Don'ts
- **Do** — at least 6 affirmative bullets derived from tokens, components, and atmosphere
- **Don't** — at least 6 prohibitions derived from tokens, components, and accessibility constraints

## Token Group Coverage

Every token must have a concrete value (hex, rem, px) — never abstract description.

| Group | YAML | Markdown | Notes |
|---|---|---|---|
| Colors (non-chart) | light value | dark value + usage | Both required unless inputs explicitly exclude dark mode |
| Colors (chart-*) | single value | single value + usage | No dark override |
| Typography | per-scale-token block | scale table + usage strings | `xs`..`3xl`; `fontFamily` repeated per token |
| Spacing | numeric keys | base-unit rationale | Keys: `1, 2, 3, 4, 6, 8, 12, 16` |
| Rounded | flat map | radius scale table | `sm, md, lg, xl, full` |
| Layout | — | grid + breakpoints + overflow | **No YAML keys for layout** |
| Elevation | — | shadows + borders + overlay | **No YAML keys for elevation** |
| Components | scalar defaults | variants + sizes + states matrices | `{token.ref}` syntax in YAML; raw values forbidden |
| Do's / Don'ts | — | bullets | **No YAML keys** |

## Constraints

- Hex sRGB only in YAML `colors`. No `oklch()`, `hsl()`, `rgb()`. Convert at the source.
- Components in YAML carry scalar defaults using `{token.ref}` syntax — **never raw values**. Variants/sizes/states matrices belong in the markdown body only.
- Breakpoints, shadow tokens, overlay color, and base spacing unit live in the markdown body **only** — never as YAML keys.
- Light AND dark values for every non-chart color token. Charts are single-value.
- WCAG AA contrast required on every foreground/background pairing. Halt and surface the conflict if a derived pairing fails.
- Preserve detected token names exactly as found in the source codebase. Do not rename to match spec recommendations.
- Do not invent tokens, components, or signature features that the inputs did not request.
- Maintain the canonical component inventory (Button, Input, Card, Badge) unless the inputs explicitly add or remove a component.
- Never leave dangling `{colors.*}`, `{typography.*}`, `{rounded.*}`, or `{spacing.*}` references after a token is removed.

## $NEW_DS Output Shape

Two-layer object produced by any flow that derives tokens before applying them. The Apply Rules below consume this shape.

```yaml
yaml:
  version: <bumped>
  name: <project name>
  colors:
    background: "#..."
    foreground: "#..."
    # ...all tokens; light-mode values only
  typography:
    xs: { fontFamily, fontSize, fontWeight, lineHeight }
    # ...through 3xl
  rounded: { sm, md, lg, xl, full }
  spacing: { 1, 2, 3, 4, 6, 8, 12, 16 }
  components:
    button:
      backgroundColor: "{colors.primary}"
      textColor: "{colors.primary-foreground}"
      typography: "{typography.sm}"
      rounded: "{rounded.md}"
      height: 2.25rem
      padding: 0.5rem 1rem
    input: { ... }
    card: { ... }       # no height key
    badge: { ... }

markdown:
  overview:
    visual_identity: "<paragraph>"
    color_rationale: "<paragraph>"
    typographic_approach: "<paragraph>"
    spatial_atmosphere: "<paragraph>"
    mode_behaviour: "<paragraph>"
  colors_dark:
    background: "#0a0a0a"
    foreground: "#fafafa"
    # ...same token list as yaml.colors minus chart-*, dark-mode values
  colors_usage:
    background: "Page/app background"
    # ...usage string per token
  typography_usage:
    xs: "Badge labels, fine print, timestamps"
    # ...usage per scale token
  layout:
    grid_model: "<paragraph>"
    spacing_strategy: "<paragraph including base unit (4px) rationale>"
    breakpoints:
      sm: { minWidth: "640px", typicalUse: "Wider cards, 2-col layouts" }
      md: { ... }
      lg: { ... }
      xl: { ... }
    overflow: "<paragraph>"
  elevation:
    shadows:
      sm: "0 1px 2px rgba(0,0,0,0.05)"
      # ...any extra shadow tokens
    borders_policy: "<paragraph>"
    overlay: "rgba(0,0,0,0.5)"
  shapes:
    radius_usage:
      sm: "Small utility elements"
      md: "Buttons, inputs, small chips"
      lg: "Default container radius"
      xl: "Cards, large panels"
      full: "Badges (pill shape), avatar circles"
    shape_language: "<paragraph>"
  components_detail:
    button:
      variants:
        default:    { background, text, hover }
        destructive:{ background, text, hover }
        outline:    { background, text, hover }
        secondary:  { background, text, hover }
        ghost:      { background, text, hover }
        link:       { background, text, hover }
      sizes:
        xs:      { height, paddingX, text }
        sm:      { height, paddingX, text }
        default: { height, paddingX, text }
        lg:      { height, paddingX, text }
        icon:    { size }
      states:
        disabled: "opacity-50, pointer-events-none"
        focus:    "border-ring + ring-[3px] ring-ring/50"
        invalid:  "border-destructive, ring-destructive/20"
    input:
      sizing:      { height, paddingX, radius }
      border:      "border-input + bg-transparent (light) / bg-input/30 (dark)"
      placeholder: "muted-foreground"
      states:      { focus, error, disabled }
    card:
      sizing: { padding, radius, shadow, gap }
      slots:  "header, content, footer, action — typography rules per slot"
    badge:
      variants: { default, secondary, destructive, outline, success }
      sizing:   { padding, radius, font }
  dos:
    - "<bullet>"
    # ...at least 6
  donts:
    - "<bullet>"
    # ...at least 6
```

## Apply Rules

When writing or rewriting DESIGN.md:

- **Bump `version`** in the frontmatter on every change (e.g. `alpha` → `beta`, or increment numeric version).
- **YAML frontmatter** — replace from `$NEW_DS.yaml` exactly: flat `colors` (light only), per-token `typography` block, flat `rounded`, flat `spacing` (numeric keys), `components` scalar defaults with `{token.ref}` syntax.
- **Markdown body** — rewrite from `$NEW_DS.markdown`:
  - `## Overview` — replace paragraphs from `markdown.overview`.
  - `## Colors` — rewrite each group table; pull light values from `yaml.colors`, dark values from `markdown.colors_dark`, usage from `markdown.colors_usage`. Charts table is single-value (no dark column).
  - `## Typography` — rewrite Scale table from `yaml.typography` + usage strings from `markdown.typography_usage`.
  - `## Layout` — rewrite sub-sections from `markdown.layout`.
  - `## Elevation and Depth` — rewrite sub-sections from `markdown.elevation`.
  - `## Shapes` — rewrite sub-sections from `markdown.shapes`.
  - `## Components` — rewrite per-component blocks (variants matrix, sizes table, states) from `markdown.components_detail`.
  - `## Do's and Don'ts` — rewrite from `markdown.dos` and `markdown.donts`.
- **Preserve markdown body section ordering and headings.** Only the contents change.
- **Preserve user-added sections.** If `DESIGN.md` contains sections beyond the canonical set above, leave them unchanged at the bottom of the file unless `$NEW_DS` directly affects them.
- **Targeted edits** — when the change is scoped to specific tokens/sections (not a full rewrite), edit only those entries and preserve all other tokens/sections verbatim; remove dangling `{token.ref}` if a referenced token is removed.

## Linter

After writing or editing DESIGN.md, run the official linter:

```bash
npx -y @google/design.md lint DESIGN.md
```

Fix every **error** (broken token refs, invalid hex, schema violations, duplicate sections) and re-run until the error count is zero. Warnings do not block.
