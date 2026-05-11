---
name: design-system
description: Generate DESIGN.md — the project's agent-readable design system document.
argument-hint: "create | amend"
tools: Read, Write, Glob, Grep, Bash, AskUserQuestion
---

# Design System

## Step 1 — Parse Arguments and Determine Mode

| First word | Mode | Mode file |
|---|---|---|
| `create` or (no arg) | Create | `design-system/create.md` |
| `amend` | Amend | `design-system/amend.md` |

**Load the corresponding mode file and follow its steps.**

---

## Constraints

### Step Tracking
After completing each numbered step (`## Step N`), emit exactly:

> STEP [N] COMPLETE

before proceeding to the next step. Do not skip or batch emit — one signal per step, inline in the response.
