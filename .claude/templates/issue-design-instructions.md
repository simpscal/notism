# Issue Design Instructions Template

Posted to GitHub by `/design` (standard mode S6, change mode, requirement-change mode).

---

## OUTPUT FORMAT

```
Part of #<requirement_issue_number>

---

## Design Instructions

### Overview
<sprint UI goal, affected pages, reference pages>

### Layout
<page structure, flow, spacing, ASCII wireframes>

### Components
| Element | Component | Variant | Size | Notes |

### Design Tokens
| Usage | Token | Notes |

### UI States
| Surface | State | Implementation |

### Responsive Behavior
<layout changes at breakpoints>

### Accessibility
<ARIA, keyboard nav, focus, contrast>

### Consistency Notes
<cross-surface references or deviations>
```

---

## FIELDS

### Part of
**REQUIRED** | text | Format: `Part of #<requirement_issue_number>`

**Rules**: First line, followed by `---`

**Wrong**: ❌ "Related to #142", ❌ Missing `---`

### Overview
**REQUIRED** | text (structured)

**Include**:
- Sprint UI goal (1 sentence, 50-200 chars)
- Affected pages (list, mark new vs modified)
- Reference pages (pattern: "Follow pattern of `<path>`")

**Wrong**: ❌ No goal, ❌ Not marking new vs modified, ❌ No reference

### Layout
**REQUIRED** | text + ASCII wireframes

**Include**:
- Page structure (grid/flex/nesting)
- Flow and spacing
- ASCII wireframes (one per major variant)

**Wireframe syntax**:
- Box-drawing: `┌─┐│└┘┬┴┼├┤`
- Existing: `[Component]`
- New: `Component ← new`

**Wrong**: ❌ Inconsistent ASCII, ❌ Not marking new, ❌ No wireframe

### Components
**REQUIRED** | table | 5 columns: Element | Component | Variant | Size | Notes

**Rules**:
- List every UI component
- Match exact names from component library
- Match exact variant names
- Use design system sizes
- Don't invent components

**Wrong**: ❌ "Nice button" (invented), ❌ "Button (blue)" (use variant), ❌ Missing variant/size

### Design Tokens
**REQUIRED** | table | 3 columns: Usage | Token | Notes

**Rules**:
- List all tokens (colors, spacing, typography)
- Match exact token names from design system
- No raw values (`#fff`, `16px`)

**Wrong**: ❌ `#3B82F6` instead of token, ❌ `24px` instead of spacing token, ❌ Invented tokens

### UI States
**REQUIRED** | table | 3 columns: Surface | State | Implementation

**Rules**:
- Cover Loading, Error, Empty, Success for each surface
- Surface: page or component name
- State: Loading | Error | Empty | Success | Disabled | etc.
- Implementation: specific UI changes

**Wrong**: ❌ "Show error" (not specific), ❌ Missing states, ❌ "Handle appropriately"

### Responsive Behavior
**REQUIRED** | text (structured)

**Rules**:
- Cover mobile, tablet, desktop breakpoints
- Describe layout, spacing, component size changes
- Cover all affected surfaces

**Wrong**: ❌ "Make responsive" (not specific), ❌ Only mobile, ❌ No breakpoint values

### Accessibility
**REQUIRED** | text (structured)

**Include**:
- ARIA labels/roles
- Keyboard navigation (tab order, keys, Enter/Escape)
- Focus management
- Color contrast (WCAG AA minimum)

**Wrong**: ❌ "Make accessible" (not specific), ❌ Missing keyboard nav, ❌ No focus management

### Consistency Notes
**OPTIONAL** | text

**Include**:
- Cross-surface consistency requirements
- Intentional deviations from patterns (with WHY)

**If none**: Use `NONE`

**Wrong**: ❌ Blank (use "NONE")

---

## CHECKLIST

- [ ] "Part of #N" at top with `---`
- [ ] Overview: goal, affected pages, reference
- [ ] Layout has ASCII wireframes
- [ ] Wireframes mark new with `← new`
- [ ] Components from library only
- [ ] Design tokens, no raw values
- [ ] UI States covers all surfaces
- [ ] Responsive covers mobile/tablet/desktop
- [ ] Accessibility: ARIA, keyboard, focus, contrast
- [ ] Consistency notes or "NONE"
