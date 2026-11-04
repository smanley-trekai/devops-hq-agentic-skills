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
  <sub>Terraform · Codebase knowledge graphs · Browser automation · Miro diagrams</sub>
</p>

---

> [!IMPORTANT]
> **Used in TrekAI.** This is the skill stack TrekAI's DevOps team runs with its AI coding agents (Claude Code, Codex, Cursor) for infrastructure work. Each entry below is installed and in use on our machines today. This repo is the place to look before you add something new, and it gets new engineers set up quickly.

## Contents

- [The stack at a glance](#the-stack-at-a-glance)
- [Why use these instead of a default agent setup](#why-use-these-instead-of-a-default-agent-setup)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
  - [Quick install (all at once)](#quick-install-all-at-once)
  - [1. Terraform Skill](#1-terraform-skill-anton-babenko)
  - [2. Terraform Code Generation](#2-terraform-code-generation-hashicorp)
  - [3. Terraform Module Generation](#3-terraform-module-generation-hashicorp)
  - [4. Graphify](#4-graphify)
  - [5. BrowserOS neo](#5-browseros-neo)
  - [6. Miro AI](#6-miro-ai)
- [How to use them together](#how-to-use-them-together)
- [Verify your setup](#verify-your-setup)
- [Updating and removing](#updating-and-removing)

## The stack at a glance

| # | Skill / Tool | Type | What it does for us | Source |
|---|---|---|---|---|
| 1 | **Terraform Skill** | Agent skill | Finds the cause of Terraform and OpenTofu problems first, then gives a fix with validation steps and rollback notes. Enforces safe `plan`/`apply`/`destroy` habits. | [agenticskills.io](https://agenticskills.io/skills/terraform-skill) · [antonbabenko/terraform-skill](https://github.com/antonbabenko/terraform-skill) |
| 2 | **Terraform Code Generation** | Agent skill | Writes HCL that follows HashiCorp's official style guide: file layout, naming, typed variables, pinned versions, `fmt` and `validate`. | [agenticskills.io](https://agenticskills.io/skills/terraform-code-generation) · [hashicorp/agent-skills](https://github.com/hashicorp/agent-skills/tree/main/plugins/terraform/skills/terraform-style-guide) |
| 3 | **Terraform Module Generation** | Agent skill | Splits large configurations into reusable modules and migrates state safely with `moved` blocks. | [agenticskills.io](https://agenticskills.io/skills/terraform-module-generation) · [hashicorp/agent-skills](https://github.com/hashicorp/agent-skills/tree/main/plugins/terraform/skills/refactor-module) |
| 4 | **Graphify** | Skill + CLI | Maps a whole repo (code, docs, configs, schemas, PDFs) into a knowledge graph. The agent queries the graph instead of grepping through files. | [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) |
| 5 | **BrowserOS neo** | Agentic browser (MCP) | A separate local browser for agents, already signed into your accounts. Agents can work in cloud consoles, dashboards and internal tools. | [browseros-ai/BrowserOS](https://github.com/browseros-ai/BrowserOS) |
| 6 | **Miro AI** | Plugin + MCP + skills | Lets the agent read and write Miro boards: architecture diagrams, runbooks, specs and code reviews on a board. | [miroapp/miro-ai](https://github.com/miroapp/miro-ai) |

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
| One-off prompting conventions per engineer | Every engineer gets different output | Shared, versioned skills in this repo give the **same standards across the team** and across agents (Claude, Codex, Cursor) |

### In short

- **Safer infrastructure changes.** The skills include guardrails for `apply` and `destroy`, rollback notes, and state-safe refactors.
- **Consistent code.** Every engineer's agent writes Terraform the same way, so reviews are faster.
- **Fewer tokens, better answers.** The graph lookups in Graphify replace repeated file reads.
- **Agents reach where DevOps work happens.** That includes cloud consoles and dashboards (BrowserOS) and architecture boards (Miro), not only the terminal.
- **Works across agents.** Most of these work with Claude Code, Codex, Cursor and Gemini CLI, so switching agents doesn't mean starting over.

### Trade-offs to know about

- Skills load extra instructions into context. Install only the ones you use.
- Third-party skills change upstream. Read the `SKILL.md` after each update (see [Updating](#updating-and-removing)).
- BrowserOS neo uses your **real logged-in sessions**. Treat it as privileged access, keep production consoles read-only unless a task needs more, and use session replay to review what the agent did.
- Miro MCP gets OAuth access to the boards you grant. Grant only the boards you need.
- Graphify's code parsing is fully local. Its semantic pass over docs, PDFs and media uses your assistant's model or a configured API key.

## Prerequisites

| Tool | Needed for | Install |
|---|---|---|
| Node.js 18+ (`npx`) | Skills CLI (skills 1–3, optional Miro skills) | `brew install node` |
| Python 3.10+ and `uv` (or `pipx`) | Graphify | `brew install uv` |
| Homebrew (macOS) | BrowserOS neo | [brew.sh](https://brew.sh) |
| Terraform or OpenTofu | Running what the Terraform skills generate | `brew install hashicorp/tap/terraform` |
| An AI coding agent | Everything | Claude Code, Codex, Cursor, Gemini CLI… |
| A Miro account | Miro AI | [miro.com](https://miro.com) |

## Setup

### Quick install (all at once)

The [`scripts/install.sh`](scripts/install.sh) script installs the three Terraform skills, Graphify and BrowserOS neo. It then prints the Miro steps, which you must run inside Claude Code.

```bash
git clone https://github.com/smanley-trekai/devops-hq-agentic-skills.git
cd devops-hq-agentic-skills
./scripts/install.sh            # everything
./scripts/install.sh terraform  # only the Terraform skills
./scripts/install.sh graphify   # only Graphify
./scripts/install.sh browseros  # only BrowserOS neo (macOS)
```

Or install each one by hand, as shown below.

---

### 1. Terraform Skill (Anton Babenko)

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

### 2. Terraform Code Generation (HashiCorp)

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

### 3. Terraform Module Generation (HashiCorp)

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

### 4. Graphify

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

### 5. BrowserOS neo

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

### 6. Miro AI

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

## How to use them together

Here is a typical TrekAI DevOps flow:

1. **Map the repo:** run `/graphify .` so the agent understands the infrastructure layout without reading every file.
2. **Find the cause:** ask about the failure. *Terraform Skill* identifies the failure type and plans a safe fix.
3. **Write or refactor code:** *Terraform Code Generation* writes code that follows the style guide. *Terraform Module Generation* extracts modules and handles state migration.
4. **Check it live:** the agent uses *BrowserOS neo* to confirm the change in the cloud console or CI dashboard.
5. **Document it:** the agent updates the architecture diagram or runbook on *Miro*.

## Verify your setup

```bash
ls ~/.claude/skills                # Terraform skills appear here (Claude Code, manual install)
graphify --help                    # Graphify CLI is on PATH
brew list --cask browseros-neo     # BrowserOS neo is installed (macOS)
```

Inside Claude Code:

```text
/plugin           # "miro" plugin listed
/mcp              # browseros and miro MCP servers connected
```

## Updating and removing

```bash
# Skills CLI–installed skills: re-run the add command to pull the latest version
npx skills add antonbabenko/terraform-skill@terraform-skill

# Manual installs: re-run the curl command, or remove the skill
rm -rf ~/.claude/skills/terraform-skill

# Graphify
uv tool upgrade graphifyy        # or: uv tool uninstall graphifyy

# BrowserOS neo
brew upgrade --cask browseros-neo   # or: brew uninstall --cask browseros-neo
```

In Claude Code, use `/plugin` to update or uninstall `miro@miro-ai`.

---

<p align="center">
  <sub>Maintained by the TrekAI DevOps team. Every skill and tool listed here belongs to its authors and is used under its own license:
  Terraform Skill (Anton Babenko) · HashiCorp agent-skills (MPL-2.0) · Graphify (Apache-2.0) · BrowserOS (AGPL-3.0) · Miro AI (Miro).
  The AgenticSkills logo is a trademark of AgenticSkills.io.</sub>
</p>
