#!/usr/bin/env bash
# delegation-verification-beads bootstrap
# Installs Beads (bd) pinned, initializes the delegation ledger, and installs
# Beads' own per-agent integrations. Idempotent: safe to re-run.
set -euo pipefail

BD_VERSION="1.3.4"
TOOLS_DIR="${TOOLS_DIR:-$HOME/workspace/tools/beads}"
LEDGER_DIR="${LEDGER_DIR:-$HOME/workspace/delegation-ledger}"

# 1. Install the pinned bd binary (official gastownhall/beads release).
if [ ! -x "$TOOLS_DIR/bd" ]; then
  mkdir -p "$TOOLS_DIR"
  case "$(uname -s)-$(uname -m)" in
    Linux-x86_64)  ASSET="beads_${BD_VERSION}_linux_amd64.tar.gz" ;;
    Linux-aarch64) ASSET="beads_${BD_VERSION}_linux_arm64.tar.gz" ;;
    Darwin-arm64)  ASSET="beads_${BD_VERSION}_darwin_arm64.tar.gz" ;;
    Darwin-x86_64) ASSET="beads_${BD_VERSION}_darwin_amd64.tar.gz" ;;
    *) echo "unsupported platform: $(uname -s)-$(uname -m)" >&2; exit 1 ;;
  esac
  curl -sL -o "$TOOLS_DIR/beads.tar.gz" \
    "https://github.com/gastownhall/beads/releases/download/v${BD_VERSION}/${ASSET}"
  tar xzf "$TOOLS_DIR/beads.tar.gz" -C "$TOOLS_DIR" --no-same-owner
fi
export PATH="$TOOLS_DIR:$PATH"
bd version

# 2. Initialize the delegation ledger (Beads' own workflow: bd init).
mkdir -p "$LEDGER_DIR"
cd "$LEDGER_DIR"
[ -d .git ] || git init -q
[ -d .beads ] || bd init --prefix del

# 3. Install Beads' own integrations for the agents you run.
#    Each installs the tool's SessionStart `bd prime` context / AGENTS.md guidance.
bd setup claude    || true
bd setup codex     || true
bd setup gemini    || true
bd setup opencode  || true

echo
echo "Ledger ready at $LEDGER_DIR"
echo "Next: bd create your first delegation (see templates/lane-delegation-issue.md),"
echo "then verify with: bd list / bd stale / bd reclaim / bd status"
