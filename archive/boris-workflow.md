# Claude Code Power User Workflow Guide

> Based on Boris Cherny's setup (creator of Claude Code). Reformatted as an actionable reference.

---

## Core Philosophy

**The single most important thing**: Give Claude a way to verify its work. A feedback loop 2-3x the quality of results.

---

## 1. Parallel Sessions

### Terminal (5 Claudes)
- Number tabs 1-5 in iTerm2
- Enable system notifications to know when Claude needs input

**Setup (iTerm2 only):**
1. Preferences → Profiles → Terminal
2. Check "Silence bell"
3. Select Filter Alerts → "Send escape sequence-generated alerts"

### Web (5-10 Claudes)
- Run parallel sessions at `claude.ai/code`
- Hand off local sessions to web using `&` suffix
- Use `--teleport` to move sessions between terminal and web
- Start sessions from Claude iOS app for async work

---

## 2. Model Selection

```bash
# Use Opus 4.5 with thinking for everything
claude --model opus

# Or set as default in settings
```

**Why**: Better tool use + less steering = faster end-to-end, despite being larger/slower per-token.

---

## 3. Team Collaboration: CLAUDE.md

**Location**: Project root, checked into git

**Maintenance Pattern**:
- Whole team contributes multiple times per week
- When Claude does something wrong → add it to CLAUDE.md
- Each team owns their repo's CLAUDE.md

**During Code Review**:
```
@.claude Add to CLAUDE.md: [lesson learned from this PR]
```

Requires: GitHub Action installed via `/install-github-action`

---

## 4. Plan Mode Workflow

```bash
# Enter plan mode (shift+tab twice, or):
claude --plan
```

**Workflow**:
1. Start in Plan mode
2. Iterate with Claude until the plan is solid
3. Switch to auto-accept edits mode
4. Claude typically 1-shots the implementation

**Key insight**: A good plan is everything.

---

## 5. Slash Commands

**Location**: `.claude/commands/`

**Purpose**: Automate "inner loop" workflows you do many times daily.

**Example**: `/commit-push-pr`
```markdown
---
description: Commit, push, and create PR
---

# Context
```bash
git status
git diff --stat
git log --oneline -5
```

# Instructions
1. Stage relevant changes
2. Write a conventional commit message
3. Push to origin
4. Create PR with summary
```

**Pro tip**: Use inline bash to pre-compute context (git status, etc.) for faster execution.

**Docs**: https://code.claude.com/docs/en/slash-commands

---

## 6. Subagents

**Purpose**: Automate common multi-step workflows.

**Boris's Subagents**:
| Agent | Purpose |
|-------|---------|
| `code-simplifier` | Simplifies code after Claude finishes |
| `verify-app` | End-to-end testing instructions |

**Location**: `.claude/agents/` or defined in plugins

**Docs**: https://code.claude.com/docs/en/sub-agents

---

## 7. Hooks

### PostToolUse Hook (Formatting)
Runs after Claude edits files to auto-format.

**Example** (`.claude/settings.json`):
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": "prettier --write $FILE"
      }
    ]
  }
}
```

**Why**: Claude generates good code; hooks handle the last 10%.

### Stop Hook (Verification)
Runs when Claude tries to finish, can block completion.

**Use case**: Verify work before session ends.

**Docs**: https://code.claude.com/docs/en/hooks-guide

---

## 8. Permissions

**Instead of** `--dangerously-skip-permissions`:

```bash
# Pre-allow safe commands
/permissions add "npm test"
/permissions add "npm run build"
/permissions add "git status"
```

**Location**: `.claude/settings.json` (shared with team)

---

## 9. MCP Integrations

**Location**: `.mcp.json` (checked into git, shared with team)

**Boris's Integrations**:
| Tool | Purpose |
|------|---------|
| Slack MCP | Search/post messages |
| `bq` CLI | BigQuery analytics queries |
| Sentry | Error log retrieval |

**Pattern**: Claude uses your tools for you.

---

## 10. Long-Running Tasks

### Option A: Background Agent Verification
Prompt Claude to verify with a background agent when done.

### Option B: Stop Hook
Deterministically run verification on session end.

### Option C: Ralph Wiggum Loop
Self-referential iteration loop for autonomous completion.

```bash
# Start a ralph loop
/ralph-loop "Build X. Output <promise>DONE</promise> when complete." \
  --completion-promise "DONE" \
  --max-iterations 50

# Cancel if needed
/cancel-ralph
```

**Best for**:
- Well-defined tasks with clear success criteria
- Tasks requiring iteration (getting tests to pass)
- Tasks you can walk away from

### Unattended Mode
```bash
# In a sandbox environment
claude --permission-mode=dontAsk
# or
claude --dangerously-skip-permissions
```

**Plugin**: https://github.com/anthropics/claude-plugins-official/tree/main/plugins/ralph-wiggum

---

## 11. Verification (Most Important)

> "Give Claude a way to verify its work" - Boris

### Verification by Domain

| Domain | Verification Method |
|--------|---------------------|
| Backend | Run test suite |
| CLI | Execute bash commands |
| Frontend | Browser testing via Chrome extension |
| API | curl/httpie requests |
| Build | `npm run build` / `cargo build` |

### Chrome Extension for UI Testing

```bash
# Start with Chrome integration
claude --chrome

# Check connection
/chrome
```

**Capabilities**:
- Control browser tabs
- Read console errors and DOM
- Use your existing login sessions
- Record interactions as GIFs

**Requirements**:
- Google Chrome
- Claude in Chrome extension (v1.0.36+)
- Claude Code CLI (v2.0.73+)

**Docs**: https://code.claude.com/docs/en/chrome

---

## Quick Reference: File Locations

```
project/
├── .claude/
│   ├── commands/           # Slash commands
│   │   └── commit-push-pr.md
│   ├── agents/             # Subagents
│   └── settings.json       # Permissions, hooks
├── .mcp.json               # MCP server configs
└── CLAUDE.md               # Project instructions
```

---

## Quick Reference: Key Commands

| Command | Purpose |
|---------|---------|
| `shift+tab` (x2) | Enter plan mode |
| `/permissions` | Manage allowed commands |
| `/install-github-action` | Install @.claude for PRs |
| `&` (suffix) | Hand off to web session |
| `--teleport` | Move session between terminal/web |
| `--chrome` | Enable browser automation |
| `/ralph-loop` | Start autonomous iteration loop |

---

## Checklist: Setting Up a New Project

- [ ] Create `CLAUDE.md` with project-specific instructions
- [ ] Add common slash commands to `.claude/commands/`
- [ ] Configure permissions in `.claude/settings.json`
- [ ] Set up formatting hooks (PostToolUse)
- [ ] Configure MCP integrations in `.mcp.json`
- [ ] Set up verification method for your domain
- [ ] Install GitHub Action for PR automation

---

*Source: Boris Cherny (@anthropic) - https://x.com/ArbiterVince*
