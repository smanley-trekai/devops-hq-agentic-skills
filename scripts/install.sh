#!/usr/bin/env bash
# Install the TrekAI DevOps agentic skill stack.
# Usage: ./scripts/install.sh [all|check|terraform|github|graphify|browseros|miro]
set -euo pipefail

target="${1:-all}"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*"; }
need() { command -v "$1" >/dev/null 2>&1; }

install_terraform() {
  if ! need npx; then
    warn "npx not found. Install Node.js 18+ (brew install node) and re-run."
    return 1
  fi
  info "Installing Terraform Skill (antonbabenko)"
  npx -y skills add antonbabenko/terraform-skill@terraform-skill
  info "Installing Terraform Code Generation (hashicorp terraform-style-guide)"
  npx -y skills add hashicorp/agent-skills@terraform-style-guide
  info "Installing Terraform Module Generation (hashicorp refactor-module)"
  npx -y skills add hashicorp/agent-skills@refactor-module
}

install_graphify() {
  info "Installing Graphify"
  if need uv; then
    uv tool install graphifyy
  elif need pipx; then
    pipx install graphifyy
  else
    warn "Neither uv nor pipx found. Install one (brew install uv) and re-run."
    return 1
  fi
  graphify install
}

install_browseros() {
  info "Installing BrowserOS neo"
  if [[ "$(uname)" == "Darwin" ]] && need brew; then
    brew tap browseros-ai/tap
    brew install --cask browseros-neo
    info "Open BrowserOS neo, import from Chrome, then connect your agent from the MCP board."
  else
    warn "Automatic install is for macOS with Homebrew only."
    warn "Download BrowserOS neo for your platform from https://www.browseros.com"
  fi
}

install_github() {
  if ! need npx; then
    warn "npx not found. Install Node.js 18+ (brew install node) and re-run."
    return 1
  fi
  info "Installing GH Fix CI (openai)"
  npx -y skills add openai/skills@gh-fix-ci
  info "Installing GH Address Comments (openai)"
  npx -y skills add openai/skills@gh-address-comments
  if ! need gh; then
    warn "GitHub CLI not found. Install it (brew install gh), then run: gh auth login"
  elif ! gh auth status >/dev/null 2>&1; then
    warn "GitHub CLI isn't logged in. Run: gh auth login  (grant the repo and workflow scopes)"
  fi
  info "GitHub MCP Server: create a fine-grained PAT, then run in your terminal:"
  cat <<'EOF'
    read -rs GITHUB_PAT
    claude mcp add-json github --scope user \
      '{"type":"http","url":"https://api.githubcopilot.com/mcp","headers":{"Authorization":"Bearer '"$GITHUB_PAT"'"}}'
    unset GITHUB_PAT
EOF
}

check_tools() {
  local missing=0
  row() { # row <label> <status> <cmd...>  (any listed command counts)
    local label="$1" status="$2"; shift 2
    local c found=""
    for c in "$@"; do need "$c" && { found="$c"; break; }; done
    if [[ -n "$found" ]]; then
      printf '  \033[1;32mok\033[0m       %-28s (%s)\n' "$label" "$found"
    elif [[ "$status" == required ]]; then
      printf '  \033[1;31mMISSING\033[0m  %-28s required\n' "$label"; missing=$((missing+1))
    else
      printf '  \033[1;33mmissing\033[0m  %-28s %s\n' "$label" "$status"
    fi
  }
  info "Common";              row "node / npx" required npx; row "git" required git
  info "Terraform skills";    row "terraform or tofu" required terraform tofu; row "jq" required jq
                              row "tflint" recommended tflint; row "trivy" recommended trivy
                              row "checkov" recommended checkov; row "pre-commit" optional pre-commit
                              row "go (Terratest)" optional go
  info "Graphify";            row "python3" required python3; row "uv or pipx" required uv pipx
                              row "graphify CLI" "not installed yet" graphify
  info "GitHub skills";       row "gh" required gh
  if need gh; then
    if gh auth status >/dev/null 2>&1; then printf '  \033[1;32mok\033[0m       %-28s\n' "gh logged in"
    else printf '  \033[1;31mMISSING\033[0m  %-28s run: gh auth login\n' "gh logged in"; missing=$((missing+1)); fi
  fi
  row "python (alias for python3)" "optional: GH Fix CI runs 'python'" python
  info "GitHub MCP / agents"; row "claude CLI" optional claude; row "docker (local MCP)" optional docker
  info "BrowserOS neo"
  if [[ -d "/Applications/BrowserOS neo.app" ]] || { need brew && brew list --cask browseros-neo >/dev/null 2>&1; }; then
    printf '  \033[1;32mok\033[0m       %-28s\n' "BrowserOS neo app"
  else
    printf '  \033[1;33mmissing\033[0m  %-28s run: ./scripts/install.sh browseros\n' "BrowserOS neo app"
  fi
  echo
  if (( missing > 0 )); then warn "$missing required tool(s) missing. See the README's Prerequisites section."; else info "All required tools found."; fi
}

show_miro() {
  info "Miro AI: run these inside Claude Code, then restart it:"
  cat <<'EOF'
    /plugin marketplace add miroapp/miro-ai
    /plugin install miro@miro-ai
EOF
  info "Other agents: npx skills add miroapp/miro-ai  (see README)"
}

case "$target" in
  check)     check_tools; exit 0 ;;
  terraform) install_terraform ;;
  github)    install_github ;;
  graphify)  install_graphify ;;
  browseros) install_browseros ;;
  miro)      show_miro ;;
  all)
    install_terraform || warn "Terraform skills skipped"
    install_github    || warn "GitHub skills skipped"
    install_graphify  || warn "Graphify skipped"
    install_browseros || warn "BrowserOS neo skipped"
    show_miro
    ;;
  *) echo "Usage: $0 [all|check|terraform|github|graphify|browseros|miro]" >&2; exit 2 ;;
esac

info "Done. See README.md, section 'Verify your setup'."
