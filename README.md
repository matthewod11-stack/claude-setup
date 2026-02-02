# Claude Code Workflow Skills

**From idea to working code** — a skill system for Claude Code with multi-agent review, validation, and session management.

> "Give Claude a way to verify its work." — Boris Cherny

---

## What This Does

1. **Planning** — Turn ideas into validated, executable roadmaps
2. **Multi-Model Review** — Real AI CLIs (Codex, Gemini, Cursor) + Claude review your spec
3. **Session Management** — Start/end work sessions with context preservation
4. **Knowledge Capture** — Document learnings for future lookup

---

## Install

```bash
git clone https://github.com/YOUR_USERNAME/claude-setup.git
cd claude-setup
./install.sh
```

Then restart Claude Code.

### Optional: Multi-Model CLI Setup

For real multi-perspective reviews (4 different AI models), install external CLIs:

```bash
npm install -g @openai/codex @google/gemini-cli
# Plus: cursor-agent from cursor.sh
```

See [Multi-Model Setup](docs/MULTI-MODEL-SETUP.md) for details.

---

## Quick Start

### New Project

```
/plan-master
```

Walk through:
1. Spec interview → `SPEC.md`
2. Multi-model review → `consolidated_feedback.md`
3. Interactive scoping → `ROADMAP.md`
4. Exec setup → Ready to build

### Daily Work

```bash
/session-start    # Context + next task
# ... work ...
/session-end      # Commit + document
```

---

## Skills

| Command | Purpose |
|---------|---------|
| `/plan-master` | Master planning wizard with checkpoints |
| `/spec-review-multi` | Real multi-model parallel spec review |
| `/roadmap-with-validation` | Scoping + validation |
| `/session-start` | Begin work session |
| `/session-end` | End with commit + capture |
| `/checkpoint` | Mid-session save |
| `/compound` | Capture learnings |
| `/orchestrate` | Coordinate parallel agents |

---

## Multi-Model Review

The `/spec-review-multi` skill launches **real external AI CLIs** for genuine diversity:

| Model | Provider | Focus |
|-------|----------|-------|
| **Claude** | Anthropic | Edge cases, security, architecture |
| **Codex** | OpenAI | Feasibility, API design, DX |
| **Gemini** | Google | Patterns, breadth, documentation |
| **Cursor** | Anysphere | File structure, modules, navigation |

**Without CLIs installed:** Falls back to Claude-only review.

**With CLIs installed:** 4 genuinely different AI perspectives, consolidated with consensus (🔺) and divergence (⚠️) tagging.

---

## Workflow Tiers

| Tier | Flow | Best For |
|------|------|----------|
| **Lite** | Spec → Roadmap → Build | Side projects |
| **Full** | Spec → Review → Roadmap → Validate → Build | Production |

**Rule of thumb:** Could rebuild in a weekend? → Lite. Otherwise → Full.

---

## Key Concepts

- **Checkpoints** — Pause for review at each step
- **Consensus Tagging** — Items flagged by 2+ models get 🔺
- **Solutions Library** — First debug (30 min) → future lookup (seconds)
- **Parallel Execution** — Independent domains in separate terminals

---

## Documentation

- [Philosophy](docs/PHILOSOPHY.md) — Why this approach works
- [Skills Reference](docs/SKILLS.md) — Detailed skill documentation
- [Multi-Model Setup](docs/MULTI-MODEL-SETUP.md) — External CLI installation
- [Reference Protocols](reference/) — Implementation details

---

## File Structure

```
~/.claude/
├── commands/         # Skills (installed by install.sh)
├── scripts/          # Multi-model orchestrator
│   ├── multi-model-review.sh
│   ├── lib/cli-wrappers.sh
│   └── templates/
├── reference/        # Protocol documentation
├── reviews/          # Multi-model review outputs
└── solutions/        # Global learnings library

project/
├── SPEC.md           # Specification
├── ROADMAP.md        # Implementation plan
├── PROGRESS.md       # Session log
├── features.json     # Feature tracking
└── solutions/        # Project learnings
```

---

## Credits

- **Boris Cherny** — Claude Code creator, verification philosophy ([tips](reference/source-boris-twitter-thread.md))
- **Every.to** — Compound engineering methodology ([source](reference/source-every-compound-engineering.md))
- **Steve Jobs** — Design questions in reviews ([prompts](reference/source-steve-jobs-design.md))
- **Thariq** — Spec interview pattern

---

## License

MIT — use however you want.

---

*Built with Claude Code. Improved through multi-model review.*
