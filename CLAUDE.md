# claude-setup

Workflow system for Claude Code projects - from spec to implementation.

## Session Management

| Command | When to Use |
|---------|-------------|
| `/session-start` | Beginning of any work session |
| `/session-end` | Before stopping work |
| `/checkpoint` | Mid-session state save |

## Workflow Skills (Planned)

| Command | Step | Purpose |
|---------|------|---------|
| `/spec-interview` | 01 | Interview to refine spec into buildable detail |
| `/spec-review` | 02 | Multi-AI critique of spec |
| `/consolidate-feedback` | 03 | Merge divergent AI feedback |
| `/roadmap` | 04 | Interactive task breakdown → ROADMAP.md |
| `/exec-setup` | 06 | Project scaffolding |

See `00-WorkflowIndex.md` for the complete workflow decision tree.

## Key Files

| File | Purpose |
|------|---------|
| `PROGRESS.md` | Session work log |
| `ROADMAP.md` | Task list (when created) |
| `features.json` | Feature status tracking (optional) |
| `00-WorkflowIndex.md` | Workflow navigation |

## Reference Documents

Located in `reference/`:
- `session-*-protocol.md` — Source of truth for session skills
- `boris-workflow.md` — Claude Code principles
- `session-management.md` — Session continuity patterns
- `parallel-build.md` — Multi-agent architecture

## Making Skills Global

After validating these skills work well, promote them to global availability:

```bash
mkdir -p ~/.claude/commands
cp -r .claude/commands/* ~/.claude/commands/
```

This makes `/session-start`, `/session-end`, `/checkpoint` available in all projects.

**Note:** New skills require restarting Claude Code to be discovered.

## Project Structure

```
claude-setup/
├── .claude/
│   └── commands/            # Session management skills (slash commands)
├── reference/               # Protocol source docs
├── templates/               # Starter files for new projects
├── 00-07-*.md              # Workflow step documentation
├── PROGRESS.md             # Session log
└── CLAUDE.md               # This file
```
