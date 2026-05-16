---
name: product-authoring
description: Use when creating, amending, or editing `PRODUCT.md` or any of its sections (Vision, Core Value Proposition, Business Model, Business Goals, Target Users, Product Boundaries, Strategic Direction). Owns the contract and Create/Amend workflows.
tools: Read, Write, Edit, AskUserQuestion
---

# PRODUCT.md Authoring

Single source of truth for authoring the `PRODUCT.md` file. Two workflows (Create, Amend) produce or modify the file; the rest of this skill defines the contract those workflows must satisfy (file structure, sections, section argument map, interview questions, constraints, apply rules).

## Workflows

- **Create** — write a new `PRODUCT.md` from scratch via a 7-section interview.
- **Amend** — targeted edit to an existing `PRODUCT.md` driven by a section selection.

## Mode Detection

Decide the branch before doing anything else:

| PRODUCT.md present? | Intent verb in the request                              | Branch                                  |
|---------------------|---------------------------------------------------------|-----------------------------------------|
| no                  | create / set up / generate / init                       | Workflow: Create                        |
| yes                 | create / generate / regenerate                          | Ask Skip / Regenerate (default: Skip)   |
| yes                 | rewrite / overhaul                                      | Workflow: Create — overwrite in place   |
| yes                 | amend / update / change / edit                          | Workflow: Amend                         |

---

## Workflow: Create

Goal: write `PRODUCT.md` at the repo root as the single, agent-readable source of truth for product context that downstream workflows reference.

### Step 1 — Existence check

Check the repo root for `PRODUCT.md`. If it exists, use `AskUserQuestion` to ask whether to **Skip** (keep current) or **Regenerate** (overwrite). Default: Skip.

If the user chooses Skip, exit with: `` `PRODUCT.md` already exists — no changes made. ``

### Step 2 — Interview guidance

For each question in Steps 3–9, assess the answer before moving to the next step. If the response is vague, incomplete, or could be interpreted multiple ways, ask a focused follow-up. Keep iterating until the answer is fully unambiguous. Only then proceed to the next step.

### Step 3 — Vision

Use `AskUserQuestion` to ask:

> "What is the product vision? Describe the problem it solves, for whom, and the core value it delivers."

### Step 4 — Core Value Proposition

Use `AskUserQuestion` to ask:

> "What is the core value proposition? The single clearest reason a customer chooses this product over alternatives."

### Step 5 — Business Model

Use `AskUserQuestion` to ask:

> "What is the business model? How does the product make money?"

### Step 6 — Business Goals

Use `AskUserQuestion` to ask:

> "What are the 3–5 key business goals? List them as short, action-oriented statements (e.g. 'Grow monthly active users', 'Reduce average checkout time')."

### Step 7 — Target Users

Use `AskUserQuestion` to ask:

> "Who are the target users? Describe the primary user (role, key needs, pain points). Include a secondary user if applicable."

### Step 8 — Product Boundaries

Use `AskUserQuestion` to ask:

> "What is explicitly in scope for this product? What is explicitly out of scope?"

### Step 9 — Strategic Direction

Use `AskUserQuestion` to ask:

> "What is the current strategic direction? Include key priorities, differentiators, and near-term focus areas."

### Step 10 — Write PRODUCT.md

Author `PRODUCT.md` at the repo root using the gathered answers, following the canonical format in `## File Structure` below. Every section gets concrete content — no placeholders.

### Step 11 — Confirm

Report: `` `PRODUCT.md` written to repo root. `` Show a one-line summary of each section (Vision, Core Value Proposition, Business Model, Business Goals, Target Users, Product Boundaries, Strategic Direction).

---

## Workflow: Amend

Goal: apply a targeted change to one or more sections of an existing `PRODUCT.md` without touching any non-targeted section.

### Step 1 — File-exists guard

Read `PRODUCT.md` from the repo root. If it does not exist, stop and output: `` No `PRODUCT.md` found. Create it first. ``

### Step 2 — Load current state

Read `PRODUCT.md` in full. Capture every section verbatim — headings, paragraphs, bullets, and subsections (Primary/Secondary under Target Users; In Scope / Out of Scope under Product Boundaries). Hold this as the **baseline**. Do not proceed until the full file is loaded.

### Step 3 — Determine target section

If a section name was passed as an argument (e.g. `vision`), map it via the `## Section Argument Map` below.

If no argument was given, use `AskUserQuestion` to ask:

> "Which section of `PRODUCT.md` do you want to amend?"

Options: Vision, Core Value Proposition, Business Model, Business Goals, Target Users, Product Boundaries, Strategic Direction, All sections.

### Step 4 — Interview the targeted section(s)

Run the matching question(s) from `## Interview Question Bank` below, prefixing "the updated" or "now" where natural (e.g. "What is the updated product vision?"). Skip every non-targeted section. For each answer, iterate with a focused follow-up until the response is fully unambiguous, as in Create.

When the target is `all`, run all seven questions in canonical order.

### Step 5 — Rewrite section(s)

Rewrite **only** the targeted section(s) using the contract rules in `## Apply Rules` below. Every untouched section comes through verbatim — headings, bullet structure, and subsections. Overwrite `PRODUCT.md` with the updated content.

### Step 6 — Confirm

Output the section name(s) updated and a one-line description of the new content.

---

# Contract

The sections below define the contract every Create / Amend run must satisfy.

## File Structure

Pure markdown — no frontmatter, no version field. Seven canonical sections in immutable order:

```markdown
# Product Context

## Vision

{vision statement — one clear paragraph}

## Core Value Proposition

{single clearest reason a customer chooses this product over alternatives — one sentence or short paragraph}

## Business Model

{how the product makes money — one short paragraph}

## Business Goals

{each goal as a bullet point}

## Target Users

### Primary: {primary persona name or role}

{description of role, key needs, and pain points}

### Secondary: {secondary persona name or role}

{description — omit this subsection entirely if no secondary users were identified}

## Product Boundaries

### In Scope

{each in-scope capability as a bullet point}

### Out of Scope

{each exclusion as a bullet point — or "Not specified" if none given}

## Strategic Direction

{strategic direction as a paragraph}
```

## Section Argument Map

| Argument                  | Section                  |
|---------------------------|--------------------------|
| `vision`                  | Vision                   |
| `value` or `proposition`  | Core Value Proposition   |
| `model`                   | Business Model           |
| `goals`                   | Business Goals           |
| `users`                   | Target Users             |
| `boundaries`              | Product Boundaries       |
| `strategy` or `direction` | Strategic Direction      |
| `all`                     | All sections             |

## Interview Question Bank

The canonical question per section. Create asks them verbatim; Amend prefixes "the updated" / "now" where natural.

| Section                | Question                                                                                                                                              |
|------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------|
| Vision                 | "What is the product vision? Describe the problem it solves, for whom, and the core value it delivers."                                               |
| Core Value Proposition | "What is the core value proposition? The single clearest reason a customer chooses this product over alternatives."                                   |
| Business Model         | "What is the business model? How does the product make money?"                                                                                        |
| Business Goals         | "What are the 3–5 key business goals? List them as short, action-oriented statements (e.g. 'Grow monthly active users', 'Reduce average checkout time')." |
| Target Users           | "Who are the target users? Describe the primary user (role, key needs, pain points). Include a secondary user if applicable."                         |
| Product Boundaries     | "What is explicitly in scope for this product? What is explicitly out of scope?"                                                                      |
| Strategic Direction    | "What is the current strategic direction? Include key priorities, differentiators, and near-term focus areas."                                        |

## Constraints

- Section order is immutable. The seven sections must appear in the canonical order shown in `## File Structure`.
- Section headings must match the canonical names exactly (`Vision`, `Core Value Proposition`, `Business Model`, `Business Goals`, `Target Users`, `Product Boundaries`, `Strategic Direction`).
- The `### Secondary:` subsection under Target Users is omitted entirely when no secondary users exist — do not leave an empty heading.
- `### Out of Scope` falls back to `Not specified` when none were given.
- `PRODUCT.md` is pure markdown — no YAML frontmatter, no `version` field.
- Do not invent content. Every section's body must come from the user's interview answers.

## Apply Rules

- **Create** writes the file end-to-end using the `## File Structure` template. Every section gets concrete content — no placeholders or `{…}` braces in the output.
- **Amend** edits only the targeted section(s) and preserves every other section byte-for-byte:
  - Headings, paragraphs, bullets, and subsections in untouched sections are reproduced verbatim.
  - When the target is `all`, rewrite all seven canonical sections; still preserve any user-added sections outside the canonical set at the bottom of the file.
  - When the target is a single section, rewrite only that section's body (and its subsections, where applicable) — leave the heading line unchanged.
