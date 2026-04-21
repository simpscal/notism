# PR Release Template

Posted to GitHub by `/po:close-sprint` (Step 7).

---

## OUTPUT FORMAT

```
## Sprint N — Release PR

Merges all Sprint N stories into main.

## Stories
- Closes #<N> — <title>

## Migration notes
<If migrations:>
⚠️ EF Core migrations detected — apply before or after deploy:
  dotnet ef database update

  Files:
  - <migration file path>

<If no migrations:>
No database migrations in this sprint.

## Checklist
- [ ] All story PRs merged into sprint branch
- [ ] Migration scripts reviewed (if any)
- [ ] Lint and tests pass on sprint branch
- [ ] QA sign-off
```

---

## FIELDS

### Title
**REQUIRED** | heading | Pattern: `## Sprint N — Release PR`

**Rules**: Match milestone number

**Wrong**: ❌ "Sprint Seven", "Release for Sprint 7"

### Description
**REQUIRED** | text | Pattern: `Merges all Sprint N stories into main.`

**Rules**: Match sprint number

### Stories
**REQUIRED** | list | Format: `- Closes #<N> — <title>`

**Rules**:
- Include every story in milestone
- Pattern: `- Closes #[0-9]+ — <title>`
- Sort by issue number ascending
- Title matches GitHub exactly
- Use em dash `—` (not hyphen `-`)
- "Closes" triggers GitHub auto-close

**Wrong**: ❌ Missing "Closes", ❌ Hyphen instead of em dash, ❌ Unsorted, ❌ Truncated titles

### Migration notes
**REQUIRED** | text (conditional)

**If migrations detected**:
```
⚠️ EF Core migrations detected — apply before or after deploy:
  dotnet ef database update

  Files:
  - <path1>
  - <path2>
```

**If no migrations**: `No database migrations in this sprint.`

**Detection**: New files matching `**/Migrations/*.cs` in backend

**Wrong**: ❌ "No migrations", "None", ❌ List files without warning

### Checklist
**REQUIRED** | checklist (4 items, all unchecked)

**Fixed content**:
```
- [ ] All story PRs merged into sprint branch
- [ ] Migration scripts reviewed (if any)
- [ ] Lint and tests pass on sprint branch
- [ ] QA sign-off
```

**Wrong**: ❌ Pre-checked items, ❌ Modified wording, ❌ Missing items

---

## CHECKLIST

- [ ] Sprint number in all locations
- [ ] All milestone stories included
- [ ] Issue numbers sorted ascending
- [ ] Titles match GitHub exactly
- [ ] Em dash `—` used
- [ ] Migration notes reflect detection
- [ ] All migration paths correct
- [ ] Checklist has 4 unchecked items
