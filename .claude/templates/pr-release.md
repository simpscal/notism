# PR Release Template

Release PR body posted to GitHub. Used by `/sprint-finish` (Step 7).

```
## Sprint N — Release PR

Merges all Sprint N stories into main.

## Stories
- Closes #<N> — <title>

## Migration notes
<If migrations detected:>
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

**Sprint N:** replace with actual sprint number throughout.

**Stories:** one `Closes #<N> — <title>` line per story in the milestone.

**Migration notes:** if EF Core migration files detected, list each file path; otherwise write "No database migrations in this sprint."

**Checklist:** leave all items unchecked — reviewer checks them.
