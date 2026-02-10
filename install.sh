#!/bin/bash

# Claude Code Workflow Skills Installer (Legacy Fallback)
# Prefer plugin installation: /plugin marketplace add matthewod11-stack/claude-setup
# This script copies skills from skills/ into ~/.claude/commands/ for non-plugin setups

set -e

echo "==============================================="
echo "  Claude Code Workflow Skills Installer"
echo "==============================================="
echo ""
echo "NOTE: The recommended installation method is:"
echo "  /plugin marketplace add matthewod11-stack/claude-setup"
echo ""
echo "This script installs skills as legacy ~/.claude/commands/ files."
echo ""

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if we're in the repo
if [ ! -d "$SCRIPT_DIR/skills" ]; then
    echo "Error: skills/ directory not found."
    echo "   Make sure you're running this from the claude-setup repo."
    exit 1
fi

# Create directories
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/reference
mkdir -p ~/.claude/scripts/lib
mkdir -p ~/.claude/scripts/templates
mkdir -p ~/.claude/reviews
mkdir -p ~/.claude/solutions/{universal,typescript,react,node,python}

# Copy reference docs
echo "Copying reference documentation..."
cp -r "$SCRIPT_DIR/reference/"* ~/.claude/reference/

# Copy solutions README if it doesn't exist
if [ ! -f ~/.claude/solutions/README.md ] && [ -f "$SCRIPT_DIR/solutions/README.md" ]; then
    cp "$SCRIPT_DIR/solutions/README.md" ~/.claude/solutions/
fi

# Install skills from skills/ directory
echo "Installing skills to ~/.claude/commands/..."

copy_skill() {
    local src="$SCRIPT_DIR/skills/$1/SKILL.md"
    local dst="$HOME/.claude/commands/$1.md"
    if [ -f "$src" ]; then
        cp "$src" "$dst"
        echo "  + $1.md"
    else
        echo "  ! Missing: skills/$1/SKILL.md"
    fi
}

copy_skill "plan-master"
copy_skill "spec-review-multi"
copy_skill "roadmap-with-validation"
copy_skill "session-start"
copy_skill "session-end"
copy_skill "checkpoint"
copy_skill "compound"

# Install multi-model orchestrator scripts
echo ""
echo "Installing multi-model orchestrator scripts..."

if [ -d "$SCRIPT_DIR/scripts" ]; then
    # Copy main orchestrator
    if [ -f "$SCRIPT_DIR/scripts/multi-model-review.sh" ]; then
        cp "$SCRIPT_DIR/scripts/multi-model-review.sh" ~/.claude/scripts/
        chmod +x ~/.claude/scripts/multi-model-review.sh
        echo "  + multi-model-review.sh"
    fi

    # Copy CLI wrappers
    if [ -f "$SCRIPT_DIR/scripts/lib/cli-wrappers.sh" ]; then
        cp "$SCRIPT_DIR/scripts/lib/cli-wrappers.sh" ~/.claude/scripts/lib/
        chmod +x ~/.claude/scripts/lib/cli-wrappers.sh
        echo "  + lib/cli-wrappers.sh"
    fi

    # Copy prompt templates
    if [ -d "$SCRIPT_DIR/scripts/templates" ]; then
        cp "$SCRIPT_DIR/scripts/templates/"*.txt ~/.claude/scripts/templates/ 2>/dev/null || true
        TEMPLATE_COUNT=$(ls ~/.claude/scripts/templates/*.txt 2>/dev/null | wc -l | tr -d ' ')
        echo "  + templates/ ($TEMPLATE_COUNT prompt templates)"
    fi
else
    echo "  ! scripts/ directory not found (optional)"
fi

# Count installed skills
SKILL_COUNT=$(ls ~/.claude/commands/*.md 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo "Installation complete!"
echo ""
echo "Installed to:"
echo "  ~/.claude/commands/     ($SKILL_COUNT skills)"
echo "  ~/.claude/scripts/      (multi-model orchestrator)"
echo "  ~/.claude/reference/    (protocol docs)"
echo "  ~/.claude/solutions/    (learnings library)"
echo "  ~/.claude/reviews/      (review outputs)"
echo ""
echo "Restart Claude Code to discover new skills."
echo ""
echo "Quick start:"
echo "  /plan-master      Full planning wizard"
echo "  /session-start    Begin work session"
echo "  /session-end      End with commit"
echo ""

# Check for external CLIs
echo "Checking for multi-model CLI support..."
CODEX_AVAILABLE=false
GEMINI_AVAILABLE=false
CURSOR_AVAILABLE=false

if command -v codex &>/dev/null; then
    CODEX_AVAILABLE=true
    echo "  + codex CLI available"
else
    echo "  - codex CLI not found (optional)"
fi

if command -v gemini &>/dev/null; then
    GEMINI_AVAILABLE=true
    echo "  + gemini CLI available"
else
    echo "  - gemini CLI not found (optional)"
fi

if command -v cursor-agent &>/dev/null; then
    CURSOR_AVAILABLE=true
    echo "  + cursor-agent CLI available"
else
    echo "  - cursor-agent CLI not found (optional)"
fi

echo ""

if [ "$CODEX_AVAILABLE" = false ] && [ "$GEMINI_AVAILABLE" = false ] && [ "$CURSOR_AVAILABLE" = false ]; then
    echo "For real multi-model reviews, install external CLIs:"
    echo "   npm install -g @openai/codex @google/gemini-cli"
    echo "   See docs/MULTI-MODEL-SETUP.md for details."
else
    echo "Multi-model review ready with $([ "$CODEX_AVAILABLE" = true ] && echo "Codex ")$([ "$GEMINI_AVAILABLE" = true ] && echo "Gemini ")$([ "$CURSOR_AVAILABLE" = true ] && echo "Cursor")+ Claude"
fi
echo ""
