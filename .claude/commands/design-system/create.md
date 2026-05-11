# Mode: Create

Generate `DESIGN.md` at the repo root. The goal is a single, agent-readable source of truth that downstream agents (designer, frontend) reference for consistent UI output.

## Step 1 — Check Existing File

Check the repo root for `DESIGN.md`. If it exists, use `AskUserQuestion` to ask whether to **Skip** (keep current) or **Regenerate** (overwrite). Default: Skip.

If the user chooses Skip, exit with: "`DESIGN.md` already exists — no changes made."

## Step 2 — Load Product Context

Read `PRODUCT.md` if it exists. Extract **Vision**, **Target Users**, and **Strategic Direction** — hold these in context for Steps 3 and 4. They inform the visual tone, audience-appropriate aesthetic, and design priorities.

## Step 3 — Detect Theme Tokens

Search the web codebase for existing design tokens. Use `Glob`, `Grep`, and `Read` to locate them. Common locations (framework-agnostic — adapt to whatever the codebase uses):

- **CSS variables**: any `*.css`, `*.scss`, `*.less` file containing `@theme`, `:root`, `.dark`, `--color-*`, `--radius`, `--font-*` declarations
- **Utility-first config**: `tailwind.config.*`, `unocss.config.*`, `windicss.config.*` — extract color, font, radius, spacing scales
- **Theme objects in code**: any file matching `theme.*`, `tokens.*`, `design-tokens.*`, `palette.*` exporting a token map (CSS-in-JS, styled-system, Chakra, MUI, etc.)
- **Design-system registries**: `components.json`, `theme.json`, or similar config files
- **Font loading**: HTML entry points and framework font imports (Google Fonts links, `next/font`, `expo-font`, `@font-face` rules)
- **Component primitives**: locate the project's primitives directory by reading its config (e.g. `components.json` `aliases`, framework conventions, or by globbing for `button.*`, `input.*`, `card.*`, `badge.*`). Observe default radius, height, padding to confirm detected tokens.

Convert OKLCH/HSL/RGB values to hex (SRGB) — the spec requires hex. Record: primary + accent palettes, surface/neutral, semantic (error and any others), font family + fallbacks, radius scale, spacing scale, default control height + radius, component variants and their state suffixes.

If NO tokens are found, fall back to `AskUserQuestion` for: brand name, primary hex color, font family, default radius, light/dark mode support.

## Step 4 — Design Direction Interview

Use `AskUserQuestion` with three questions in one call:

1. "Give a one-sentence brand voice description (tone, audience, what the product does). Skip to derive from product context."
2. "How should users feel when using this product? Describe the emotional atmosphere or mood (e.g. 'confident and efficient', 'calm and focused', 'playful and approachable')."
3. "Are there any products, apps, or interfaces whose visual style you admire or want to draw inspiration from? (Optional — skip to proceed without references.)"

After each answer, assess whether it is specific enough to inform visual decisions. If a response is vague or ambiguous — e.g. "nice" for mood, or "modern" for brand voice — ask a focused follow-up. Keep iterating until every answer is concrete and unambiguous. Only then proceed to Step 5.

Use the answers alongside the product context from Step 2 to shape the visual tone and prose in DESIGN.md. If the user skips question 1, derive the brand voice from the Vision and Target Users in PRODUCT.md.

## Step 5 — Write DESIGN.md

Author the file using the structure below. The linter in Step 6 enforces compliance.

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

- **Preserve detected token names.** Keep the token names exactly as found in the codebase.
- **Do not invent.** Components, palettes, and signature features must come from the token scan (Step 3). If something isn't in the project, it doesn't go in DESIGN.md.
- **Overview.** The Overview section must describe visual identity, color rationale, typographic approach, spatial atmosphere, and mode behaviour. Draw on the brand voice and emotional atmosphere from Step 4 and the strategic tone from `PRODUCT.md` to inform the writing, but keep the prose focused on how the UI looks and feels.

## Step 6 — Validate

Run the official linter against the written file:

```bash
npx -y @google/design.md lint DESIGN.md
```

If the linter reports errors (broken token refs, invalid colors, schema violations, duplicate sections), fix and re-run until clean before proceeding.
