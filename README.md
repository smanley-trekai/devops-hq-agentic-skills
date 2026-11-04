<p align="center">
  <a href="https://agenticskills.io">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="assets/agenticskills-logotype-light.svg">
      <img src="assets/agenticskills-logotype.svg" alt="AgenticSkills" width="360">
    </picture>
  </a>
</p>

<h1 align="center">DevOps HQ: Agentic Skills</h1>

<p align="center">
  <b>The agent skills and tools the TrekAI DevOps team uses every day.</b><br>
  <sub>Terraform · Codebase knowledge graphs · Browser automation · Miro diagrams · GitHub PRs &amp; CI</sub>
</p>

<p align="center">
  <img src="assets/icons/terraform.svg" height="48" alt="Terraform">&nbsp;&nbsp;&nbsp;<img src="assets/icons/graphify.svg" height="48" alt="Graphify">&nbsp;&nbsp;&nbsp;<img src="assets/icons/browseros-neo.png" height="48" alt="BrowserOS neo">&nbsp;&nbsp;&nbsp;<img src="assets/icons/miro.png" height="48" alt="Miro">&nbsp;&nbsp;&nbsp;<picture><source media="(prefers-color-scheme: dark)" srcset="assets/icons/github-light.svg"><img src="assets/icons/github.svg" height="48" alt="GitHub"></picture>
</p>

---

> [!IMPORTANT]
> **Used in TrekAI.** This is the skill stack TrekAI's DevOps team runs with its AI coding agents (Claude Code, Codex, Cursor) for infrastructure work. Each entry below is installed and in use on our machines today. This repo is the place to look before you add something new, and it gets new engineers set up quickly.

## Contents

- [The stack at a glance](#the-stack-at-a-glance)
- [Why use these instead of a default agent setup](#why-use-these-instead-of-a-default-agent-setup)
- [Prerequisites](#prerequisites): tools each skill needs
- [Setup](#setup)
  - [Quick install (all at once)](#quick-install-all-at-once)
  - [1. Terraform Skill](#1-terraform-skill-anton-babenko)
  - [2. Terraform Code Generation](#2-terraform-code-generation-hashicorp)
  - [3. Terraform Module Generation](#3-terraform-module-generation-hashicorp)
  - [4. Graphify](#4-graphify)
  - [5. BrowserOS neo](#5-browseros-neo)
  - [6. Miro AI](#6-miro-ai)
  - [7. GH Fix CI](#7-gh-fix-ci-openai)
  - [8. GH Address Comments](#8-gh-address-comments-openai)
  - [9. GitHub MCP Server](#9-github-mcp-server)
- [How to use them together](#how-to-use-them-together)
- [Verify your setup](#verify-your-setup)
- [Updating and removing](#updating-and-removing)

## The stack at a glance

| # | | Skill / Tool | Type | What it does for us | Source |
|---|---|---|---|---|---|
| 1 | <img src="assets/icons/terraform.svg" width="20" align="center" alt="Terraform"> | **Terraform Skill** | Agent skill | Finds the cause of Terraform and OpenTofu problems first, then gives a fix with validation steps and rollback notes. Enforces safe `plan`/`apply`/`destroy` habits. | [agenticskills.io](https://agenticskills.io/skills/terraform-skill) · [antonbabenko/terraform-skill](https://github.com/antonbabenko/terraform-skill) |
| 2 | <img src="assets/icons/terraform.svg" width="20" align="center" alt="Terraform"> | **Terraform Code Generation** | Agent skill | Writes HCL that follows HashiCorp's official style guide: file layout, naming, typed variables, pinned versions, `fmt` and `validate`. | [agenticskills.io](https://agenticskills.io/skills/terraform-code-generation) · [hashicorp/agent-skills](https://github.com/hashicorp/agent-skills/tree/main/plugins/terraform/skills/terraform-style-guide) |
| 3 | <img src="assets/icons/terraform.svg" width="20" align="center" alt="Terraform"> | **Terraform Module Generation** | Agent skill | Splits large configurations into reusable modules and migrates state safely with `moved` blocks. | [agenticskills.io](https://agenticskills.io/skills/terraform-module-generation) · [hashicorp/agent-skills](https://github.com/hashicorp/agent-skills/tree/main/plugins/terraform/skills/refactor-module) |
| 4 | <img src="assets/icons/graphify.svg" width="20" align="center" alt="Graphify"> | **Graphify** | Skill + CLI | Maps a whole repo (code, docs, configs, schemas, PDFs) into a knowledge graph. The agent queries the graph instead of grepping through files. | [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) |
| 5 | <img src="assets/icons/browseros-neo.png" width="20" align="center" alt="BrowserOS neo"> | **BrowserOS neo** | Agentic browser (MCP) | A separate local browser for agents, already signed into your accounts. Agents can work in cloud consoles, dashboards and internal tools. | [browseros-ai/BrowserOS](https://github.com/browseros-ai/BrowserOS) |
| 6 | <img src="assets/icons/miro.png" width="20" align="center" alt="Miro"> | **Miro AI** | Plugin + MCP + skills | Lets the agent read and write Miro boards: architecture diagrams, runbooks, specs and code reviews on a board. | [miroapp/miro-ai](https://github.com/miroapp/miro-ai) |
| 7 | <picture><source media="(prefers-color-scheme: dark)" srcset="assets/icons/github-light.svg"><img src="assets/icons/github.svg" width="20" align="center" alt="GitHub"></picture> | **GH Fix CI** | Agent skill | Finds failing GitHub Actions checks on a PR, reads the logs, and proposes a fix for approval before changing anything. | [agenticskills.io](https://agenticskills.io/skills/gh-fix-ci) · [openai/skills](https://github.com/openai/skills/tree/main/skills/.curated/gh-fix-ci) |
| 8 | <picture><source media="(prefers-color-scheme: dark)" srcset="assets/icons/github-light.svg"><img src="assets/icons/github.svg" width="20" align="center" alt="GitHub"></picture> | **GH Address Comments** | Agent skill | Pulls the review comments on the current branch's PR, lists them, and fixes only the ones you pick. | [agenticskills.io](https://agenticskills.io/skills/gh-address-comments) · [openai/skills](https://github.com/openai/skills/tree/main/skills/.curated/gh-address-comments) |
| 9 | <picture><source media="(prefers-color-scheme: dark)" srcset="assets/icons/github-light.svg"><img src="assets/icons/github.svg" width="20" align="center" alt="GitHub"></picture> | **GitHub MCP Server** | MCP server (official) | Gives the agent structured access to GitHub repos, issues, PRs, Actions, code search and security alerts. | [github/github-mcp-server](https://github.com/github/github-mcp-server) |

## Why use these instead of a default agent setup

A fresh Claude Code, Codex or Cursor install is a capable generalist. But it only knows the code you point it at, it has no browser with your logins, and its Terraform knowledge comes from training data. That data mixes good and bad patterns from many years and versions. These skills and tools fill those gaps.

### Gaps in the default setup, and how each tool fills them

| Default agent behavior | Problem for DevOps work | What fixes it |
|---|---|---|
| Writes Terraform from general knowledge | Inconsistent file layout, `count` where `for_each` belongs, unpinned providers, untyped variables, missing descriptions | **Terraform Code Generation** applies HashiCorp's own style guide every time |
| Jumps straight to a fix | Fixes the symptom (for example, re-creating a resource) instead of the cause (identity churn, drift, a leaked secret) | **Terraform Skill** finds the cause first and loads only the reference material that matches the failure |
| Will happily suggest `terraform apply` or `destroy` | Real risk of destroying production resources or replacing them by accident | **Terraform Skill** requires a reviewed plan before applying to production, and a `plan -destroy` review before any destroy |
| Refactors by moving code between files | Resource addresses change, so Terraform **destroys and re-creates** them | **Terraform Module Generation** writes `moved` blocks or `state mv` steps and checks for a clean `plan` |
| Finds code by grepping and reading files | Burns tokens and context on large monorepos. Misses links between files (module → variable → pipeline) | **Graphify** builds a local AST knowledge graph once. The agent then queries `graph.json` for paths, dependencies and explanations |
| Has no memory of the repo between sessions | Re-learns the same architecture in every conversation | **Graphify** keeps `graphify-out/` (`GRAPH_REPORT.md`, `graph.json`) for any session to use |
| Has no browser, or a headless one with no logins | Can't check AWS, GCP or Azure consoles, CI dashboards, Grafana, or vendor portals that have no API or CLI | **BrowserOS neo** gives the agent a real local browser with your imported logins, plus session replay for auditing |
| Describes architecture in text only | Diagrams and runbooks live in Miro, not in the repo, so the agent can't see or update them | **Miro AI** reads boards for context and writes diagrams, docs and tables back to them |
| Runs `gh` commands one at a time when CI fails | Reads the wrong log, misses the failing step, or "fixes" a test without asking | **GH Fix CI** collects every failing check with its run URL and log snippet, then waits for your approval before changing code |
| Handles PR feedback from a pasted comment | Misses threads, or changes code nobody asked it to change | **GH Address Comments** fetches every review thread, numbers them, and fixes only the ones you pick |
| Only knows GitHub through the `gh` CLI | Each lookup is a separate shell command and text parse, and some data (security alerts, cross-repo search) is awkward to reach | **GitHub MCP Server** exposes GitHub as typed tools: issues, PRs, Actions, code search, Dependabot and code-scanning alerts |
| One-off prompting conventions per engineer | Every engineer gets different output | Shared, versioned skills in this repo give the **same standards across the team** and across agents (Claude, Codex, Cursor) |

### In short

- **Safer infrastructure changes.** The skills include guardrails for `apply` and `destroy`, rollback notes, and state-safe refactors.
- **Consistent code.** Every engineer's agent writes Terraform the same way, so reviews are faster.
- **Fewer tokens, better answers.** The graph lookups in Graphify replace repeated file reads.
- **Agents reach where DevOps work happens.** That includes cloud consoles and dashboards (BrowserOS) architecture boards (Miro), and GitHub PRs and CI (GitHub skills and MCP), not only the terminal.
- **Works across agents.** Most of these work with Claude Code, Codex, Cursor and Gemini CLI, so switching agents doesn't mean starting over.

### Trade-offs to know about

- Skills load extra instructions into context. Install only the ones you use.
- Third-party skills change upstream. Read the `SKILL.md` after each update (see [Updating](#updating-and-removing)).
- BrowserOS neo uses your **real logged-in sessions**. Treat it as privileged access, keep production consoles read-only unless a task needs more, and use session replay to review what the agent did.
- Miro MCP gets OAuth access to the boards you grant. Grant only the boards you need.
- The GitHub MCP Server acts with your token's permissions. Use a fine-grained PAT limited to the repos and scopes you need, and never commit it.
- Graphify's code parsing is fully local. Its semantic pass over docs, PDFs and media uses your assistant's model or a configured API key.

## Prerequisites

Skills are instructions, not programs. A skill tells your agent *which* tools to run, so those tools must already be installed on your machine. Otherwise the agent stops or guesses.

- **Required:** the skill can't do its job without it.
- **Recommended:** the skill calls it when it's present (linting, scanning, tests), and you get better results.

Run `./scripts/install.sh check` to see what's missing on your machine.

### Common to all

| Tool | Why | Install (macOS) |
|---|---|---|
| An AI coding agent | Runs the skills | Claude Code, Codex, Cursor, Gemini CLI… |
| Node.js 18+ (`npx`) | Skills CLI that installs skills 1–3 and 7–8, plus the optional Miro skills | `brew install node` |
| Git | Every repo workflow | `xcode-select --install` or `brew install git` |

### 1. Terraform Skill

| Tool | Status | Why | Install (macOS) |
|---|---|---|---|
| `terraform` **or** `tofu` | **Required** | `fmt`, `validate`, `plan`, `test`, state commands | `brew tap hashicorp/tap && brew install hashicorp/tap/terraform` or `brew install opentofu` |
| `tflint` | Recommended | Lint step in its pre-commit validation flow | `brew install tflint` |
| `trivy` | Recommended | `trivy config .` security scan | `brew install trivy` |
| `checkov` | Recommended | `checkov -d .` policy and compliance scan | `brew install checkov` |
| `pre-commit` | Optional | Runs fmt, validate, lint and scan on every commit | `brew install pre-commit` |
| Go | Optional | Only for Terratest integration tests | `brew install go` |
| Cloud CLI + credentials (`aws`, `gcloud`, `az`) | Required for `plan`/`apply` against real infra | Provider authentication | `brew install awscli` · `brew install --cask google-cloud-sdk` · `brew install azure-cli` |

> Version guide: Terraform **1.6+** (or any OpenTofu) for native `terraform test`, and **1.10+** for S3 native state locking (`use_lockfile`). The skill checks your version before using version-gated features.

### 2. Terraform Code Generation

| Tool | Status | Why | Install (macOS) |
|---|---|---|---|
| `terraform` **or** `tofu` | **Required** | Runs `terraform fmt` and `terraform validate` on what it generates | see above |
| `tflint` | Recommended | Linting and best practices | `brew install tflint` |
| `checkov` or `trivy` | Recommended | Security scanning (the skill also mentions `tfsec`, which is now part of `trivy`) | `brew install checkov` / `brew install trivy` |

### 3. Terraform Module Generation

| Tool | Status | Why | Install (macOS) |
|---|---|---|---|
| `terraform` **or** `tofu` | **Required** | `state list`, `show -json`, `plan`, `test`, `moved` blocks | see above |
| `jq` | **Required** | Reads `terraform show -json` while mapping state | `brew install jq` |
| Initialized backend + credentials | **Required** | `terraform init` must succeed so state can be inspected and migrated | your backend and cloud CLI |

> Version guide: `moved` blocks need Terraform **1.1+**. `.tftest.hcl` tests need **1.6+**, and mock providers need **1.7+**. The module README template the skill generates requires **>= 1.5**.

### 4. Graphify

| Tool | Status | Why | Install (macOS) |
|---|---|---|---|
| Python **3.10+** | **Required** | Graphify is a Python CLI | `brew install python` |
| `uv` (or `pipx`) | **Required** | Installs the `graphifyy` package as a standalone tool | `brew install uv` |
| Model access | Optional | Only for the semantic pass over docs, PDFs, images and video. Uses your assistant's model or a configured API key. Code parsing needs none. | — |

### 5. BrowserOS neo

| Tool | Status | Why | Install (macOS) |
|---|---|---|---|
| BrowserOS neo app | **Required** | The browser the agent drives | `brew tap browseros-ai/tap && brew install --cask browseros-neo` |
| An MCP-capable agent | **Required** | Connects to BrowserOS over MCP on `127.0.0.1` | Claude Code, Codex, Cursor, VS Code… |
| Google Chrome | Optional | Source for the one-click import of logins, bookmarks and extensions | — |

### 6. Miro AI

| Tool | Status | Why | Install |
|---|---|---|---|
| A Miro account | **Required** | OAuth access to your boards | [miro.com](https://miro.com) |
| Claude Code, Gemini CLI, or any MCP client | **Required** | Hosts the plugin, extension or MCP server | — |
| A web browser | **Required** | Completes the Miro OAuth login the first time | — |

### 7. GH Fix CI

| Tool | Status | Why | Install (macOS) |
|---|---|---|---|
| GitHub CLI (`gh`) | **Required** | Reads PR checks and GitHub Actions logs | `brew install gh` |
| `gh` login with `repo` + `workflow` scopes | **Required** | Access to checks and workflow logs | `gh auth login` (then `gh auth status`) |
| Python 3 | **Required** | Runs the skill's `scripts/inspect_pr_checks.py` | `brew install python` |

> The skill runs `python …`. macOS ships only `python3`, so if the agent reports `python: command not found`, it should use `python3`. You can also add `alias python=python3` to your shell profile.

### 8. GH Address Comments

| Tool | Status | Why | Install (macOS) |
|---|---|---|---|
| GitHub CLI (`gh`) | **Required** | Fetches PR comments and review threads | `brew install gh` |
| `gh` login with `repo` scope | **Required** | Read access to PR review threads | `gh auth login` |
| Python 3 | **Required** | Runs the skill's `scripts/fetch_comments.py` | `brew install python` |
| An open PR for your current branch | **Required** | The skill works on the PR linked to the checked-out branch | `gh pr create` |

### 9. GitHub MCP Server

| Tool | Status | Why | Install |
|---|---|---|---|
| GitHub personal access token | **Required** | Authenticates the remote server (use a fine-grained token) | [Create a PAT](https://github.com/settings/personal-access-tokens/new) |
| An MCP client with remote HTTP support | **Required** | Connects to `https://api.githubcopilot.com/mcp` | Claude Code 2.1.1+ for `claude mcp add-json` |
| Docker | Optional | Only for the local, self-hosted server (for example, GitHub Enterprise Server) | `brew install --cask docker` |

### Install everything at once (macOS)

```bash
brew tap hashicorp/tap
brew install node git gh jq uv python hashicorp/tap/terraform tflint trivy checkov pre-commit
gh auth login   # choose the repo and workflow scopes
```

## Setup

### Quick install (all at once)

The [`scripts/install.sh`](scripts/install.sh) script installs the three Terraform skills, the two GitHub skills, Graphify and BrowserOS neo. It then prints the Miro and GitHub MCP steps, which need your Claude Code session or a token.

```bash
git clone https://github.com/smanley-trekai/devops-hq-agentic-skills.git
cd devops-hq-agentic-skills
./scripts/install.sh            # everything
./scripts/install.sh terraform  # only the Terraform skills
./scripts/install.sh graphify   # only Graphify
./scripts/install.sh browseros  # only BrowserOS neo (macOS)
./scripts/install.sh github     # only the GitHub skills (+ GitHub MCP instructions)
```

Or install each one by hand, as shown below.

---

<a id="1-terraform-skill-anton-babenko"></a>

### <img src="assets/icons/terraform.svg" width="28" align="center" alt="Terraform"> 1. Terraform Skill (Anton Babenko)

Diagnosis-first guidance for Terraform and OpenTofu, with safety rules for production.

**Install**

```bash
# Option A: skills CLI (Claude Code, Codex, Cursor, …)
npx skills add antonbabenko/terraform-skill@terraform-skill

# Option B: manual (Claude Code)
mkdir -p ~/.claude/skills/terraform-skill
curl -o ~/.claude/skills/terraform-skill/SKILL.md \
  https://raw.githubusercontent.com/antonbabenko/terraform-skill/master/skills/terraform-skill/SKILL.md
```

**Use**

The skill loads automatically when you ask about Terraform or OpenTofu. Example prompts:

```text
Our plan wants to replace every aws_instance after we switched from count to for_each. Fix it without recreating anything.
Why does CI show drift on the prod state but not locally?
Destroy the old staging RDS instance.   # → the skill asks for a `terraform plan -destroy` review first
```

Each answer ends with **assumptions, a validation plan, and rollback notes**.

---

<a id="2-terraform-code-generation-hashicorp"></a>

### <img src="assets/icons/terraform.svg" width="28" align="center" alt="Terraform"> 2. Terraform Code Generation (HashiCorp)

HashiCorp's official Terraform style guide as a skill. Its `SKILL.md` is titled *Terraform Style Guide*.

**Install**

```bash
# Option A: skills CLI
npx skills add hashicorp/agent-skills@terraform-style-guide

# Option B: manual (Claude Code)
mkdir -p ~/.claude/skills/terraform-code-generation
curl -o ~/.claude/skills/terraform-code-generation/SKILL.md \
  https://raw.githubusercontent.com/hashicorp/agent-skills/main/plugins/terraform/skills/terraform-style-guide/SKILL.md
```

**Use**

```text
Create a Terraform config for an AWS VPC with dev/staging/prod environments and common tags.
Review ./infra against the HashiCorp style guide and flag missing descriptions or unpinned providers.
```

The output follows the standard layout (`terraform.tf`, `providers.tf`, `main.tf`, `variables.tf`, `outputs.tf`, `locals.tf`). Then the skill runs `terraform fmt` and `terraform validate`, and suggests `tflint`, `checkov` or `tfsec`.

---

<a id="3-terraform-module-generation-hashicorp"></a>

### <img src="assets/icons/terraform.svg" width="28" align="center" alt="Terraform"> 3. Terraform Module Generation (HashiCorp)

Turns a large Terraform configuration into reusable modules without recreating resources.

**Install**

```bash
# Option A: skills CLI
npx skills add hashicorp/agent-skills@refactor-module

# Option B: manual (Claude Code)
mkdir -p ~/.claude/skills/terraform-module-generation
curl -o ~/.claude/skills/terraform-module-generation/SKILL.md \
  https://raw.githubusercontent.com/hashicorp/agent-skills/main/plugins/terraform/skills/refactor-module/SKILL.md
```

**Use**

```text
Refactor ./infra/network into a module named vpc. Preserve state, intermediate abstraction level.
```

| Input | Required | Values |
|---|---|---|
| `source_directory` | yes | Path to the existing config |
| `module_name` | yes | Name of the new module |
| `preserve_state` | yes | `true` / `false` |
| `abstraction_level` | no | `simple`, `intermediate` (default), `advanced` |
| `target_registry` | no | `local`, `private`, `public` |

The skill produces `moved` blocks such as the one below, a module README and `.tftest.hcl` tests. **Always confirm that `terraform plan` shows no unexpected changes before you apply.**

```hcl
moved {
  from = aws_vpc.main
  to   = module.vpc.aws_vpc.main
}
```

---

<a id="4-graphify"></a>

### <img src="assets/icons/graphify.svg" width="28" align="center" alt="Graphify"> 4. Graphify

Turns any codebase, with its docs, SQL schemas, configs and PDFs, into a queryable knowledge graph. Code parsing is local and uses tree-sitter AST, with no vector store.

**Install**

```bash
uv tool install graphifyy      # note the double "y" (or: pipx install graphifyy)
graphify install               # detects your assistant(s) and registers the /graphify skill
```

**Use**

In your agent, from the repo root:

```text
/graphify .
```

This creates the following files:

```text
graphify-out/
├── graph.html       # interactive graph; open in a browser
├── GRAPH_REPORT.md  # key concepts, surprising connections, suggested questions
└── graph.json       # full graph; agents query this instead of re-reading files
```

Query the graph from your terminal, or let the agent do it:

```bash
graphify explain "aws_eks_cluster"
graphify path "vpc" "eks"
graphify query "which pipelines deploy the payments service?"
```

> **Tip:** Add `graphify-out/` to `.gitignore` in application repos, or commit `GRAPH_REPORT.md` if you want the summary to persist for the team. Rebuild with `/graphify .` after large refactors.

Docs: [docs.graphify.com](https://docs.graphify.com)

---

<a id="5-browseros-neo"></a>

### <img src="assets/icons/browseros-neo.png" width="28" align="center" alt="BrowserOS neo"> 5. BrowserOS neo

A second, local Chromium-based browser just for your AI agents. It connects over MCP to Claude Code, Codex, Cursor, VS Code and others.

**Install**

```bash
# macOS
brew tap browseros-ai/tap
brew install --cask browseros-neo
```

Windows and Linux: download from [browseros.com](https://www.browseros.com), or get the [Windows](https://cdn.browseros.com/download/BrowserOS_neo_installer.exe), [AppImage](https://cdn.browseros.com/download/BrowserOS_neo.AppImage) or [DEB](https://cdn.browseros.com/download/BrowserOS_neo.deb) build.

**Set up**

1. Open BrowserOS neo and **import from Chrome** (logins, bookmarks, extensions) in one click.
2. In the MCP connect board, **connect your agent** (Claude Code, Codex, Cursor, …) in one click.
3. Restart your agent so it picks up the new MCP server.

**Use**

Give the task to your agent, not to the browser:

```text
Open the AWS console and list any CloudWatch alarms in ALARM state in us-east-1.
Check the latest GitHub Actions run for the infra repo and summarize why it failed.
Pull last week's p95 latency for the API from Grafana.
```

Watch the agent work live in its own tab, or replay the session later. All session data stays local under `~/.browserclaw/`.

Docs: [docs.browseros.com](https://docs.browseros.com)

---

<a id="6-miro-ai"></a>

### <img src="assets/icons/miro.png" width="28" align="center" alt="Miro"> 6. Miro AI

The official Miro plugin, skills and MCP server. They let agents read and write your Miro boards.

**Install**

Claude Code (recommended). Run these inside Claude Code:

```text
/plugin marketplace add miroapp/miro-ai
/plugin install miro@miro-ai
```

Restart Claude Code afterward. The plugin bundles the `browse`, `code-review`, `code-spec`, `code-explain-on-board`, `diagram`, `doc`, `format` and `table` skills, plus the MCP server.

<details>
<summary>Other agents</summary>

```bash
# Gemini CLI
gemini extensions install https://github.com/miroapp/miro-ai

# Portable skills only (Codex, Cursor, Copilot, …)
npx skills add miroapp/miro-ai
```

For any other MCP client, add this to its MCP config:

```json
{
  "mcpServers": {
    "miro": { "url": "https://mcp.miro.com/" }
  }
}
```

</details>

**Authenticate:** the first time you run a Miro command, a browser window opens for Miro OAuth. Log in and grant access to the boards the agent needs.

**Use**

```text
Summarize the architecture diagram on https://miro.com/app/board/<board-id>
Create a diagram on Miro of our CI/CD pipeline from .github/workflows.
Turn this incident runbook into a Miro doc on the SRE board.
```

Docs: [developers.miro.com/docs/mcp-intro](https://developers.miro.com/docs/mcp-intro)

---

<a id="7-gh-fix-ci-openai"></a>

### <picture><source media="(prefers-color-scheme: dark)" srcset="assets/icons/github-light.svg"><img src="assets/icons/github.svg" width="28" align="center" alt="GitHub"></picture> 7. GH Fix CI (OpenAI)

Debugs failing GitHub Actions checks on a pull request using the `gh` CLI.

**Install**

```bash
# Option A: skills CLI
npx skills add openai/skills@gh-fix-ci

# Option B: manual (Claude Code)
mkdir -p ~/.claude/skills/gh-fix-ci
curl -o ~/.claude/skills/gh-fix-ci/SKILL.md \
  https://raw.githubusercontent.com/openai/skills/main/skills/.curated/gh-fix-ci/SKILL.md
```

> The manual option installs only `SKILL.md`. The skill also ships a helper script (`scripts/inspect_pr_checks.py`), so prefer the skills CLI.

**Set up:** run `gh auth login` and grant the `repo` and `workflow` scopes.

**Use**

From a branch with an open PR:

```text
CI is failing on my PR. Find out why and propose a fix.
```

The skill lists each failing check with its name, run URL and a log snippet. Checks that don't run on GitHub Actions are marked as external, with a link only. It drafts a fix plan and **waits for your approval** before changing code, then suggests re-running the tests and `gh pr checks`.

---

<a id="8-gh-address-comments-openai"></a>

### <picture><source media="(prefers-color-scheme: dark)" srcset="assets/icons/github-light.svg"><img src="assets/icons/github.svg" width="28" align="center" alt="GitHub"></picture> 8. GH Address Comments (OpenAI)

Works through review and issue comments on the open PR for your current branch.

**Install**

```bash
# Option A: skills CLI
npx skills add openai/skills@gh-address-comments

# Option B: manual (Claude Code)
mkdir -p ~/.claude/skills/gh-address-comments
curl -o ~/.claude/skills/gh-address-comments/SKILL.md \
  https://raw.githubusercontent.com/openai/skills/main/skills/.curated/gh-address-comments/SKILL.md
```

> As with GH Fix CI, prefer the skills CLI, because the skill ships a helper script (`scripts/fetch_comments.py`).

**Set up:** run `gh auth login`.

**Use**

```text
Address the review comments on my PR.
```

The skill fetches every comment and review thread, numbers them with a short summary of each fix, and asks which ones to address. It changes code **only for the comments you pick**.

---

<a id="9-github-mcp-server"></a>

### <picture><source media="(prefers-color-scheme: dark)" srcset="assets/icons/github-light.svg"><img src="assets/icons/github.svg" width="28" align="center" alt="GitHub"></picture> 9. GitHub MCP Server

GitHub's official MCP server. It gives the agent typed tools for repos, issues, pull requests, Actions, code search, and Dependabot and code-scanning alerts. We use the remote server that GitHub hosts, so there's nothing to run locally.

**Install (Claude Code)**

1. [Create a fine-grained personal access token](https://github.com/settings/personal-access-tokens/new) that covers only the repos and permissions you need.
2. Run this in your terminal (not inside Claude Code), without pasting the token into the command:

```bash
read -rs GITHUB_PAT   # paste the token, then press Enter
claude mcp add-json github --scope user \
  '{"type":"http","url":"https://api.githubcopilot.com/mcp","headers":{"Authorization":"Bearer '"$GITHUB_PAT"'"}}'
unset GITHUB_PAT
```

3. Restart Claude Code and check that `github` appears in `/mcp`.

<details>
<summary>Other agents</summary>

Most MCP clients (Cursor, VS Code, Windsurf, …) accept this config:

```json
{
  "mcpServers": {
    "github": {
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": { "Authorization": "Bearer ${GITHUB_PAT}" }
    }
  }
}
```

For Codex, Claude Desktop, GitHub Enterprise Server, or the local Docker version, see the [installation guides](https://github.com/github/github-mcp-server/tree/main/docs/installation-guides).

</details>

**Use**

```text
List open PRs in trekai/infra that are waiting on my review.
Find every workflow in our org that still uses actions/checkout@v3.
Show open Dependabot alerts for the payments repo, grouped by severity.
Open an issue for the flaky terraform-plan job and link the last failing run.
```

> **Tip:** The GitHub skills use the `gh` CLI and the MCP server uses your PAT, so they work independently. Install both: the skills give a guided workflow, and the MCP server covers everything else.

## How to use them together

Here is a typical TrekAI DevOps flow:

1. **Map the repo:** run `/graphify .` so the agent understands the infrastructure layout without reading every file.
2. **Find the cause:** ask about the failure. *Terraform Skill* identifies the failure type and plans a safe fix.
3. **Write or refactor code:** *Terraform Code Generation* writes code that follows the style guide. *Terraform Module Generation* extracts modules and handles state migration.
4. **Open the PR and get it green:** if CI fails, *GH Fix CI* finds the failing step. *GH Address Comments* works through reviewer feedback. The *GitHub MCP Server* handles issues, linked runs and searches across repos.
5. **Check it live:** the agent uses *BrowserOS neo* to confirm the change in the cloud console or CI dashboard.
6. **Document it:** the agent updates the architecture diagram or runbook on *Miro*.

## Verify your setup

```bash
ls ~/.claude/skills                # Terraform and GH skills appear here (Claude Code, manual install)
gh auth status                     # gh is logged in (needed by the GH skills)
graphify --help                    # Graphify CLI is on PATH
brew list --cask browseros-neo     # BrowserOS neo is installed (macOS)
```

Inside Claude Code:

```text
/plugin           # "miro" plugin listed
/mcp              # browseros, miro and github MCP servers connected
```

## Updating and removing

```bash
# Skills CLI–installed skills: re-run the add command to pull the latest version
npx skills add antonbabenko/terraform-skill@terraform-skill

# Manual installs: re-run the curl command, or remove the skill
rm -rf ~/.claude/skills/terraform-skill

# Graphify
uv tool upgrade graphifyy        # or: uv tool uninstall graphifyy

# GitHub MCP Server
claude mcp remove github           # then re-add it with a new token when you rotate the PAT

# BrowserOS neo
brew upgrade --cask browseros-neo   # or: brew uninstall --cask browseros-neo
```

In Claude Code, use `/plugin` to update or uninstall `miro@miro-ai`.

---

<p align="center">
  <sub>Maintained by the TrekAI DevOps team. Every skill and tool listed here belongs to its authors and is used under its own license:
  Terraform Skill (Anton Babenko) · HashiCorp agent-skills (MPL-2.0) · Graphify (Apache-2.0) · BrowserOS (AGPL-3.0) · Miro AI (Miro) · OpenAI skills (OpenAI) · GitHub MCP Server (GitHub).
  The AgenticSkills logo is a trademark of AgenticSkills.io.</sub>
</p>
