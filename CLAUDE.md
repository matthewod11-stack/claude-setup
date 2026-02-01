# claude-setup

Workflow skill system for Claude Code — from idea to implementation.

## Quick Start

```
/plan-master          # Full interactive wizard (Steps 01-06)
/session-start        # Begin work session
/session-end          # End work session with commit
```

## Planning Skills

| Command | Purpose |
|---------|---------|
| `/plan-master` | Master wizard — chains all planning steps with checkpoints |
| `/spec-review-multi` | Spawns 4 parallel agents for multi-model spec review |
| `/roadmap-with-validation` | Interactive scoping + multi-agent validation |

## Session Skills

| Command | Purpose |
|---------|---------|
| `/session-start` | Begin work — verify env, find next task |
| `/session-end` | End work — commit, capture learnings |
| `/checkpoint` | Mid-session state save |
| `/compound` | Capture learnings to solutions library |

## Execution Skills

| Command | Purpose |
|---------|---------|
| `/orchestrate` | Coordinate 2+ parallel agents |

## Key Files

| File | Purpose |
|------|---------|
| `PROGRESS.md` | Session work log |
| `ROADMAP.md` | Task list (when created) |
| `features.json` | Feature tracking |
| `solutions/` | Project learnings |

## Project Structure

```
claude-setup/
├── .claude/commands/     # Slash command skills
├── reference/            # Protocol docs
├── solutions/            # Solution templates
├── archive/              # Old workflow docs
└── 00-WorkflowIndex.md   # Navigation
```

## Install to Another Machine

```bash
git clone https://github.com/YOUR_USERNAME/claude-setup.git
cd claude-setup
mkdir -p ~/.claude/commands ~/.claude/solutions
cp -r .claude/commands/* ~/.claude/commands/
# Restart Claude Code
```
