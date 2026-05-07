# Project Config

## Codebases

| Name | Path | Summary |
|------|------|---------|
| api | `../notism-api` | ASP.NET Core 9 REST API with EF Core 8 and PostgreSQL |
| web | `../notism-web` | React 18 + Vite + TypeScript SPA with Tailwind CSS, Redux Toolkit, React Query, and shadcn/ui |
| infrastructure | `../notism-api/terraform` | Terraform 1.x infrastructure on AWS (EC2, RDS, S3, CloudFront, VPC) |

---

## Migration Detection

EF Core migrations live in the `api` codebase at `src/Notism.Infrastructure/Migrations/`. Filter changed files for `/Migrations/` case-insensitively to detect migration changes in PRs.

---

## Labels

| Purpose | Label |
|---------|-------|
| PO requirement | `requirement` |
| BA-created story | `user-story` |
| TDD issue | `technical-design` |
| Design instructions issue | `design` |
| Dev in progress | `in-progress` |
| Story amended after creation | `story-updated` |
| Story removed during requirement change | `story-removed` |
| Requirement updated after change | `requirement-updated` |
| Sprint closed | `sprint-completed` |
| Tech-lead refactoring task | `refactoring` |
| Bug issue | `bug-production` |
| Bug resolved and closed | `bug-fixed` |
| Dev implementation complete | `implemented` |
| QA test cases verified by human | `qa-passed` |
| QA test cases have failures | `qa-blocked` |
