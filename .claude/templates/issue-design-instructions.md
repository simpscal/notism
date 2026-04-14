# Issue Design Instructions Template

Design instructions issue body posted to GitHub. Used by `/design` (standard mode S6, change mode, requirement-change mode).

```
Part of #<requirement_issue_number>

---

## Design Instructions

### Overview
<sprint UI goal, list of affected pages/surfaces, reference pages>

### Layout
<full-feature page structure, flow, spacing, ASCII wireframe(s)>

### Components
| Element | Component | Variant | Size | Notes |
|---------|-----------|---------|------|-------|

### Design Tokens
| Usage | Token | Notes |
|-------|-------|-------|

### UI States
| Surface | State | Implementation |
|--------|-------|---------------|

### Responsive Behavior
<layout changes at each breakpoint across all affected surfaces>

### Accessibility
<ARIA labels, keyboard navigation, focus management, contrast>

### Consistency Notes
<cross-surface references or deviations from existing patterns>
```

**Part of:** use parent requirement issue number — `#<requirement_issue_number>`

**Overview:** sprint UI goal in one sentence; list of pages/surfaces affected (new or modified); reference pages ("Follow the pattern of `<path>`")

**Layout:** full-feature page structure (grid, flex arrangement, nesting); flow, spacing, navigation between surfaces; ASCII wireframes. Wireframe rules: use `┌ ─ ┐ │ └ ┘ ┬ ┴ ┼ ├ ┤` box-drawing characters; label existing in `[brackets]`, new additions marked with `← new`; one sketch per meaningful state or layout variant.

**Components:** table — Element | Component name | Variant | Size | Notes. Use exact component names from inventory; use exact CVA variant names; do not invent components.

**Design Tokens:** table — Usage | Token name | Notes. Use exact token names; never prescribe raw values (no `#ffffff`, `16px`, etc.)

**UI States:** table — Surface | State | Implementation. Cover Loading, Error, Empty, Success for every affected surface.

**Responsive Behavior:** layout changes at mobile/tablet/desktop breakpoints; component size and spacing adjustments.

**Accessibility:** ARIA labels/roles, keyboard navigation (tab order, arrow keys), focus management, color contrast.

**Consistency Notes:** cross-surface references where behavior/layout must align; deviations from existing patterns with explanation.
