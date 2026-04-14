# Comment Sprint Summary Template

Sprint summary comment posted to requirement issue. Used by `/sprint-finish` (Step 8).

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

**Sprint:** `Sprint N` — use actual sprint number.

**Closed:** today's date in `YYYY-MM-DD` format.

**Stories shipped:** one row per story — Issue number, title, skill label value (e.g. `frontend`, `backend`).

**Release PRs:** one row per codebase — include PR number.

**Migrations:** `⚠️ EF Core migrations detected — see backend PR for details.` if any found in Step 6, otherwise `None`.
