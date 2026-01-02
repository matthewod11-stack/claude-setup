#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Syncing Claude Code config..."

# Copy settings.json
cp "$SCRIPT_DIR/.claude/settings.json" ~/.claude/settings.json
echo "  ✓ settings.json"

# Copy statusline.sh
cp "$SCRIPT_DIR/.claude/statusline.sh" ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
echo "  ✓ statusline.sh"

# Copy MCP config
cp "$SCRIPT_DIR/.mcp.json" ~/.claude/.mcp.json
echo "  ✓ .mcp.json"

echo ""
echo "Done! Restart Claude Code to apply changes."
echo ""
echo "Note: Set GEMINI_API_KEY in your shell profile for nanobanana-mcp:"
echo "  export GEMINI_API_KEY=\"your-key-here\""
