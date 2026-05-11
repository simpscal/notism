---
name: pcd
description: Generate and maintain the Product Context Document (product-context.md).
argument-hint: "create | amend [section]"
tools: Read, Write, AskUserQuestion
---

# Product Context Document

## Step 1 — Parse Arguments and Determine Mode

| First word | Mode | Args | Mode file |
|---|---|---|---|
| `create` or (no arg) | Create | — | `pcd/create.md` |
| `amend` | Amend | `[section]` | `pcd/amend.md` |

**Load the corresponding mode file and follow its steps.**

---

## Constraints

### Step Tracking
After completing each numbered step (`## Step N`), emit exactly:

> STEP [N] COMPLETE

before proceeding to the next step. Do not skip or batch emit — one signal per step, inline in the response.
