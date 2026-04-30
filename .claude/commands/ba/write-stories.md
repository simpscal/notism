# Mode: Write Stories

Read issue `#requirement_issue_number` in full.

---

## Requirements Analysis

Before discovery, extract from the requirement:

- **Core user need**: Who? What action? What outcome?
- **Stated constraints**: Explicit limitations
- **Implicit assumptions**: What must be true for this to work?

Answer all before moving on:
1. Who is the primary user?
2. What is the single most important thing they want to achieve?
3. What does "done" look like?
4. What is explicitly out of scope?
5. Any UX, integration, or regulatory constraints not stated?

Then define scope:
- **Goal**: One sentence — what the user can do after this is built that they cannot do today
- **In scope**: Explicitly included
- **Out of scope**: Explicitly excluded or deferred
- **Assumptions**: What you assume to proceed

If any of the above cannot be answered from the input, run a discovery session before proceeding.

---

## Step 1 — Discovery Session with PO

Goal: state in one unambiguous sentence what the sprint goal is.

1. **Synthesise first.** State your current understanding:
   - Who is the user?
   - What do they want to achieve?
   - What does "done" look like?
   - What constraints or boundaries apply?

2. **Surface every gap.** Identify ambiguities, conflicting signals, and missing context that would materially change scope.

3. **Open the dialogue.** Ask all blocking questions in one structured message:
   - Lead: *"Here is what I understand — please correct anything wrong."*
   - Follow: *"Before I proceed, I need to clarify:"* — list specific questions.
   - Do NOT drip-feed questions one at a time.

4. **Incorporate and iterate.** After each response, re-synthesise. Repeat until fully unambiguous.

5. **Confirm alignment.** State final understanding before producing output.

---

## Step 2 — Decompose into Stories

Analyse the requirement and decompose into 3–20 user stories. Apply INVEST to every story:

| Letter | Criterion | What it means |
|---|---|---|
| **I** | Independent | Can be built and delivered alone |
| **N** | Negotiable | Describes the need, not the spec |
| **V** | Valuable | Delivers something the user actually cares about |
| **E** | Estimable | Clear enough to size |
| **S** | Small | Fits in a sprint increment |
| **T** | Testable | A stakeholder can verify it without reading code |

**Format**: `As a <user>, I want <action> so that <benefit>`

For each story, write ACs immediately:

**AC format**: *"When X, then Y"* or *"Given X, when Y, then Z"*

**AC testability checklist** — every AC must pass:
- Names the specific user-visible area where the change appears (e.g. "in the comment panel", "on the settings page")?
- Observable without reading code?
- Describes a specific condition and a specific outcome?
- Could a non-engineer verify it in a running system?

Rewrite any AC that fails until it passes. Avoid vague language: "should work", "handles errors", "is fast".

Include a **Notes** section per story for: edge cases, UX considerations, dependencies on other stories, open questions.

**Validate the full story set:**
- No hidden dependencies (or all dependencies explicit)
- No overlapping scope between stories
- Set fully satisfies the goal
- No gold-plating — every story traces back to the goal

---

## Step 3 — Create Sprint Milestone

List all milestones to determine the next sprint number.
Create a milestone named `Sprint N` with the sprint goal.

---

## Step 4 — Create User Story Issues

For each story: create an issue titled `[Story] <title>` with label `user-story` and the sprint milestone, where the body comes from the `issue-user-story` template with `{user_story, acceptance_criteria, notes, requirement_issue}`.

> **Dependency linking**: Create all issues first, then back-fill dependency references in Notes for both `Depends on` and `Blocks` directions, linking to the relevant issue numbers.

---

