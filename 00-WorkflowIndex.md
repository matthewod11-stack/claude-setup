# Workflow Index

> **Purpose:** Navigation guide for the Claude Code workflow skill system.

---

## Quick Start

```
What do you have?
    │
    ├── Just an idea/PRD ─────────────▶ /plan-master
    ├── A detailed spec ──────────────▶ /spec-review-multi (Full) or /roadmap-with-validation (Lite)
    ├── Spec + feedback ──────────────▶ /roadmap-with-validation
    ├── Validated roadmap ────────────▶ /plan-master (start at Step 06)
    └── Scaffolded, ready to build ───▶ /orchestrate (parallel) or /session-start (sequential)
```

---

## Master Orchestrator

Use `/plan-master` to chain all planning steps with interactive checkpoints:

```
/plan-master
    │
    ├─► Step 01: Spec Interview (inline)
    │   └─► Checkpoint: Review SPEC.md
    │
    ├─► Steps 02-03: /spec-review-multi (spawns 4 agents)
    │   └─► Checkpoint: Review consolidated_feedback.md
    │
    ├─► Steps 04-05: /roadmap-with-validation (AskUserQuestion + 4 agents)
    │   └─► Checkpoint: Review ROADMAP.md
    │
    └─► Step 06: Exec Setup (inline)
        └─► Handoff to /orchestrate (parallel) or /session-start (sequential)
```

---

## Workflow Tiers

### Lite — `/plan-master --tier lite`

Side projects, toys, prototypes. Skip multi-AI review and validation.

**Flow:** Spec Interview → Scoping/Roadmap → Setup → Build

**Signals:** Built similar before • No external APIs • Single domain • Low stakes

### Full — `/plan-master --tier full`

Production apps, integrations, multi-domain complexity.

**Flow:** Spec Interview → Multi-Agent Review → Consolidate → Scoping/Roadmap → Validation → Setup → Build

**Signals:** External APIs • AI/LLM components • Multiple domains • Data that matters

### Quick Decision
```
Could rebuild in a weekend if it burned down? → Lite
Otherwise → Full
```

---

## Skills Reference

### Planning Skills

| Skill | Purpose |
|-------|---------|
| `/plan-master` | Master wizard — chains all steps with checkpoints |
| `/spec-review-multi` | Spawn 4 parallel review agents |
| `/roadmap-with-validation` | Interactive scoping + validation |
| `/compound` | Capture session learnings |

### Session Skills

| Skill | Purpose |
|-------|---------|
| `/session-start` | Begin work session, find next task |
| `/session-end` | End session, commit, document |
| `/checkpoint` | Mid-session state save |

### Execution Skills

| Skill | Purpose |
|-------|---------|
| `/orchestrate` | Coordinate 2+ parallel agents |
| `/ralph-loop` | Autonomous iteration loop |

---

## Key Files Created

| File | Created By | Purpose |
|------|-----------|---------|
| `SPEC.md` | /plan-master | Detailed specification |
| `*_feedback.md` | /spec-review-multi | Model-specific reviews |
| `consolidated_feedback.md` | /spec-review-multi | Merged feedback |
| `ROADMAP.md` | /roadmap-with-validation | Implementation plan |
| `v2_parking_lot.md` | /roadmap-with-validation | Deferred features |
| `*_validation.md` | /roadmap-with-validation | Validation reviews |
| `AGENT_BOUNDARIES.md` | /plan-master | Domain ownership (parallel) |
| `features.json` | /plan-master | Feature tracking |
| `PROGRESS.md` | /session-end | Session log |
| `.claude/workflow-state.json` | /plan-master | Workflow state |

---

## Solutions Library

Captured learnings for future reference:

```
~/.claude/solutions/          # Global (cross-project)
├── universal/
├── typescript/
├── react/
├── node/
└── python/

project/solutions/            # Project-specific
├── build-errors/
├── test-failures/
├── runtime-errors/
├── performance-issues/
├── integration-issues/
└── patterns/
```

**Capture:** `/compound` or `/session-end` (prompted after bug fixes)
**Search:** Automatic in `/session-start`

---

## Reference Documents

Located in `reference/`:

| Document | Purpose |
|----------|---------|
| `plan-master-protocol.md` | Master orchestrator logic |
| `multi-agent-review-protocol.md` | Parallel agent spawning |
| `validation-protocol.md` | Roadmap stress-testing |
| `compound-protocol.md` | Knowledge capture |
| `session-start-protocol.md` | Session start steps |
| `session-end-protocol.md` | Session end steps |
| `boris-workflow.md` | Claude Code principles |
| `parallel-build.md` | Multi-agent architecture |

---

## Archived Documentation

Original workflow step templates preserved in `archive/workflow-steps/`:
- `01-PLAN-SpecInterview.md` through `07-EXEC-RalphLoop.md`

Design documents in `archive/design-docs/`:
- Multi-agent review and validation orchestrator designs

These are now superseded by the skill system but kept for reference.

---

*Version 7.0 | Skill-based workflow system*
