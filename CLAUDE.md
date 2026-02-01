# claude-setup

Workflow skill system for Claude Code — from idea to implementation.

**Skills are installed globally** in `~/.claude/commands/`. This repo is the source of truth for protocol documentation.

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
| `/session-start` | Begin work — verify env, search solutions, find next task |
| `/session-end` | End work — commit, capture learnings via compound |
| `/checkpoint` | Mid-session state save |
| `/compound` | Capture learnings to solutions library |

## Execution Skills

| Command | Purpose |
|---------|---------|
| `/orchestrate` | Coordinate 2+ parallel agents |

## Global Installation

Skills and supporting files are installed to:

```
~/.claude/
├── commands/         # All skills (plan-master, session-*, etc.)
├── reference/        # Protocol documentation
└── solutions/        # Global learnings library
    ├── universal/
    ├── typescript/
    ├── react/
    ├── node/
    └── python/
```

## Key Files (per project)

| File | Purpose |
|------|---------|
| `PROGRESS.md` | Session work log |
| `ROADMAP.md` | Task list (when created) |
| `features.json` | Feature tracking |
| `solutions/` | Project-specific learnings |

## This Repo Structure

```
claude-setup/
├── reference/            # Protocol docs (source of truth)
├── solutions/            # Solution templates
├── archive/              # Old workflow docs
└── 00-WorkflowIndex.md   # Navigation
```

## Install to Another Machine

```bash
git clone https://github.com/YOUR_USERNAME/claude-setup.git
cd claude-setup

# Create global directories
mkdir -p ~/.claude/commands ~/.claude/reference ~/.claude/solutions/{universal,typescript,react,node,python}

# Copy reference docs
cp -r reference/* ~/.claude/reference/

# Note: Skills are already in ~/.claude/commands/ if synced
# Otherwise, skills need to be recreated (they're self-contained)

# Restart Claude Code
```

## Updating Skills

When you modify protocols in `reference/`, remember to update the corresponding global skill in `~/.claude/commands/` if needed. Session skills are self-contained; planning skills may reference global reference docs.
