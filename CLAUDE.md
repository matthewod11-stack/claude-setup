# claude-setup

Source repo for Claude Code workflow skills.

## This Repo

- `reference/` — Protocol documentation (source of truth)
- `docs/` — Human-readable guides
- `solutions/` — Template structure for learnings
- `install.sh` — One-command installer

## Skills (installed globally)

Run `./install.sh` to install to `~/.claude/commands/`:

| Command | Purpose |
|---------|---------|
| `/plan-master` | Master planning wizard |
| `/spec-review-multi` | Multi-model spec review |
| `/roadmap-with-validation` | Scoping + validation |
| `/session-start` | Begin work session |
| `/session-end` | End with commit |
| `/checkpoint` | Mid-session save |
| `/compound` | Capture learnings |

## Key Principle

> "Give Claude a way to verify its work."

See `docs/PHILOSOPHY.md` for the full approach.
