# GitHub-Native Human-Gated AI Workflow

> One control plane, many code planes.

A shared playbook for the whole team — PO, BA, Designer, Tech Lead, Dev, QA, Release Manager. Each role drives the stages it owns. Every artifact is a GitHub Issue. Labels move work forward. Humans gate every stage.

## 🤔 Why This Exists

Without a shared playbook, every team member prompts AI differently. Outputs diverge, context resets, and less-experienced users slow the team. This repo collapses the cycle into a handful of canonical workflows and labelled issues — anyone can advance work by running the next stage.

## 🧭 How It Works

- **Orchestrator, not a codebase.** Stories, sprints, designs, TDDs, and bugs live here as issues. Agents check out your real code repos (API, web, infra), registered once via `/setup init`.
- **GitHub is the source of truth.** No Jira, no Notion — every artifact is an issue; state changes by label, not chat.
- **Workflows organize lifecycle stages, roles run them.** Four workflows (`/feature`, `/hotfix`, `/test`, `/refactor`) cover complete lifecycles. PO triggers requirement/report stages, BA writes stories, Designer authors design instructions, Tech Lead writes TDDs and refactor plans, Dev implements, QA runs `/test`, Release Manager ships. Every stage is one command — the role that owns it runs it.
- **Humans gate every stage.** AI handles volume. Nothing ships without sign-off.
- **Drop-in.** Only `.claude/`, `config.md`, `PRODUCT.md`, and `DESIGN.md` are added. Existing issues, PRs, and branches stay untouched.

```mermaid
flowchart LR
    subgraph ORCH["This Repo · Orchestrator"]
        direction TB
        ISSUES["GitHub Issues · Labels · Milestones<br/>requirements · stories · TDDs<br/>designs · test cases · bugs"]
        FLOWS["Workflow Commands<br/>/feature · /hotfix<br/>/test · /refactor"]
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

In your project, run `/setup init` to:

- Generate `config.md` — registers codebases, detects tech stack, configures migration detection.
- Generate `PRODUCT.md` — captures vision, value proposition, business model, goals, and strategic direction.
- Generate `DESIGN.md` — extracts design tokens and component primitives for frontend work.
- Create GitHub labels (`requirement`, `user-story`, `qa-passed`, etc.). Safe to re-run.

Then kick off a sprint:

```
/feature create-requirement "Next feature on the backlog"
```

> [!TIP]
> Not sure which command to run? Use `/help-flows` — it asks your intent and prints the exact command to copy-paste.

> [!NOTE]
> Non-disruptive. Only `.claude/`, `config.md`, `PRODUCT.md`, and `DESIGN.md` are added. Existing issues, PRs, and branches stay untouched.

---

## ⚡ Commands

Five top-level commands. Each workflow command takes a **stage** that names the action; the **Run by** column below shows which role typically owns it.

### 🆕 `/feature` — Sprint feature lifecycle

Requirement → stories → design → TDD → dev → release. Absorbs mid-sprint requirement changes and single-story AC amendments. Testing handled by `/test`.

| Command | Run by | What it does |
|---------|--------|-------------|
| `/feature create-requirement <description>` | PO | Turn a free-text requirement into a tracker issue. |
| `/feature amend-requirement <req_issue> <delta>` | PO | Revise an existing requirement issue. |
| `/feature create-stories <requirement_issue>` | BA | Break a requirement into user stories under a new sprint milestone. |
| `/feature add-story <requirement_issue>` | BA | Append one extra story to the current sprint. |
| `/feature sync-stories <requirement_issue>` | BA | Reconcile existing stories with an amended requirement. |
| `/feature amend-stories <story_issue>` | BA | Change ACs on a single story. |
| `/feature merge-stories <target> <source...>` | BA | Fold source stories into a target story. |
| `/feature create-design <sprint_number>` | Designer | Author the sprint's design instructions (frontend). |
| `/feature sync-design <sprint_number>` | Designer | Update design instructions after stories changed. |
| `/feature amend-design <story_issue>` | Designer | Revise design for one amended story. |
| `/feature create-tdd <sprint_number>` | Tech Lead | Author the sprint's technical design document. |
| `/feature sync-tdd <sprint_number>` | Tech Lead | Update TDD after stories changed. |
| `/feature amend-tdd <story_issue>` | Tech Lead | Revise TDD for one amended story. |
| `/feature implement <story_issue>` | Dev | Implement a story — fresh, or delta-only when `story-updated`. |
| `/feature revert <story_issue>` | Dev | Undo work for a removed story (`story-removed`). |
| `/feature fix-story <story_issue>` | Dev | Re-implement after QA blocked (`qa-blocked`). |
| `/feature amend-implementation <story_issue>` | Dev | Re-implement after an AC amendment. |
| `/feature release <sprint_number>` | Release Manager | Close sprint and open release PRs to main. |

### 🐛 `/hotfix` — Production bug lifecycle

Faster lane — no design, no TDD; the bug ticket carries ACs and goes straight to fix → release. Testing handled by `/test`.

| Command | Run by | What it does |
|---------|--------|-------------|
| `/hotfix report [description]` | PO | Clarify the bug interactively and open a tracker issue with `bug-production`. |
| `/hotfix acs <bug_issue>` | BA | Analyse the bug and add Acceptance Criteria to the same ticket. |
| `/hotfix implement <bug_issue>` | Dev | Investigate root cause and apply the fix — fresh or delta-only on `story-updated`. |
| `/hotfix fix-bug <bug_issue>` | Dev | Re-fix after QA blocked (`qa-blocked`). |
| `/hotfix release <bug_issue>` | Release Manager | Merge the bugfix PR to main and close the bug. |

### 🧪 `/test` — QA test case lifecycle

Same workflow whether the target is a feature story or a production bug — adapts to the issue's labels.

| Command | Run by | What it does |
|---------|--------|-------------|
| `/test write <issue>` | QA | First-time test cases from the issue's ACs. |
| `/test sync <issue>` | QA | Reconcile test cases after a requirement change. |
| `/test amend <issue>` | QA | Revise cases after a single-story AC amendment. |
| `/test pass <issue>` | QA | Mark `qa-passed` after human verification. |
| `/test block <issue> <notes>` | QA | Mark `qa-blocked` and capture failure notes. |

### 🧹 `/refactor` — Tech-debt and structural cleanup

No sprint, no QA. Branch from `main`, PR to `main`. DoD: existing tests pass, no behaviour change.

| Command | Run by | What it does |
|---------|--------|-------------|
| `/refactor create` | Tech Lead | Survey the codebase, draft a refactor plan, open a `refactoring` issue. |
| `/refactor amend <refactor_issue>` | Tech Lead | Revise an existing refactor plan. |
| `/refactor implement <refactor_issue>` | Dev | Implement the plan — preserves observable behaviour. |

### 🛠 `/setup` — One-off setup (utility)

| Command | Run by | What it does |
|---------|--------|-------------|
| `/setup init` | Project lead | Bootstrap project config — generate `config.md`, `PRODUCT.md`, `DESIGN.md` interactively. |
| `/setup pcd create` | PO | Generate `PRODUCT.md` from scratch. |
| `/setup pcd amend [section]` | PO | Revise one section of `PRODUCT.md` (or all if omitted). |
| `/setup design-system create` | Designer | Generate `DESIGN.md` from the web codebase. |
| `/setup design-system amend` | Designer | Update `DESIGN.md` after design system changes. |

### 🧭 `/help-flows` — Workflow picker (utility)

| Command | What it does |
|---------|-------------|
| `/help-flows` | Asks intent, prints exact next command to copy-paste. |
| `/help-flows <intent>` | Free-text intent (e.g. `i want to fix a bug`); resolves to one command. |
| `/help-flows all` | Prints full cheat sheet of every stage. |

---

## 🔄 Workflows

<details>
<summary><strong>Feature Development</strong> — the standard sprint cycle</summary>

Story branches merge to **staging** for QA, then to the **sprint branch** on pass. Sprint branch stays clean.

```mermaid
flowchart TD
    A(["/feature create-requirement &lt;description&gt;"]) --> B["Requirement Issue\n`requirement`"]
    B --> G1{Gate 1\nPO Review}
    G1 -->|Approve| C(["/feature create-stories &lt;issue&gt;"])
    C --> D["User Stories + Sprint Milestone"]
    D --> G2{Gate 2\nPO Reviews Stories}
    G2 -->|Approve| E1(["/feature create-design &lt;sprint&gt;"])
    E1 --> F1["Design Instructions\n`design`"]
    F1 --> E2(["/feature create-tdd &lt;sprint&gt;"])
    E2 --> F2["TDD + feature branches"]
    F2 --> G3{Gate 3\nPO Reviews TDD + Design}
    G3 -->|Approve| H(["/feature implement &lt;issue&gt;"])
    H --> I["PR: story → staging\n`implemented`"]
    I --> G4{Gate 4\nCode Review}
    G4 -->|Approved| I2["Merge to staging"]
    I2 --> QA(["/test write &lt;issue&gt;"])
    QA --> QAH["Test cases posted on issue"]
    QAH --> G5{Gate 5\nHuman verifies on staging}
    G5 -->|Pass| QP(["/test pass &lt;issue&gt;"])
    QP --> QP2["Merge story branch → sprint\n`qa-passed`"]
    QP2 --> MORE{More stories?}
    MORE -->|Yes| H
    MORE -->|No| REL(["/feature release &lt;N&gt;"])
    G5 -->|Fail| QB(["/test block &lt;issue&gt; &lt;notes&gt;"])
    QB --> FIX(["/feature fix-story &lt;issue&gt;"])
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
    A(["/hotfix report [description]"]) --> B["Bug Issue\n`bug-production`"]
    B --> G1{Gate 1\nPO Reviews Bug}
    G1 -->|Approve| C(["/hotfix acs &lt;issue&gt;"])
    C --> D["Acceptance Criteria\non bug issue"]
    D --> G2{Gate 2\nPO Reviews ACs}
    G2 -->|Approve| H(["/hotfix implement &lt;issue&gt;"])
    H --> I["Investigation comment posted\nFix PR → staging\n`implemented`"]
    I --> G3{Gate 3\nCode Review}
    G3 -->|Merged| I2["Merged to staging"]
    I2 --> QA(["/test write &lt;issue&gt;"])
    QA --> QAH["Test cases posted on issue"]
    QAH --> G4{Gate 4\nHuman verifies on staging}
    G4 -->|Pass| QP(["/test pass &lt;issue&gt;"])
    QP --> QP2["Merge fix branch → main\n`qa-passed`"]
    QP2 --> J(["/hotfix release &lt;issue&gt;"])
    J --> K([Bug Fixed])
    G4 -->|Fail| QB(["/test block &lt;issue&gt; &lt;notes&gt;"])
    QB --> FIX(["/hotfix fix-bug &lt;issue&gt;"])
    FIX --> FIX2["Fix pushed to bug branch\nMerged to staging"]
    FIX2 --> G4
```

</details>

<details>
<summary><strong>Requirements Change</strong> — scope shifts mid-sprint</summary>

Cascades through stories, design, TDD, dev, and QA incrementally. All stages of `/feature` — no separate workflow.

```mermaid
flowchart TD
    A(["/feature amend-requirement &lt;N&gt; &lt;delta&gt;"]) --> B["Requirement updated\n`requirement-updated`"]
    B --> C(["/feature sync-stories &lt;N&gt;"])
    C --> D["Change Plan\nCovered / Updatable / New / Removed"]
    D --> G1{Gate 1\nPO Approves Change Plan}
    G1 -->|Approve| E1["Update existing stories"]
    G1 -->|Approve| E2["Create new stories"]
    G1 -->|Approve| E3["Label removed stories\n`story-removed`"]
    E1 & E2 & E3 --> F1(["/feature sync-design &lt;sprint&gt;"])
    F1 --> F2["Design Instructions updated"]
    F2 --> F3(["/feature sync-tdd &lt;sprint&gt;"])
    F3 --> F4["TDD updated"]
    F4 --> H(["/feature implement &lt;issue&gt; (changed)\n/feature revert &lt;issue&gt; (removed)"])
    H --> QA{Had existing\ntest cases?}
    QA -->|Yes| QAS(["/test sync &lt;issue&gt;"])
    QA -->|No| QAW(["/test write &lt;issue&gt;"])
```

</details>

<details>
<summary><strong>Story Change</strong> — AC-level amendments</summary>

AC adjustments to a single story — not the full requirement. Still stages of `/feature`.

```mermaid
flowchart TD
    A(["/feature amend-stories &lt;N&gt;"]) --> B["AC Change Plan\nAdded / Removed / Modified"]
    B --> G1{Gate 1\nPO Approves AC Changes}
    G1 -->|Approve| C["Story ACs updated\n`story-updated`"]
    C --> D{UI changes?}
    D -->|Yes| E(["/feature amend-design &lt;N&gt;"])
    D -->|No| F{Tech design changes?}
    E --> E2["Design Instructions updated"]
    E2 --> F
    F -->|Yes| G(["/feature amend-tdd &lt;N&gt;"])
    F -->|No| H(["/feature amend-implementation &lt;N&gt;"])
    G --> G2["TDD updated"]
    G2 --> H
    H --> I["Story Revisit PR → staging"]
    I --> QA(["/test amend &lt;N&gt; then re-verify"])
```

**When to amend design and TDD:**

| Change type | Design | TDD |
|-------------|--------|-----|
| New UI surface or interaction | Yes | Maybe |
| Changed layout, component, or visual state | Yes | Maybe |
| New API endpoint or data model | No | Yes |
| Changed business logic or backend behaviour | No | Yes |
| UI + backend change together | Yes | Yes |
| Copy/label wording only | No | No |

</details>

<details>
<summary><strong>Refactoring</strong> — tech-debt and structural cleanup</summary>

No sprint, no QA. Branch from `main`, PR to `main`. DoD requires existing tests pass and no user-visible behavior change — the QA substitute.

```mermaid
flowchart TD
    A(["/refactor create"]) --> B["Discovery Dialog\nproblem · scope · codebases · DoD"]
    B --> C["Codebase Exploration\nparallel per affected codebase"]
    C --> D["Refactoring Issue\n`refactoring`"]
    D --> G1{Gate 1\nHuman Reviews Plan}
    G1 -->|Approve| H(["/refactor implement &lt;issue&gt;"])
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

**Labels are the workflow engine.** Workflow commands read them; humans apply them by running the next stage. A label is the current state and the instruction.

---

## 🏷️ Labels

Two purposes: **artifact type** and **lifecycle state**.

### 📦 Artifact Types

What the issue is. Set once on creation.

| | Label | Artifact |
|---|-------|---------|
| ![](https://placehold.co/15x15/e4e669/e4e669.png) | `requirement` | PO requirement created via `/feature create-requirement` |
| ![](https://placehold.co/15x15/c2e0c6/c2e0c6.png) | `user-story` | Story created via `/feature create-stories` or `add` |
| ![](https://placehold.co/15x15/6f42c1/6f42c1.png) | `technical-design` | TDD created via `/feature create-tdd` |
| ![](https://placehold.co/15x15/ededed/ededed.png) | `design` | Sprint-level UI/UX instructions via `/feature create-design` |
| ![](https://placehold.co/15x15/d73a4a/d73a4a.png) | `bug-production` | Production bug reported via `/hotfix report` |
| ![](https://placehold.co/15x15/0075ca/0075ca.png) | `refactoring` | Refactor plan created via `/refactor create` |

### 🔁 Lifecycle States

Where a story or bug sits in the pipeline. Change as work progresses; tell agents what's next.

| | Label | Meaning | What happens next |
|---|-------|---------|------------------|
| ![](https://placehold.co/15x15/d93f0b/d93f0b.png) | `in-progress` | Dev is currently implementing | — |
| ![](https://placehold.co/15x15/0e8a16/0e8a16.png) | `implemented` | PR merged to staging, awaiting QA | `/test write` |
| ![](https://placehold.co/15x15/0e8a16/0e8a16.png) | `qa-passed` | Human verified all test cases on staging | Human merges branch → sprint |
| ![](https://placehold.co/15x15/d73a4a/d73a4a.png) | `qa-blocked` | One or more test cases failed | `/feature fix-story` or `/hotfix fix-bug` |
| ![](https://placehold.co/15x15/bfd4f2/bfd4f2.png) | `story-updated` | ACs changed after implementation | `/feature implement` (revisit branch) |
| ![](https://placehold.co/15x15/e4e669/e4e669.png) | `story-removed` | Story dropped from scope | `/feature revert` |
| ![](https://placehold.co/15x15/fef2c0/fef2c0.png) | `requirement-updated` | Requirement changed mid-sprint | `/feature sync-stories` |
| ![](https://placehold.co/15x15/006b75/006b75.png) | `sprint-completed` | Sprint closed by `/feature release` | — |
| ![](https://placehold.co/15x15/0e8a16/0e8a16.png) | `bug-fixed` | Bug closed after `/hotfix release` | — |
