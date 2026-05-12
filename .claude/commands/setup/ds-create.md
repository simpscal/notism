
Generate `DESIGN.md` at the repo root. The goal is a single, agent-readable source of truth that downstream agents (designer, frontend) reference for consistent UI output.

## Step 1 — Check Existing File
Check the repo root for `DESIGN.md`. If it exists, use `AskUserQuestion` to ask whether to **Skip** (keep current) or **Regenerate** (overwrite). Default: Skip.

If the user chooses Skip, exit with: "`DESIGN.md` already exists — no changes made."

## Step 2 — Load Product Context

Read `PRODUCT.md` if it exists. Extract **Vision**, **Target Users**, and **Strategic Direction** — hold these in context for Steps 3 and 5. They inform the visual tone, audience-appropriate aesthetic, and design priorities.

## Step 3 — Design Direction Interview

Use `AskUserQuestion` with three questions in one call:

1. "Give a one-sentence brand voice description (tone, audience, what the product does). Skip to derive from product context."
2. "How should users feel when using this product? Describe the emotional atmosphere or mood (e.g. 'confident and efficient', 'calm and focused', 'playful and approachable')."
3. "Are there any products, apps, or interfaces whose visual style you admire or want to draw inspiration from? (Optional — skip to proceed without references.)"

After each answer, assess whether it is specific enough to inform visual decisions. If a response is vague or ambiguous — e.g. "nice" for mood, or "modern" for brand voice — ask a focused follow-up. Keep iterating until every answer is concrete and unambiguous. Only then proceed to Step 4.

Use the answers alongside the product context from Step 2 to shape the visual tone and prose in DESIGN.md. If the user skips question 1, derive the brand voice from the Vision and Target Users in PRODUCT.md.

## Step 4 — Theme Source Selection

Use `AskUserQuestion` with a single question:

> "How should we source the visual theme for this design system?"

Options:
- **Use existing codebase tokens** — scan the repo for CSS variables, Tailwind config, theme objects, etc.
- **I'll describe the theme** — skip scanning; provide hex colors, font, radius, and spacing verbally.
- **Clone from an existing app** — name an app or URL; the agent infers its visual signature.

The chosen path feeds into Step 5. Whichever source is used, the resulting token set must align with the Design Direction captured in Step 3. If a conflict is detected (e.g. playful direction + corporate grey palette), flag it and ask the user to resolve before continuing.

## Step 5 — Detect / Collect Theme Tokens

Run the sub-path that matches the user's choice in Step 4.

### 5A — Codebase Scan

Search the web codebase for existing design tokens. Use `Glob`, `Grep`, and `Read` to locate them. Common locations (framework-agnostic — adapt to whatever the codebase uses):

- **CSS variables**: any `*.css`, `*.scss`, `*.less` file containing `@theme`, `:root`, `.dark`, `--color-*`, `--radius`, `--font-*` declarations
- **Utility-first config**: `tailwind.config.*`, `unocss.config.*`, `windicss.config.*` — extract color, font, radius, spacing scales
- **Theme objects in code**: any file matching `theme.*`, `tokens.*`, `design-tokens.*`, `palette.*` exporting a token map (CSS-in-JS, styled-system, Chakra, MUI, etc.)
- **Design-system registries**: `components.json`, `theme.json`, or similar config files
- **Font loading**: HTML entry points and framework font imports (Google Fonts links, `next/font`, `expo-font`, `@font-face` rules)
- **Component primitives**: locate the project's primitives directory by reading its config (e.g. `components.json` `aliases`, framework conventions, or by globbing for `button.*`, `input.*`, `card.*`, `badge.*`). Observe default radius, height, padding to confirm detected tokens.

Convert OKLCH/HSL/RGB values to hex (SRGB) — the spec requires hex. Record: primary + accent palettes, surface/neutral, semantic (error and any others), font family + fallbacks, radius scale, spacing scale, default control height + radius, component variants and their state suffixes.

If NO tokens are found, fall back to `AskUserQuestion` for: brand name, primary hex color, font family, default radius, light/dark mode support.

**Preserve detected token names exactly as found in the codebase.**

### 5B — User Describes

Run a short brainstorm to surface the desired visual outcome before collecting any token values. The goal is to understand what the user is trying to achieve — not to collect specs up front.

**Phase 1 — Explore visual specifics.** The brand voice and emotional feel were captured in Step 3 — do not re-ask those. Use the Step 3 answers as a foundation and brainstorm through all remaining visual dimensions that map to DESIGN.md sections. Run three rounds of `AskUserQuestion`, assessing specificity after each. If any answer is vague, probe with a concrete follow-up before moving to the next round.

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

- Exact hex for primary, accent, surface / neutral if not confirmed above
- Font family and weights
- Spacing base unit
- Light / dark mode support (yes / no / both)

Derive the final token set from the confirmed values. Token names are invented (no codebase source), so use generic names: `primary`, `accent`, `surface`, `neutral`, `foreground`, etc.

### 5C — Clone from Existing App

Ask the user via `AskUserQuestion`:

1. App name or URL to reference
2. Which aspects to replicate: color, typography, shape, or all

Use `WebSearch` / `WebFetch` to research the app's public design language if a URL is given. Otherwise rely on known brand signatures (e.g. Notion's off-white, Linear's indigo, Vercel's monochrome). Construct a token set that matches the reference's visual character.

Note in the DESIGN.md Overview that the theme is inspired by [app name].

## Step 6 — Write DESIGN.md

Author the file using the structure below. The linter in Step 7 enforces compliance.

### File Structure

The file has two parts: YAML frontmatter (machine-readable tokens) and a markdown body (human-readable rationale).

#### YAML Frontmatter

```yaml
---
version: alpha
name: <string>

colors:
  <token-name>: "#hexvalue"        # hex sRGB only — no oklch, hsl, or rgb()

typography:
  <token-name>:
    fontFamily: <string>
    fontSize: <dimension>          # px, em, or rem
    fontWeight: <number>
    lineHeight: <dimension or unitless number>
    letterSpacing: <dimension>     # optional
    fontFeature: <string>          # optional
    fontVariation: <string>        # optional

rounded:
  <scale-level>: <dimension>

spacing:
  <scale-level>: <dimension or number>

components:
  <component-name>:
    backgroundColor: <"#hex" or "{colors.token}">
    textColor: <"#hex" or "{colors.token}">
    typography: <"{typography.token}">
    rounded: <"{rounded.token}">
    padding: <dimension>
    height: <dimension>
    width: <dimension>
    size: <dimension>
---
```

Token references use `{section.token-name}` syntax (e.g. `{colors.primary}`, `{rounded.md}`).

#### Markdown Body Sections (in this order)

Each section below lists its required `###` child sub-sections. **Exception: Overview uses flat prose with bold inline labels — no `###` headings.**

1. **Overview** — flat prose only; no `###` sub-sections. Cover these topics using bold inline labels in this order: opening brand-personality paragraph (no label), then **Visual identity:**, **Color rationale:**, **Typographic approach:**, **Spatial atmosphere:**, **Mode behaviour:**.

2. **Colors** — `###` child sections:
   - **Primary Palette** — primary and primary-foreground tokens, light and dark values, usage rule
   - **Surfaces** — background, foreground, card, popover, sidebar surface tokens
   - **Neutral / Secondary** — secondary, muted, accent groups
   - **Borders and Inputs** — border, input, ring tokens
   - **Semantic** — destructive, success, warning, info tokens
   - **Charts** — chart-1 through chart-N tokens (omit if no chart tokens exist)

3. **Typography** — `###` child sections:
   - **Font Family** — typeface name, weights loaded, fallback stack
   - **Scale** — table with columns: Token, Size, Weight, Line Height, Usage; typically 6–15 levels

4. **Layout** — `###` child sections:
   - **Grid Model** — column count per breakpoint
   - **Spacing Strategy** — base unit and preferred tokens per use
   - **Responsive Breakpoints** — table with breakpoint name, min-width, typical use
   - **Overflow** — scroll strategy for html/body and child containers

5. **Elevation and Depth** — `###` child sections:
   - **Shadows** — shadow values per elevation tier (cards, popovers)
   - **Borders** — when and how to use border tokens for depth
   - **Overlays** — backdrop colour and opacity for modals/dialogs

6. **Shapes** — `###` child sections:
   - **Radius Scale** — table with Token, Value, Used on
   - **Shape Language** — rationale for the radius choices; reference visual style

7. **Components** — one `###` child section per detected component. Each component section must include:
   - `####` **Variants** — variant names, background/text/border per variant
   - `####` **Sizes** — size tokens, height, padding, text size (omit if component has no size variants)
   - `####` **States** — disabled, focus, error/invalid behaviour

8. **Do's and Don'ts** — `###` child sections:
   - **Do** — bullet list of affirmative rules derived from tokens and components
   - **Don't** — bullet list of prohibitions derived from tokens and components

Duplicate section headings are rejected by the linter.

### Guardrails

- **Preserve detected token names.** Keep the token names exactly as found in the codebase (5A only).
- **Do not invent.** Components, palettes, and signature features must come from the token collection step. If something isn't sourced, it doesn't go in DESIGN.md.
- **Overview.** The Overview section must describe visual identity, color rationale, typographic approach, spatial atmosphere, and mode behaviour. Draw on the brand voice and emotional atmosphere from Step 3 and the strategic tone from `PRODUCT.md` to inform the writing, but keep the prose focused on how the UI looks and feels.

## Step 7 — Validate

Run the official linter against the written file:

```bash
npx -y @google/design.md lint DESIGN.md
```

If the linter reports errors (broken token refs, invalid colors, schema violations, duplicate sections), fix and re-run until clean before proceeding.
