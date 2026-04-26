# Issue: Design Instructions

## OUTPUT FORMAT

```
Part of #<requirement_issue_number>

---

## Design Instructions

### Overview
<sprint UI goal, affected pages (mark new vs modified), reference pages>

### Layout
<page structure, flow, spacing — ASCII wireframes; mark new with `← new`>

### Components
| Element | Component | Variant | Size | Notes |

### Design Tokens
| Usage | Token | Notes |

### UI States
| Surface | State | Implementation |

### Responsive Behavior
<mobile, tablet, desktop breakpoints>

### Accessibility
<ARIA labels/roles, keyboard nav (tab order, Enter/Escape), focus management, contrast>

### Consistency Notes
<cross-surface deviations or NONE>
```

---

## FIELDS

| Field | Req | Notes |
|-------|-----|-------|
| `requirement_issue` | yes | e.g. `#38` |
| `overview` | yes | Sprint UI goal + affected pages (new vs modified) + reference pages |
| `layout` | yes | Page structure + ASCII wireframes; mark new with `← new` |
| `components` | yes | Exact names/variants from design system — no invented components |
| `design_tokens` | yes | Exact token names — no raw values (`#fff`, `16px`) |
| `ui_states` | yes | Cover Loading, Error, Empty, Success per surface |
| `responsive` | yes | Mobile, tablet, desktop — layout, spacing, component size changes |
| `accessibility` | yes | ARIA, keyboard nav, focus management, WCAG AA contrast |
| `consistency_notes` | no | Cross-surface deviations with WHY, or `NONE` |
