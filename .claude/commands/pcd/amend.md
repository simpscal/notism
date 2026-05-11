# Mode: Amend

## Step 1 — Load Current Document

Read `PRODUCT.md` from the repo root. If it does not exist, stop and output: "No `PRODUCT.md` found. Run `/pcd create` first."

## Step 2 — Determine Target Section

If a section name was passed as an argument (e.g. `/pcd amend vision`), map it directly:

| Argument | Section |
|----------|---------|
| `vision` | Vision |
| `value` or `proposition` | Core Value Proposition |
| `model` | Business Model |
| `goals` | Business Goals |
| `users` | Target Users |
| `boundaries` | Product Boundaries |
| `strategy` or `direction` | Strategic Direction |
| `all` | All sections |

If no argument was given, use `AskUserQuestion` to ask:

> "Which section of PRODUCT.md do you want to amend?"

Options: Vision, Core Value Proposition, Business Model, Business Goals, Target Users, Product Boundaries, Strategic Direction, All sections

## Interview Guidance (Steps 3–9)

For each question, assess the answer before moving to the next step. If the response is vague, incomplete, or could be interpreted multiple ways, ask a focused follow-up. Keep iterating until the answer is fully unambiguous. Only then proceed to the next step.

## Step 3 — Vision

Skip this step if the target section is not Vision or All.

Use `AskUserQuestion` to ask:

> "What is the updated product vision? Describe the problem it solves, for whom, and the core value it delivers."

## Step 4 — Core Value Proposition

Skip this step if the target section is not Core Value Proposition or All.

Use `AskUserQuestion` to ask:

> "What is the updated core value proposition? The single clearest reason a customer chooses this product over alternatives."

## Step 5 — Business Model

Skip this step if the target section is not Business Model or All.

Use `AskUserQuestion` to ask:

> "What is the updated business model? How does the product make money?"

## Step 6 — Business Goals

Skip this step if the target section is not Business Goals or All.

Use `AskUserQuestion` to ask:

> "What are the updated business goals? List them as short, action-oriented statements."

## Step 7 — Target Users

Skip this step if the target section is not Target Users or All.

Use `AskUserQuestion` to ask:

> "Who are the target users now? Describe the primary user (role, key needs, pain points) and secondary user if applicable."

## Step 8 — Product Boundaries

Skip this step if the target section is not Product Boundaries or All.

Use `AskUserQuestion` to ask:

> "What is now explicitly in scope? What is explicitly out of scope?"

## Step 9 — Strategic Direction

Skip this step if the target section is not Strategic Direction or All.

Use `AskUserQuestion` to ask:

> "What is the updated strategic direction? Key priorities, differentiators, and near-term focus."

## Step 10 — Rewrite Section

Rewrite **only** the targeted section(s). Preserve all other sections verbatim — headings, bullet structure, and any subsections (e.g. Primary/Secondary under Target Users). Overwrite `PRODUCT.md` with the updated content.

## Step 11 — Confirm

Output the section name(s) updated and a one-line description of the new content.
