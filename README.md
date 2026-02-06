# Claude Code Workflow Skills

**From idea to working code** — a skill system for Claude Code with multi-agent review, validation, and session management.

> "Give Claude a way to verify its work." — Boris Cherny

---

## What This Does

1. **Planning** — Turn ideas into validated, executable roadmaps
2. **Multi-Model Review** — Real AI CLIs (Codex, Gemini, Cursor) + Claude review your spec
3. **Session Management** — Start/end work sessions with context preservation
4. **Knowledge Capture** — Document learnings for future lookup

This is the **public, shareable** skill system. It installs into your existing `~/.claude/` directory alongside any personal configuration you already have. If you maintain a private `~/.claude/` config (synced across machines, domain-specific tools, etc.), these skills merge cleanly alongside it.

---

## Install

```bash
git clone https://github.com/matthewod11-stack/claude-setup.git
cd claude-setup
./install.sh
```

Then restart Claude Code.

The installer copies skills, reference docs, scripts, and templates into `~/.claude/` — it won't overwrite existing files in your solutions library.

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

7 skills installed to `~/.claude/commands/`:

| Command | Purpose |
|---------|---------|
| `/plan-master` | Master planning wizard with checkpoints |
| `/spec-review-multi` | Real multi-model parallel spec review |
| `/roadmap-with-validation` | Scoping + validation |
| `/session-start` | Begin work session |
| `/session-end` | End with commit + capture |
| `/checkpoint` | Mid-session save |
| `/compound` | Capture learnings |

Each skill is sourced from a protocol file in `reference/` — edit the protocol to customize the skill behavior.

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

**With CLIs installed:** 4 genuinely different AI perspectives, consolidated with consensus and divergence tagging.

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
- **Consensus Tagging** — Items flagged by 2+ models get priority
- **Solutions Library** — First debug (30 min) → future lookup (seconds)
- **Parallel Execution** — Independent domains in separate terminals

---

## Documentation

- [Philosophy](docs/PHILOSOPHY.md) — Why this approach works
- [Skills Reference](docs/SKILLS.md) — Detailed skill documentation
- [Multi-Model Setup](docs/MULTI-MODEL-SETUP.md) — External CLI installation
- [Reference Protocols](reference/) — Implementation details

---

## Repo Structure

```
claude-setup/
├── reference/              # Protocol files (source of truth for skills)
│   ├── protocol-*.md       #   7 skill definitions
│   ├── guide-*.md          #   Setup, session, parallel build guides
│   ├── research-*.md       #   Workflow analysis and feedback
│   └── source-*.md         #   Curated external references
├── scripts/                # Multi-model orchestrator
│   ├── multi-model-review.sh
│   ├── lib/cli-wrappers.sh
│   └── templates/          #   Prompt templates per model
├── docs/                   # Human-readable guides
│   ├── PHILOSOPHY.md
│   ├── SKILLS.md
│   └── MULTI-MODEL-SETUP.md
├── templates/              # Starter files for new projects
│   ├── ROADMAP.md          #   Roadmap template
│   └── features.json       #   Feature tracking template
├── solutions/              # Solutions library structure
├── archive/                # Design docs and original workflow steps
│   ├── design-docs/        #   Research and planning documents
│   └── workflow-steps/     #   Step-by-step protocol originals
├── install.sh              # One-command installer
├── CLAUDE.md               # Project instructions for Claude Code
└── LICENSE                 # MIT
```

### What Gets Installed

Running `./install.sh` copies into `~/.claude/`:

```
~/.claude/
├── commands/         # 7 skills (from reference/protocol-*.md)
├── scripts/          # Multi-model orchestrator + templates
├── reference/        # All protocol and guide docs
├── reviews/          # Output directory for review results
└── solutions/        # Learnings library (universal/, typescript/, react/, node/, python/)
```

---

## Extending This

These skills are designed as a foundation. You can:

- **Edit protocols** — Modify `reference/protocol-*.md` files and re-run `install.sh`
- **Add your own skills** — Create new `.md` files in `~/.claude/commands/`
- **Build a private config** — Keep a separate `~/.claude/` git repo for personal tools (machine sync, domain commands, custom agents) and use this repo's installer to layer skills on top
- **Fork and customize** — Clone, remove what you don't need, add your own protocols

---

## Credits

- **Boris Cherny** — Claude Code creator, verification philosophy ([tips](reference/source-boris-twitter-thread.md))
- **Every.to** — Compound engineering methodology ([source](reference/source-every-compound-engineering.md))
- **Steve Jobs** — Design questions in reviews ([prompts](reference/source-steve-jobs-design.md))
- **Thariq** — Spec interview pattern

---

## License

[MIT](LICENSE) — use however you want.

---

*Built with Claude Code. Improved through multi-model review.*
