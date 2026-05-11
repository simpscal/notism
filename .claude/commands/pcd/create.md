# Mode: Create

## Step 1 — Check Existing File

Check the repo root for `PRODUCT.md`. If it exists, use `AskUserQuestion` to ask whether to **Skip** (keep current) or **Regenerate** (overwrite). Default: Skip.

If the user chooses Skip, exit with: "`PRODUCT.md` already exists — no changes made."

## Interview Guidance (Steps 2–8)

For each question, assess the answer before moving to the next step. If the response is vague, incomplete, or could be interpreted multiple ways, ask a focused follow-up. Keep iterating until the answer is fully unambiguous. Only then proceed to the next step.

## Step 2 — Vision

Use `AskUserQuestion` to ask:

> "What is the product vision? Describe the problem it solves, for whom, and the core value it delivers."

## Step 3 — Core Value Proposition

Use `AskUserQuestion` to ask:

> "What is the core value proposition? The single clearest reason a customer chooses this product over alternatives."

## Step 4 — Business Model

Use `AskUserQuestion` to ask:

> "What is the business model? How does the product make money?"

## Step 5 — Business Goals

Use `AskUserQuestion` to ask:

> "What are the 3–5 key business goals? List them as short, action-oriented statements (e.g. 'Grow monthly active users', 'Reduce average checkout time')."

## Step 6 — Target Users

Use `AskUserQuestion` to ask:

> "Who are the target users? Describe the primary user (role, key needs, pain points). Include a secondary user if applicable."

## Step 7 — Product Boundaries

Use `AskUserQuestion` to ask:

> "What is explicitly in scope for this product? What is explicitly out of scope?"

## Step 8 — Strategic Direction

Use `AskUserQuestion` to ask:

> "What is the current strategic direction? Include key priorities, differentiators, and near-term focus areas."

## Step 9 — Write PRODUCT.md

Write `PRODUCT.md` to the repo root using the gathered answers. Format:

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

{description — omit this subsection entirely if the user indicated no secondary users}

## Product Boundaries

### In Scope

{each in-scope capability as a bullet point}

### Out of Scope

{each exclusion as a bullet point — or "Not specified" if none given}

## Strategic Direction

{strategic direction as a paragraph}
```

## Step 10 — Confirm

Report: "`PRODUCT.md` written to repo root." Show a one-line summary of each section (Vision, Core Value Proposition, Business Model, Business Goals, Target Users, Product Boundaries, Strategic Direction).
