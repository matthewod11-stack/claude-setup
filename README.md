# Claude Code Workflow Skills

A complete skill system for Claude Code — from idea to working code with multi-agent review, validation, and session management.

## Quick Install

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/claude-setup.git
cd claude-setup

# Install skills globally (available in all projects)
mkdir -p ~/.claude/commands ~/.claude/solutions
cp -r .claude/commands/* ~/.claude/commands/
cp -r solutions/* ~/.claude/solutions/ 2>/dev/null || true

# Restart Claude Code to discover new skills
```

## What You Get

### Planning Skills

| Command | Purpose |
|---------|---------|
| `/plan-master` | **Master wizard** — chains all planning steps with checkpoints |
| `/spec-review-multi` | Spawns 4 parallel agents for multi-model spec review |
| `/roadmap-with-validation` | Interactive scoping + multi-agent roadmap validation |

### Session Skills

| Command | Purpose |
|---------|---------|
| `/session-start` | Begin work — verify env, review progress, find next task |
| `/session-end` | End work — verify code, commit, capture learnings |
| `/checkpoint` | Mid-session save without full shutdown |
| `/compound` | Capture session learnings to solutions library |

### Execution Skills

| Command | Purpose |
|---------|---------|
| `/orchestrate` | Coordinate parallel agents (2+ terminals) |

## Usage

### New Project (Full Planning)

```
/plan-master
```

This wizard walks you through:
1. **Spec Interview** — Turn your idea into detailed spec
2. **Multi-Agent Review** — 4 AI models critique your spec
3. **Consolidation** — Merge feedback with consensus tagging
4. **Interactive Scoping** — Decide V1 vs V2 features
5. **Validation** — Stress-test the roadmap
6. **Setup** — Scaffold project for execution

### Quick Project (Lite Planning)

```
/plan-master --tier lite
```

Skips multi-agent review and validation. Good for side projects.

### Daily Work Sessions

```bash
# Start of day
/session-start

# Work on tasks...

# End of day
/session-end
```

### Parallel Builds (2+ Agents)

```bash
# Terminal 1 (Orchestrator)
/orchestrate

# Follow prompts to generate agent prompts for Terminal 2 & 3
```

## Solutions Library

Captured learnings for fast future lookup:

```
~/.claude/solutions/      # Global (all projects)
├── typescript/
├── react/
├── node/
└── universal/

project/solutions/        # Project-specific
├── build-errors/
├── test-failures/
└── patterns/
```

Automatically searched by `/session-start`. Prompted for capture by `/session-end`.

## File Structure

```
claude-setup/
├── .claude/commands/     # Slash command skills
│   ├── plan-master.md
│   ├── spec-review-multi.md
│   ├── roadmap-with-validation.md
│   ├── compound.md
│   ├── session-start.md
│   ├── session-end.md
│   └── checkpoint.md
├── reference/            # Protocol source docs
├── solutions/            # Solution templates
├── templates/            # Starter files
├── archive/              # Old workflow docs (reference only)
└── 00-WorkflowIndex.md   # Navigation guide
```

## Updating on Another Machine

```bash
cd claude-setup
git pull

# Re-apply skills
cp -r .claude/commands/* ~/.claude/commands/

# Restart Claude Code
```

## Workflow Tiers

| Tier | Flow | Best For |
|------|------|----------|
| **Lite** | Spec → Roadmap → Build | Side projects, prototypes |
| **Full** | Spec → Review → Consolidate → Roadmap → Validate → Build | Production apps, integrations |

**Rule of thumb:** Could rebuild in a weekend if it burned down? → Lite. Otherwise → Full.

## Key Concepts

- **Checkpoints** — Every major step pauses for review before continuing
- **Multi-Agent Review** — 4 models (Claude, GPT-4, Grok, Gemini) for diverse perspectives
- **Consensus Tagging** — Items flagged by 2+ models marked with 🔺
- **Parallel Execution** — Independent domains can run in separate terminals
- **Solutions Library** — First-time problem (30 min) → future lookup (minutes)

## Credits

- **Boris Cherny** — Creator of Claude Code. "Give Claude a way to verify its work."
- **Thariq** — Spec interview pattern using `AskUserQuestion`
- **Ralph Wiggum Plugin** — Autonomous execution loops

## License

MIT — use however you want.

---

*Built with Claude Code. Improved through multi-agent review.*
