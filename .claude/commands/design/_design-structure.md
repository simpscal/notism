# Design Instructions Structure

Produce one unified set of design instructions for the sprint as a whole. Do not break instructions down per story — design the feature holistically across all affected UI surfaces.

## Sections

### Overview
- Sprint UI goal in one sentence
- List of pages or surfaces affected (new or modified)
- Reference pages: "Follow the pattern of `<path>`" — cite closest existing implementations

### Layout
- Full-feature page structure and component layout (grid, flexbox arrangement, nesting)
- Overall flow, spacing, and navigation between affected surfaces
- ASCII wireframe(s) — one per meaningful surface or state variant

### Components
| Element | Component name | Variant | Size | Notes |
|---------|---------------|---------|------|-------|

- Use exact component names from the inventory
- Use exact variant names from CVA definitions
- Do not invent components — if sprint needs something not in inventory, flag it

### Design Tokens
| Usage | Token name | Notes |
|-------|------------|-------|

- Use exact token names from the design system
- Never prescribe raw values (no `#ffffff`, `16px`, etc.)
- Include color, spacing, typography, shadows

### UI States
| Surface | State | Implementation |
|---------|-------|----------------|

- Cover every state for each affected surface: Loading, Error, Empty, Success
- Use existing state patterns from reference pages
- Specify what user sees and any interaction available in each state

### Responsive Behavior
- Layout changes at different breakpoints (mobile, tablet, desktop)
- Component size adjustments
- Typography or spacing adjustments

### Accessibility
- ARIA labels or roles required
- Keyboard navigation (tab order, arrow keys for complex components)
- Focus management
- Color contrast (ensure not relying on color alone)

### Consistency Notes
- Cross-references between affected surfaces where behavior or layout must align
- If design differs from existing patterns, explain why
- If there are variants of the same pattern, note which applies and where
