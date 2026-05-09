# GitHub-Native Human-Gated AI Workflow

> One control plane, many code planes.

A team of Claude Code agents — one per role, one canonical command each. PO writes requirements, BA decomposes stories, Designer and Tech Lead spec the work, Dev implements, QA verifies, Release ships. Every artifact is a GitHub Issue. Labels move work forward. Humans gate every stage.

## 🤔 Why This Exists

Without a shared playbook, every dev prompts AI differently. Outputs diverge, context resets, and less-experienced users slow the team. This repo collapses the cycle into canonical commands and labelled issues — anyone can advance work by running the next one.

## 🧭 How It Works

- **Orchestrator, not a codebase.** Stories, sprints, designs, and TDDs live here as issues. Agents check out your real code repos (API, web, infra), registered once via `/init`.
- **GitHub is the source of truth.** No Jira, no Notion — every artifact is an issue; state changes by label, not chat.
- **Humans gate every stage.** AI handles volume. Nothing ships without sign-off.
- **Drop-in.** Only `.claude/`, `config.md`, and `DESIGN.md` are added. Existing issues, PRs, and branches stay untouched.

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

> [!IMPORTANT]
> No application code lives here. The orchestrator plans, tracks state, and drives agents — which branch, commit, and open PRs in your real repos.

---

## 🚀 Quick Start

**Prerequisites:** Claude Code CLI, GitHub CLI (`gh`), a GitHub repo with code.

```bash
# 1. Clone this workflow repo
git clone https://github.com/simpscal/notism.git

# 2. Copy the workflow into your existing project
cp -r notism/.claude /path/to/your/project/
```

In your project, run `/init` to:

- Generate `config.md` — registers codebases, detects tech stack, configures migration detection.
- Generate `DESIGN.md` — extracts design tokens and component primitives for Designer and frontend agents.
- Create GitHub labels (`requirement`, `user-story`, `qa-passed`, etc.). Safe to re-run.

Then kick off a sprint:

```
/po create-requirement "Next feature on the backlog"
```

> [!TIP]
> Not sure which command to run? Use `/help-flows` — it asks your intent and prints the exact command to copy-paste.

> [!NOTE]
> Non-disruptive. Only `.claude/`, `config.md`, and `DESIGN.md` are added. Existing issues, PRs, and branches stay untouched.

---

## ⚡ Commands

### 📋 Product Owner

| Command | What it does |
|---------|-------------|
| `/po create-requirement <description>` | Creates a requirement issue |
| `/po update-requirement <issue> <delta>` | Updates requirement mid-sprint, cascades to stories |
| `/po create-bug [description]` | Creates a production bug issue |

### 📝 Business Analyst

| Command | What it does |
|---------|-------------|
| `/ba write-stories <issue>` | Decomposes requirement into user stories + sprint milestone |
| `/ba add-bug-acs <issue>` | Writes acceptance criteria onto a bug issue |
| `/ba sync-stories <issue>` | Re-classifies stories after requirement change |
| `/ba amend-story <issue>` | Amends ACs on a user story |

### 🎨 Designer

| Command | What it does |
|---------|-------------|
| `/designer write-design <sprint>` | Produces sprint-level design instructions |
| `/designer sync-design <sprint>` | Updates design instructions after story changes |

### 🏗️ Technical Lead

| Command | What it does |
|---------|-------------|
| `/tech-lead write-feature-tdd <sprint>` | Writes TDD + creates feature branches for sprint |
| `/tech-lead sync-feature-tdd <sprint>` | Updates TDD after story changes |
| `/tech-lead create-refactor` | Designs a standalone refactoring task — explores affected codebases, drafts plan, creates `refactoring` issue |
| `/tech-lead amend-refactor <issue>` | Revises an existing refactoring issue — re-scopes plan, flags impact on in-progress dev work |

### 💻 Developer

| Command | What it does |
|---------|-------------|
| `/dev <issue>` | Implements a story or bug — auto-routes by label (see [Labels](#labels)) |

### 🧪 QA Engineer

| Command | What it does |
|---------|-------------|
| `/qa write-test-cases <issue>` | Generates test cases from story ACs |
| `/qa sync-test-cases <issue>` | Updates test cases after AC changes |
| `/qa pass <issue>` | Marks story passed — triggers sprint merge |
| `/qa block <issue> <notes>` | Marks story blocked — triggers dev QA-fix cycle |

### 🚢 Release Manager

| Command | What it does |
|---------|-------------|
| `/release sprint <N>` | Closes sprint, opens release PRs to main |
| `/release hotfix <issue>` | Closes bug issue, deletes fix branch, posts summary |

### 🧭 Workflow Picker

| Command | What it does |
|---------|-------------|
| `/help-flows` | Asks intent, prints exact next command to copy-paste |
| `/help-flows <intent>` | Free-text intent (e.g. `i want to fix bug`); resolves to one command |
| `/help-flows all` | Prints full cheat sheet of every stage |

---

## 🔄 Workflows

<details>
<summary><strong>Feature Development</strong> — the standard sprint cycle</summary>

Story branches merge to **staging** for QA, then to the **sprint branch** on pass. Sprint branch stays clean.

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

Independent of sprint cycle. Fix PRs hit **staging** for QA, then `main`.

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

AC adjustments to a single story — not the full requirement.

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

Tech Lead initiated. No sprint, no QA. Branch from `main`, PR to `main`. DoD requires existing tests pass and no user-visible behavior change — the QA substitute.

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

## 📌 GitHub is the Source of Truth

No external tracker. No Jira, no Notion, no spreadsheet. Every artifact lives in GitHub:

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

**Labels are the workflow engine.** Agents read them; humans apply them via commands. A label is the current state and the instruction.

---

## 🏷️ Labels

Two purposes: **artifact type** and **lifecycle state**.

### 📦 Artifact Types

What the issue is. Set once on creation.

| | Label | Artifact |
|---|-------|---------|
| ![](https://placehold.co/15x15/e4e669/e4e669.png) | `requirement` | PO-created requirement |
| ![](https://placehold.co/15x15/c2e0c6/c2e0c6.png) | `user-story` | BA-created user story |
| ![](https://placehold.co/15x15/6f42c1/6f42c1.png) | `technical-design` | Technical design document (TDD) |
| ![](https://placehold.co/15x15/ededed/ededed.png) | `design` | Sprint-level UI/UX instructions |
| ![](https://placehold.co/15x15/d73a4a/d73a4a.png) | `bug-production` | Production bug reported by PO |
| ![](https://placehold.co/15x15/0075ca/0075ca.png) | `refactoring` | Tech-lead initiated refactor task |

### 🔁 Lifecycle States

Where a story or bug sits in the pipeline. Change as work progresses; tell agents what's next.

| | Label | Meaning | What happens next |
|---|-------|---------|------------------|
| ![](https://placehold.co/15x15/d93f0b/d93f0b.png) | `in-progress` | Dev is currently implementing | — |
| ![](https://placehold.co/15x15/0e8a16/0e8a16.png) | `implemented` | PR merged to staging, awaiting QA | `/qa write-test-cases` |
| ![](https://placehold.co/15x15/0e8a16/0e8a16.png) | `qa-passed` | Human verified all test cases on staging | Human merges branch → sprint |
| ![](https://placehold.co/15x15/d73a4a/d73a4a.png) | `qa-blocked` | One or more test cases failed | `/dev <issue>` → QA Fix mode |
| ![](https://placehold.co/15x15/bfd4f2/bfd4f2.png) | `story-updated` | ACs changed after implementation | `/dev <issue>` → Story Revisit mode |
| ![](https://placehold.co/15x15/e4e669/e4e669.png) | `story-removed` | Story dropped from scope | `/dev <issue>` → Revert mode |
| ![](https://placehold.co/15x15/fef2c0/fef2c0.png) | `requirement-updated` | Requirement changed mid-sprint | `/ba sync-stories` |
| ![](https://placehold.co/15x15/006b75/006b75.png) | `sprint-completed` | Sprint closed by Release Manager | — |
| ![](https://placehold.co/15x15/0e8a16/0e8a16.png) | `bug-fixed` | Bug closed after hotfix release | — |