#!/bin/bash

# Claude Code Workflow Skills Installer
# One-command setup for the planning and session management system

set -e

echo "🔧 Installing Claude Code Workflow Skills..."
echo ""

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if we're in the repo
if [ ! -d "$SCRIPT_DIR/reference" ]; then
    echo "❌ Error: reference/ directory not found."
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
echo "📚 Copying reference documentation..."
cp -r "$SCRIPT_DIR/reference/"* ~/.claude/reference/

# Copy solutions README if it doesn't exist
if [ ! -f ~/.claude/solutions/README.md ] && [ -f "$SCRIPT_DIR/solutions/README.md" ]; then
    cp "$SCRIPT_DIR/solutions/README.md" ~/.claude/solutions/
fi

# Install skills from protocol files
echo "⚡ Installing skills to ~/.claude/commands/..."

# Copy protocol files as skills (with renamed destinations)
copy_skill() {
    local src="$SCRIPT_DIR/reference/$1"
    local dst="$HOME/.claude/commands/$2"
    if [ -f "$src" ]; then
        cp "$src" "$dst"
        echo "  ✓ $2"
    else
        echo "  ⚠ Missing: $1"
    fi
}

copy_skill "protocol-session-start.md" "session-start.md"
copy_skill "protocol-session-end.md" "session-end.md"
copy_skill "protocol-checkpoint.md" "checkpoint.md"
copy_skill "protocol-compound.md" "compound.md"
copy_skill "protocol-plan-master.md" "plan-master.md"
copy_skill "protocol-multi-agent-review.md" "spec-review-multi.md"
copy_skill "protocol-validation.md" "roadmap-with-validation.md"

# Install multi-model orchestrator scripts
echo ""
echo "🚀 Installing multi-model orchestrator scripts..."

if [ -d "$SCRIPT_DIR/scripts" ]; then
    # Copy main orchestrator
    if [ -f "$SCRIPT_DIR/scripts/multi-model-review.sh" ]; then
        cp "$SCRIPT_DIR/scripts/multi-model-review.sh" ~/.claude/scripts/
        chmod +x ~/.claude/scripts/multi-model-review.sh
        echo "  ✓ multi-model-review.sh"
    fi

    # Copy CLI wrappers
    if [ -f "$SCRIPT_DIR/scripts/lib/cli-wrappers.sh" ]; then
        cp "$SCRIPT_DIR/scripts/lib/cli-wrappers.sh" ~/.claude/scripts/lib/
        chmod +x ~/.claude/scripts/lib/cli-wrappers.sh
        echo "  ✓ lib/cli-wrappers.sh"
    fi

    # Copy prompt templates
    if [ -d "$SCRIPT_DIR/scripts/templates" ]; then
        cp "$SCRIPT_DIR/scripts/templates/"*.txt ~/.claude/scripts/templates/ 2>/dev/null || true
        TEMPLATE_COUNT=$(ls ~/.claude/scripts/templates/*.txt 2>/dev/null | wc -l | tr -d ' ')
        echo "  ✓ templates/ ($TEMPLATE_COUNT prompt templates)"
    fi
else
    echo "  ⚠ scripts/ directory not found (optional)"
fi

# Count installed skills
SKILL_COUNT=$(ls ~/.claude/commands/*.md 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo "✅ Installation complete!"
echo ""
echo "Installed to:"
echo "  ~/.claude/commands/     ($SKILL_COUNT skills)"
echo "  ~/.claude/scripts/      (multi-model orchestrator)"
echo "  ~/.claude/reference/    (protocol docs)"
echo "  ~/.claude/solutions/    (learnings library)"
echo "  ~/.claude/reviews/      (review outputs)"
echo ""
echo "🔄 Restart Claude Code to discover new skills."
echo ""
echo "Quick start:"
echo "  /plan-master      Full planning wizard"
echo "  /session-start    Begin work session"
echo "  /session-end      End with commit"
echo ""

# Check for external CLIs
echo "📡 Checking for multi-model CLI support..."
CODEX_AVAILABLE=false
GEMINI_AVAILABLE=false
CURSOR_AVAILABLE=false

if command -v codex &>/dev/null; then
    CODEX_AVAILABLE=true
    echo "  ✓ codex CLI available"
else
    echo "  ○ codex CLI not found (optional)"
fi

if command -v gemini &>/dev/null; then
    GEMINI_AVAILABLE=true
    echo "  ✓ gemini CLI available"
else
    echo "  ○ gemini CLI not found (optional)"
fi

if command -v cursor-agent &>/dev/null; then
    CURSOR_AVAILABLE=true
    echo "  ✓ cursor-agent CLI available"
else
    echo "  ○ cursor-agent CLI not found (optional)"
fi

echo ""

if [ "$CODEX_AVAILABLE" = false ] && [ "$GEMINI_AVAILABLE" = false ] && [ "$CURSOR_AVAILABLE" = false ]; then
    echo "💡 For real multi-model reviews, install external CLIs:"
    echo "   npm install -g @openai/codex @google/gemini-cli"
    echo "   See docs/MULTI-MODEL-SETUP.md for details."
else
    echo "🎉 Multi-model review ready with $([ "$CODEX_AVAILABLE" = true ] && echo "Codex ")$([ "$GEMINI_AVAILABLE" = true ] && echo "Gemini ")$([ "$CURSOR_AVAILABLE" = true ] && echo "Cursor")+ Claude"
fi
echo ""
