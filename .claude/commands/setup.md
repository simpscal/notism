---
name: setup
description: One-off project setup — init, PCD, design system.
argument-hint: "<init|pcd|design-system> [create|amend [section]]"
tools: Read, Write, Glob, Grep, Bash, AskUserQuestion
---

# /setup — Project Setup Orchestrator

## Step 1 — Parse Arguments and Load Mode

| Stage | Args | Description | Mode file |
|---|---|---|---|
| `init` | _(none)_ | Bootstrap project config — generate `config.md`, `PRODUCT.md`, `DESIGN.md` interactively. | `setup/init.md` |
| `pcd create` | _(none)_ | Generate the Product Context Document (`PRODUCT.md`) from scratch. | `setup/pcd-create.md` |
| `pcd amend` | `[section]` | Revise one section of `PRODUCT.md` (or all sections if omitted). | `setup/pcd-amend.md` |
| `design-system create` | _(none)_ | Generate `DESIGN.md` from the web codebase. | `setup/ds-create.md` |
| `design-system amend` | _(none)_ | Update `DESIGN.md` after design system changes. | `setup/ds-amend.md` |

**Argument reference:**

- `[section]` — optional `PRODUCT.md` section name; omit to revise all sections.

**Load the corresponding mode file and follow its steps.**

If the arguments do not match any stage, ask the user via `AskUserQuestion`.

---

## Constraints

- Setup commands write project-level docs (config.md, PRODUCT.md, DESIGN.md). Never overwrite without explicit user confirmation if a file already exists.

### Step Tracking
After completing each numbered step, emit exactly:

> STEP [N] COMPLETE
