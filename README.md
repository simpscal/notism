# GitHub-Native Human-Gated AI Workflow

> One control plane, many code planes.

Claude Code slash-commands that map development roles to AI agents. Each agent has a job, a scope, and a handoff — to another agent or a human.

- **Orchestrator, not a codebase.** This repo holds stories, sprints, and workflow state in GitHub Issues. Agents check out your real code repos (API, web, infra), registered once via `/init`.
- **Team-first.** PO, reviewers, QA, and devs operate on the same issues. Labels say what's next — no private AI threads, no silos.
- **GitHub is the source of truth.** Requirements, stories, designs, TDDs, test cases — every artifact is an issue. State changes by label, not by chat.
- **Humans gate every stage.** AI handles volume; humans approve. Nothing ships without sign-off.
- **Drop-in for existing codebases.** Agents read your repos and operate inside them, never around them.

```mermaid
flowchart LR
    subgraph ORCH["This Repo · Orchestrator"]
        direction TB
        ISSUES["GitHub Issues · Labels · Milestones<br/>requirements · stories · TDDs<br/>designs · test cases · bugs"]
        AGENTS["Claude Code Agents<br/>/po · /ba · /designer · /tech-lead<br/>/dev · /qa · /release"]
    end

    subgraph TARGETS["Your Code Repos"]
        direction TB
        BE["Backend repo<br/>API"]
        FE["Frontend repo<br/>Web"]
        IN["Infrastructure repo<br/>Terraform · SAM · etc."]
    end

    ORCH ==>|"branch · implement · commit · open PR · merge"| TARGETS
    TARGETS -.->|"read codebase context"| ORCH
```

No application code lives here. The orchestrator plans, tracks state, and drives agents — which branch, commit, and open PRs in your real repos.

---

## Quick Start

**Prerequisites:** Claude Code CLI, GitHub CLI (`gh`), an existing GitHub repo with a codebase

```bash
# 1. Clone this workflow repo
git clone https://github.com/simpscal/notism.git

# 2. Copy the workflow into your existing project
cp -r notism/.claude /path/to/your/project/
```

Then open Claude Code in your project and run:

```
/init
```

`/init` does three things:

- **Generates `config.md`** — registers your codebases (API, web, infra), detects tech stack, and configures migration detection
- **Generates `DESIGN.md`** — extracts your design tokens (colors, fonts, radius, spacing) and component primitives to give the Designer and frontend agents a ground truth
- **Creates the GitHub labels** the workflow needs (`requirement`, `user-story`, `qa-passed`, etc.) — safe to re-run

Run `/init` once. Re-run it if your project structure changes significantly.

After init, start your first sprint:

```
/po create-requirement "Next feature on the backlog"
```

**Nothing is disrupted.** The workflow only adds `.claude/`, `config.md`, and `DESIGN.md`. Existing issues, PRs, and branches are unaffected. It manages only the issues it creates and sits cleanly alongside anything already in flight.

---

## Roles

| Role | Agent | Responsibilities |
|------|-------|-----------------|
| **Product Owner** | Human | Creates requirements, approves at every gate |
| **Business Analyst** | AI | Turns requirements into user stories with acceptance criteria |
| **Designer** | AI | Produces sprint-level UI instructions from the design system |
| **Technical Lead** | AI | Designs system-level solution, writes TDD, creates feature branches |
| **Developer** | AI | Implements one story per invocation — tests first, then code |
| **QA Engineer** | AI + Human | AI writes test cases from ACs; human verifies on staging |
| **Release Manager** | AI | Closes sprints and hotfixes — verifies readiness, cleans branches, opens release PRs |

---

## Commands

### Product Owner

| Command | What it does |
|---------|-------------|
| `/po create-requirement <description>` | Creates a requirement issue |
| `/po update-requirement <issue> <delta>` | Updates requirement mid-sprint, cascades to stories |
| `/po create-bug [description]` | Creates a production bug issue |

### Business Analyst

| Command | What it does |
|---------|-------------|
| `/ba write-stories <issue>` | Decomposes requirement into user stories + sprint milestone |
| `/ba add-bug-acs <issue>` | Writes acceptance criteria onto a bug issue |
| `/ba sync-stories <issue>` | Re-classifies stories after requirement change |
| `/ba amend-story <issue>` | Amends ACs on a user story |

### Designer

| Command | What it does |
|---------|-------------|
| `/designer write-design <sprint>` | Produces sprint-level design instructions |
| `/designer sync-design <sprint>` | Updates design instructions after story changes |

### Technical Lead

| Command | What it does |
|---------|-------------|
| `/tech-lead write-feature-tdd <sprint>` | Writes TDD + creates feature branches for sprint |
| `/tech-lead sync-feature-tdd <sprint>` | Updates TDD after story changes |
| `/tech-lead create-refactor` | Designs a standalone refactoring task — explores affected codebases, drafts plan, creates `refactoring` issue |

### Developer

| Command | What it does |
|---------|-------------|
| `/dev <issue>` | Implements a story or bug — auto-routes by label (see [Labels](#labels)) |

### QA Engineer

| Command | What it does |
|---------|-------------|
| `/qa write-test-cases <issue>` | Generates test cases from story ACs |
| `/qa sync-test-cases <issue>` | Updates test cases after AC changes |
| `/qa pass <issue>` | Marks story passed — triggers sprint merge |
| `/qa block <issue> <notes>` | Marks story blocked — triggers dev QA-fix cycle |

### Release Manager

| Command | What it does |
|---------|-------------|
| `/release sprint <N>` | Closes sprint, opens release PRs to main |
| `/release hotfix <issue>` | Closes bug issue, deletes fix branch, posts summary |

---

## Workflows

<details>
<summary><strong>Feature Development</strong> — the standard sprint cycle</summary>

Story branches merge to **staging** for QA. Only after QA passes does a story merge to the **sprint branch**. The sprint branch stays clean.

```mermaid
flowchart TD
    A(["/po create-requirement &lt;description&gt;"]) --> B["Requirement Issue\n`requirement`"]
    B --> G1{Gate 1\nPO Review}
    G1 -->|Approve| C(["/ba write-stories &lt;issue&gt;"])
    C --> D["User Stories + Sprint Milestone"]
    D --> G2{Gate 2\nPO Reviews Stories}
    G2 -->|Approve| E1(["/designer write-design &lt;sprint&gt;"])
    E1 --> F1["Design Instructions\n`design`"]
    F1 --> E2(["/tech-lead write-feature-tdd &lt;sprint&gt;"])
    E2 --> F2["TDD + feature branches"]
    F2 --> G3{Gate 3\nPO Reviews TDD + Design}
    G3 -->|Approve| H(["/dev &lt;issue&gt;"])
    H --> I["PR: story → staging\n`implemented`"]
    I --> G4{Gate 4\nCode Review}
    G4 -->|Approved| I2["Merge to staging"]
    I2 --> QA(["/qa write-test-cases &lt;issue&gt;"])
    QA --> QAH["Test cases posted on issue"]
    QAH --> G5{Gate 5\nHuman verifies on staging}
    G5 -->|Pass| QP(["/qa pass &lt;issue&gt;"])
    QP --> QP2["Merge story branch → sprint\n`qa-passed`"]
    QP2 --> MORE{More stories?}
    MORE -->|Yes| H
    MORE -->|No| REL(["/release sprint &lt;N&gt;"])
    G5 -->|Fail| QB(["/qa block &lt;issue&gt; &lt;notes&gt;"])
    QB --> FIX(["/dev &lt;issue&gt;"])
    FIX --> FIX2["Fix pushed to story branch\nMerged to staging"]
    FIX2 --> G5
    REL --> K["Release PRs: sprint → main"]
    K --> G6{Gate 6\nMerge Release PRs}
    G6 -->|Done| L([Sprint Shipped])
```

</details>

<details>
<summary><strong>Production Hotfix</strong> — bugs found in production</summary>

Runs independently of the sprint cycle. Fix PRs target **staging** for QA before merging to `main`.

```mermaid
flowchart TD
    A(["/po create-bug [description]"]) --> B["Bug Issue\n`bug-production`"]
    B --> G1{Gate 1\nPO Reviews Bug}
    G1 -->|Approve| C(["/ba add-bug-acs &lt;issue&gt;"])
    C --> D["Acceptance Criteria\non bug issue"]
    D --> G2{Gate 2\nPO Reviews ACs}
    G2 -->|Approve| H(["/dev &lt;issue&gt;"])
    H --> I["Investigation comment posted\nFix PR → staging\n`implemented`"]
    I --> G3{Gate 3\nCode Review}
    G3 -->|Merged| I2["Merged to staging"]
    I2 --> QA(["/qa write-test-cases &lt;issue&gt;"])
    QA --> QAH["Test cases posted on issue"]
    QAH --> G4{Gate 4\nHuman verifies on staging}
    G4 -->|Pass| QP(["/qa pass &lt;issue&gt;"])
    QP --> QP2["Merge fix branch → main\n`qa-passed`"]
    QP2 --> J(["/release hotfix &lt;issue&gt;"])
    J --> K([Bug Fixed])
    G4 -->|Fail| QB(["/qa block &lt;issue&gt; &lt;notes&gt;"])
    QB --> FIX(["/dev &lt;issue&gt;"])
    FIX --> FIX2["Fix pushed to bug branch\nMerged to staging"]
    FIX2 --> G4
```

</details>

<details>
<summary><strong>Requirements Change</strong> — scope shifts mid-sprint</summary>

Cascades through stories, design, TDD, dev, and QA incrementally.

```mermaid
flowchart TD
    A(["/po update-requirement &lt;N&gt; &lt;delta&gt;"]) --> B["Requirement updated\n`requirement-updated`"]
    B --> C(["/ba sync-stories &lt;N&gt;"])
    C --> D["Change Plan\nCovered / Updatable / New / Removed"]
    D --> G1{Gate 1\nPO Approves Change Plan}
    G1 -->|Approve| E1["Update existing stories"]
    G1 -->|Approve| E2["Create new stories"]
    G1 -->|Approve| E3["Label removed stories\n`story-removed`"]
    E1 & E2 & E3 --> F1(["/designer sync-design &lt;sprint&gt;"])
    F1 --> F2["Design Instructions updated"]
    F2 --> F3(["/tech-lead sync-feature-tdd &lt;sprint&gt;"])
    F3 --> F4["TDD updated"]
    F4 --> H(["/dev &lt;issue&gt; per changed story"])
    H --> QA{Had existing\ntest cases?}
    QA -->|Yes| QAS(["/qa sync-test-cases &lt;issue&gt;"])
    QA -->|No| QAW(["/qa write-test-cases &lt;issue&gt;"])
```

</details>

<details>
<summary><strong>Story Change</strong> — AC-level amendments</summary>

Triggered when a specific story's acceptance criteria need adjusting — not the overall requirement.

```mermaid
flowchart TD
    A(["/ba amend-story &lt;N&gt;"]) --> B["AC Change Plan\nAdded / Removed / Modified"]
    B --> G1{Gate 1\nPO Approves AC Changes}
    G1 -->|Approve| C["Story ACs updated\n`story-updated`"]
    C --> D{UI changes?}
    D -->|Yes| E(["/designer sync-design &lt;sprint&gt;"])
    D -->|No| F{Tech design changes?}
    E --> E2["Design Instructions updated"]
    E2 --> F
    F -->|Yes| G(["/tech-lead sync-feature-tdd &lt;sprint&gt;"])
    F -->|No| H(["/dev &lt;N&gt;"])
    G --> G2["TDD updated"]
    G2 --> H
    H --> I["Story Revisit PR → staging"]
    I --> QA(["/qa sync-test-cases &lt;N&gt; then re-verify"])
```

**When to involve Designer and TL:**

| Change type | Designer | TL |
|-------------|----------|----|
| New UI surface or interaction | Yes | Maybe |
| Changed layout, component, or visual state | Yes | Maybe |
| New API endpoint or data model | No | Yes |
| Changed business logic or backend behaviour | No | Yes |
| UI + backend change together | Yes | Yes |
| Copy/label wording only | No | No |

</details>

<details>
<summary><strong>Refactoring</strong> — tech-debt and structural cleanup</summary>

Standalone tasks initiated by the Tech Lead. No sprint, no QA cycle. Branch from `main`, PR to `main` directly. Definition of Done always includes "all existing tests pass" and "no user-visible behavior change" — that's the safety net in lieu of QA.

```mermaid
flowchart TD
    A(["/tech-lead create-refactor"]) --> B["Discovery Dialog\nproblem · scope · codebases · DoD"]
    B --> C["Codebase Exploration\nparallel per affected codebase"]
    C --> D["Refactoring Issue\n`refactoring`"]
    D --> G1{Gate 1\nHuman Reviews Plan}
    G1 -->|Approve| H(["/dev &lt;issue&gt;"])
    H --> I["Branch from main\n`in-progress`"]
    I --> J["PR: refactor branch → main"]
    J --> G2{Gate 2\nCode Review}
    G2 -->|Approved| K["Merge to main"]
    K --> L([Refactor Shipped])
```

</details>

---

## GitHub is the Source of Truth

There is no external task tracker. No Jira. No Notion. No spreadsheet.

Every work artifact lives in GitHub:

| Artifact | Lives in |
|----------|---------|
| Requirement | GitHub Issue (`requirement`) |
| User stories | GitHub Issues (`user-story`) grouped by Milestone |
| Sprint | GitHub Milestone |
| Design instructions | GitHub Issue (`design`) |
| Technical design (TDD) | GitHub Issue (`technical-design`) |
| Implementation | Pull Request linked to story issue |
| Test cases | Comment on the story issue |
| QA result | Label on the story issue |
| Release | Pull Request (sprint branch → main) |

**GitHub Labels are the workflow engine.** Agents read labels to determine what to do. Humans apply labels (via commands) to advance the workflow. The label on an issue is its current state — and the instruction to every agent that reads it.

---

## Labels

Labels serve two purposes: **artifact type** and **lifecycle state**.

### Artifact Types

These identify what an issue represents. Set once on creation.

| Label | Artifact |
|-------|---------|
| `requirement` | PO-created requirement |
| `user-story` | BA-created user story |
| `technical-design` | Technical design document (TDD) |
| `design` | Sprint-level UI/UX instructions |
| `bug-production` | Production bug reported by PO |
| `refactoring` | Tech-lead initiated refactor task |

### Lifecycle States

These track where a story or bug is in the pipeline. They change as work progresses — and they tell agents what to do next.

| Label | Meaning | What happens next |
|-------|---------|------------------|
| `in-progress` | Dev is currently implementing | — |
| `implemented` | PR merged to staging, awaiting QA | `/qa write-test-cases` |
| `qa-passed` | Human verified all test cases on staging | Human merges branch → sprint |
| `qa-blocked` | One or more test cases failed | `/dev <issue>` → QA Fix mode |
| `story-updated` | ACs changed after implementation | `/dev <issue>` → Story Revisit mode |
| `story-removed` | Story dropped from scope | `/dev <issue>` → Revert mode |
| `requirement-updated` | Requirement changed mid-sprint | `/ba sync-stories` |
| `sprint-completed` | Sprint closed by Release Manager | — |
| `bug-fixed` | Bug closed after hotfix release | — |