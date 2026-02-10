# claude-setup

Source repo for Claude Code workflow skills with real multi-model review.

## Installation

### Plugin (Recommended)

```
/plugin marketplace add matthewod11-stack/claude-setup
```

### Legacy (install.sh)

```bash
git clone https://github.com/matthewod11-stack/claude-setup.git
cd claude-setup
./install.sh
```

Copies skills from `skills/` to `~/.claude/commands/`.

## This Repo

- `skills/` — Modern SKILL.md files with YAML frontmatter (plugin format)
- `.claude-plugin/` — Plugin manifest and marketplace metadata
- `reference/` — Protocol documentation (source of truth)
- `scripts/` — Multi-model orchestrator and CLI wrappers
- `docs/` — Human-readable guides
- `solutions/` — Template structure for learnings
- `install.sh` — Legacy installer (copies skills to ~/.claude/commands/)

## Skills

| Command | Purpose |
|---------|---------|
| `/plan-master` | Master planning wizard |
| `/spec-review-multi` | Real multi-model spec review |
| `/roadmap-with-validation` | Scoping + validation |
| `/session-start` | Begin work session |
| `/session-end` | End with commit |
| `/checkpoint` | Mid-session save |
| `/compound` | Capture learnings |

## Multi-Model Review

Uses **real external CLIs** (Codex, Gemini, Cursor-Agent) for genuine AI diversity:

| Model | Provider | Focus |
|-------|----------|-------|
| Claude | Anthropic | Security, edge cases |
| Codex | OpenAI | Feasibility, API design |
| Gemini | Google | Patterns, documentation |
| Cursor | Anysphere | File structure, modules |

See `docs/MULTI-MODEL-SETUP.md` for CLI installation.

## Key Principle

> "Give Claude a way to verify its work."

See `docs/PHILOSOPHY.md` for the full approach.
