# Mode: Amend TDD

Extract `sprint_number` (the token after `amend-tdd`).

---

## Step 1 — Load Sprint Context

List all milestones to find the one titled `Sprint N`. Hold its GitHub ID as `$MILESTONE_ID`.

List all **open** issues in the sprint milestone once. Partition the result in memory:

- **$STORIES** — issues labelled `user-story`. Read each in full — body, acceptance criteria, and notes.
- **$REQUIREMENT** — single issue labelled `requirement`. Read it in full.
- **$TDD** — single issue labelled `technical-design`. Read it in full.
  - If no TDD exists, report "No TDD found for Sprint N — run `/tech-lead write-feature-tdd Sprint N` first" and stop.
- **$DESIGN** — single issue labelled `design` (may be absent). If present, read it in full.

---

## Step 2 — Load Architecture Constraints

Read each codebase's `CLAUDE.md` (paths are defined in this repo's CLAUDE.md under **Codebases**).

Hold the architecture facts in memory — layer structure, naming conventions, build/test commands, patterns in use.

---

## Step 3 — Reconstruct the Mental Model

Work through all loaded material silently. Produce no output in this step. Build the following understanding before proceeding:

**From $STORIES and $REQUIREMENT:**
- What is the sprint goal? What capability does the user gain?
- What domain concepts appear across stories (entities, workflows, states)?
- Which stories share domain objects or API surface?
- Are there ordering dependencies between stories?
- Which stories are flagged `story-updated` or `story-removed`, if any?

**From $TDD:**
- What is the key architectural decision — the one call that shapes everything else?
- What data models were introduced or modified?
- What API contracts were defined?
- What alternatives were explicitly rejected, and why?
- What failure modes were identified?
- What is the current implementation priority order?

**From $DESIGN (if present):**
- What UI layout was specified?
- What components were defined?

**From CLAUDE.md files:**
- What architectural constraints apply to each codebase?
- What patterns must be followed?

Complete when: you can state the feature goal, name every domain concept, summarise every key TDD decision, and flag open questions — without re-reading any issue.

Activate as Technical Lead for Sprint N. State:

> Technical Lead active — Sprint N. Full sprint knowledgebase loaded: requirement, all stories, TDD decisions, architecture constraints, and implementation priority. Ready to discuss changes or alternatives.

---

## Step 4 — Open Amendment Dialog

Ask the tech lead a single `AskUserQuestion`:

> What changed in the design, and why? Describe the problem with the current TDD and the direction you want to go — or share options you'd like to evaluate.

Hold the response as **$CHANGE_INPUT**. Do not proceed until answered.

Use $CHANGE_INPUT to engage in discussion if the tech lead is exploring alternatives. Answer trade-off questions, surface constraints from the mental model, and flag risks from architecture constraints or failure modes already in the TDD. Continue until the tech lead confirms the final direction.

---

## Step 5 — Revise TDD

Use the current TDD as the baseline. For each design area below, evaluate whether the confirmed change affects it — keep unchanged areas exactly, rewrite only affected parts.

| Area | TDD field | What to define |
|------|-----------|----------------|
| High-level diagram | `high_level_diagram` | Services, databases, caches, third-party — label new vs existing |
| Happy path | `happy_path` | Mermaid sequence: user → services → storage → response |
| Unhappy path | `unhappy_path` | Key failure scenario and system response |
| Technology stack | `tech_stack` | New languages/frameworks/libraries/infra only |
| Infrastructure Design | `infrastructure_design` | Cloud resources added/modified; IaC module changes; environment-specific config. If no changes, explicitly report "None". |
| Components design | `components_design` | Two sections — **Backend** and **Frontend**. Mermaid flowchart or graph. No sequence diagrams. |
| Data models | `data_models` | Entities, relationships, key indexes — ERD or schema |
| API specification | `api_spec` | Method, route, auth, request/response shape, status codes |
| Event schemas | `event_schemas` | Topic, event structure, producer, consumer — or N/A |
| Security | `security` | Auth, authz, encryption at rest and in transit |
| Scalability & performance | `scalability` | Throughput/latency targets, query design, caching, async offloading |
| Failure modes | `failure_modes` | Min 2 rows: Scenario, Impact, Mitigation |
| Migration plan | `migration` | Data migration, cutover, rollback — or N/A |
| Monitoring & alerting | `monitoring` | Key metrics, alert thresholds |
| Implementation Priority | `implementation_priority` | P1/P2/P3 — open `user-story` issues only |

Update the body of the TDD issue with the revised content.

---

## Step 6 — Classify Scope Changes

From $STORIES, filter to only stories carrying the `implemented` label. Compare the revised TDD against each implemented story and classify the impact:

| Classification | Condition |
|----------------|-----------|
| `additive` | TDD change adds new behaviour or contracts the story doesn't yet cover; existing implementation remains valid |
| `breaking` | TDD change conflicts with or invalidates what the story's existing implementation does; must be replaced |
| `structural` | TDD change requires full revisit of the story's implementation; affected files treated as blank slate |
| `unaffected` | Story is not touched by the TDD change |

Produce a **Scope Classification Table**:

| Story | Title | Classification | Reason |
|-------|-------|----------------|--------|
| #N | title | additive / breaking / structural / unaffected | one sentence |

If any classification is ambiguous, ask the tech lead before proceeding.

---

## Step 7 — Label Affected Stories

For each story classified `additive`, `breaking`, or `structural` in Step 6:

- Check if the story carries the `implemented` label.
- If yes — add label `story-updated` to the issue.
- If no — skip. The story has not been implemented yet; dev will implement against the revised TDD when they pick it up.

Run all label additions in parallel.

