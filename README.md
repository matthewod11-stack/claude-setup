# Claude Code Setup

Sync Claude Code config between machines.

## Quick Start

```bash
git clone <repo-url> ~/claude-setup
cd ~/claude-setup
./sync.sh
```

## What Gets Synced

- **Plugins** - All enabled plugins from claude-plugins-official
- **MCP servers** - nanobanana-mcp (Gemini image gen)
- **Statusline** - Custom status showing dir, branch, model, context %

## Setup nanobanana-mcp

```bash
cd ~
git clone https://github.com/anthropics/nanobanana-mcp.git
cd nanobanana-mcp && npm install && npm run build

# Add to shell profile
export GEMINI_API_KEY="your-key"
```

## Files

```
.claude/
  settings.json    # Plugins + statusline
  statusline.sh    # Status bar script
.mcp.json          # MCP server config
sync.sh            # Run to install config
```
