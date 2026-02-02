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

# Count installed skills
SKILL_COUNT=$(ls ~/.claude/commands/*.md 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo "✅ Installation complete!"
echo ""
echo "Installed to:"
echo "  ~/.claude/commands/     ($SKILL_COUNT skills)"
echo "  ~/.claude/reference/    (protocol docs)"
echo "  ~/.claude/solutions/    (learnings library)"
echo ""
echo "🔄 Restart Claude Code to discover new skills."
echo ""
echo "Quick start:"
echo "  /plan-master      Full planning wizard"
echo "  /session-start    Begin work session"
echo "  /session-end      End with commit"
