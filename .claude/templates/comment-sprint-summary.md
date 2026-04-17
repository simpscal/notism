# Comment Sprint Summary Template

Posted to requirement issue by `/sprint-finish` (Step 8).

---

## OUTPUT FORMAT

```
## Sprint Closed ✓

**Sprint**: Sprint N
**Closed**: {today's date}

### Stories shipped
| Issue | Title | Skill |
|-------|-------|-------|
| #N | <title> | <skill:* label value> |

### Release PRs
| Codebase | PR |
|----------|----|
| backend | #<N> |
| frontend | #<N> |

### Migrations
<"⚠️ EF Core migrations detected — see backend PR for details." or "None">

---
> ⏸ Human gate: Review and merge the release PRs into main. If migrations are present, run them on production after deploy.
```

---

## FIELDS

### Sprint
**REQUIRED** | text | Pattern: `Sprint [0-9]+`

**Rules**: Match milestone name exactly

**Wrong**: ❌ "Sprint Five", "S5", "5"

### Closed
**REQUIRED** | date | Format: `YYYY-MM-DD`

**Rules**: Today's date, regex: `^\d{4}-\d{2}-\d{2}$`

**Wrong**: ❌ "April 17, 2026", "17/04/2026", "04-17-2026"

### Stories shipped
**REQUIRED** | table | 3 columns: Issue | Title | Skill

**Rules**:
- One row per story in milestone
- Issue: `#[0-9]+` format
- Title: Exact GitHub issue title
- Skill: Value after `skill:` prefix (e.g., `skill:frontend` → `frontend`)
- Sort by issue number ascending

**Wrong**: ❌ Missing `#`, ❌ Truncated titles, ❌ Full label name

### Release PRs
**REQUIRED** | table | 2 columns: Codebase | PR

**Rules**:
- One row per codebase with changes
- Codebase: Match project.md names (`backend`, `frontend`)
- PR: `#[0-9]+` format
- Only include codebases with actual changes

**Wrong**: ❌ Including unchanged codebases, ❌ Wrong names

### Migrations
**REQUIRED** | text (conditional)

**If migrations detected**: `⚠️ EF Core migrations detected — see backend PR for details.`
**If no migrations**: `None`

**Detection**: Check for `**/Migrations/*.cs` files in backend changes

**Wrong**: ❌ "No migrations", "Migrations present", "See PR"

### Human gate
**REQUIRED** | blockquote (fixed text)

**Use**: `> ⏸ Human gate: Review and merge the release PRs into main. If migrations are present, run them on production after deploy.`

---

## CHECKLIST

- [ ] Sprint number matches milestone
- [ ] Date is today in YYYY-MM-DD
- [ ] All milestone stories in table
- [ ] Story titles match GitHub exactly
- [ ] Skill values from `skill:*` labels
- [ ] Only changed codebases in PRs table
- [ ] PR numbers correct
- [ ] Migrations status reflects detection
- [ ] Human gate message included
