# Comment Bug Summary Template

Posted to bug issue by `/po:close-bug` (Step 7).

---

## OUTPUT FORMAT

```
## Bug Closed ✓

**Issue**: #N — <title>
**Closed**: {today's date}

### Migrations
<"⚠️ EF Core migrations detected — apply on production after deploy." or "None">

---
> ⏸ Human gate: If migrations are present, run them on production after deploy.
```

Note: omit the `---` separator and human gate blockquote entirely when there are no migrations.

---

## FIELDS

### Issue
**REQUIRED** | text | Format: `#N — <title>`

**Rules**: Issue number and exact GitHub title. Use em dash `—` (not hyphen `-`).

**Wrong**: ❌ Title truncated, ❌ Hyphen instead of em dash

### Closed
**REQUIRED** | date | Format: `YYYY-MM-DD`

**Rules**: Today's date. Regex: `^\d{4}-\d{2}-\d{2}$`

**Wrong**: ❌ "April 21, 2026", ❌ "21/04/2026", ❌ "04-21-2026"

### Migrations
**REQUIRED** | text (conditional)

**If migrations detected**: `⚠️ EF Core migrations detected — apply on production after deploy.`
**If no migrations**: `None`

**Detection**: Merged backend PR contains files matching `**/Migrations/*.cs`

**Wrong**: ❌ "No migrations", "Migrations present", ❌ Listing individual file paths here

### Human gate
**CONDITIONAL** | blockquote (fixed text)

**Include only when migrations detected**:
```
> ⏸ Human gate: If migrations are present, run them on production after deploy.
```

Preceded by a `---` horizontal rule. Omit entirely when there are no migrations.

**Wrong**: ❌ Showing human gate when no migrations, ❌ Modified wording

---

## CHECKLIST

- [ ] Issue number and title match GitHub exactly
- [ ] Em dash `—` used between issue number and title
- [ ] Date is today in YYYY-MM-DD
- [ ] Migrations status reflects detection result
- [ ] Human gate and separator included only when migrations present
