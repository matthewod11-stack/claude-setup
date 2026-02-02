# Skills Reference

Complete reference for all workflow skills.

---

## Quick Start

```
What do you have?
    │
    ├── Just an idea ──────────────▶ /plan-master
    ├── A detailed spec ───────────▶ /plan-master (start at step 02)
    ├── Spec + feedback ───────────▶ /roadmap-with-validation
    ├── Validated roadmap ─────────▶ /session-start
    └── Ready to build ────────────▶ /session-start or /orchestrate
```

---

## Planning Skills

### `/plan-master`

**Master wizard** — chains all planning steps with checkpoints.

```
/plan-master
    │
    ├─► Step 01: Spec Interview
    │   └─► Checkpoint: Review SPEC.md
    │
    ├─► Steps 02-03: /spec-review-multi
    │   └─► Checkpoint: Review consolidated_feedback.md
    │
    ├─► Steps 04-05: /roadmap-with-validation
    │   └─► Checkpoint: Review ROADMAP.md
    │
    └─► Step 06: Exec Setup
        └─► Handoff to /orchestrate or /session-start
```

**Tiers:**
- **Lite:** 01 → 04 → 06 (side projects)
- **Full:** 01 → 02 → 03 → 04 → 05 → 06 (production)

---

### `/spec-review-multi`

Launches **real external AI CLIs** for multi-model spec review.

**Models (with CLIs installed):**

| Model | CLI | Focus Areas |
|-------|-----|-------------|
| **Claude** | In-session | Edge cases, security, architecture |
| **Codex** | `codex exec` | Feasibility, API design, DX |
| **Gemini** | `gemini --yolo` | Patterns, breadth, documentation |
| **Cursor** | `cursor-agent --print` | File structure, modules |

**Execution Flow:**
```
/spec-review-multi path/to/SPEC.md
    │
    ├── [Background] codex exec  → codex_feedback.md
    ├── [Background] gemini      → gemini_feedback.md
    ├── [Background] cursor      → cursor_feedback.md
    │
    └── [In-session] Claude      → claude_feedback.md

    → consolidated_feedback.md
```

**Output:**
- `claude_feedback.md` — In-session review
- `codex_feedback.md` — OpenAI/GPT review
- `gemini_feedback.md` — Google review
- `cursor_feedback.md` — Cursor-Agent review
- `consolidated_feedback.md` — Merged with consensus/divergence

**Consensus:** Items flagged by 2+ models marked with 🔺

**Divergence:** Models disagree marked with ⚠️

**Fallback:** Without external CLIs, uses Claude-only review.

**Setup:** See [Multi-Model Setup](MULTI-MODEL-SETUP.md) to install CLIs.

---

### `/roadmap-with-validation`

Interactive scoping + optional multi-agent validation.

**Flow:**
1. Interactive scoping (AskUserQuestion for priorities)
2. Domain triage (V1 Core / V1 Polish / V2)
3. Generate ROADMAP.md
4. Optional validation by 4 agents
5. Apply validated changes

**Output:**
- `ROADMAP.md`
- `v2_parking_lot.md`
- `consolidated_validation.md` (if validated)

---

## Session Skills

### `/session-start`

Begin work — verify env, search solutions, find next task.

**Steps:**
1. Check environment (npm install if needed)
2. Read PROGRESS.md for context
3. Search solutions library for relevant learnings
4. Find next task from ROADMAP.md
5. Check for blockers

**Output:** Session summary with next task and context.

---

### `/session-end`

End work — verify code, commit, capture learnings.

**Steps:**
1. Verify code state (TypeScript, tests)
2. Update PROGRESS.md
3. Update features.json
4. Update ROADMAP.md (check off completed)
5. Knowledge compound check (prompt if debugging detected)
6. Stage and commit
7. Final summary

---

### `/checkpoint`

Mid-session save without full shutdown.

**Steps:**
1. Assess current state
2. Add checkpoint note to PROGRESS.md
3. Optional WIP commit
4. Output resume instructions

**Use for:** Breaks, context switches, before risky operations.

---

### `/compound`

Capture session learnings as searchable solution documents.

**Flow:**
1. Analyze session (git log, PROGRESS.md)
2. Extract problem/solution
3. Determine scope (project vs global)
4. Generate document
5. Save to solutions library

**Locations:**
- Project: `solutions/[category]/[slug].md`
- Global: `~/.claude/solutions/[tech]/[slug].md`

---

## Execution Skills

### `/orchestrate`

Coordinate 2+ parallel agents (multi-terminal).

**Setup:**
- Terminal 1: Orchestrator (dev server)
- Terminal 2: Agent A
- Terminal 3: Agent B

**Features:**
- Generate agent-specific prompts
- Track phase transitions
- Coordinate integration points

---

## Orchestrator Script

The multi-model review uses a bash orchestrator script:

```bash
# Check available CLIs and models
~/.claude/scripts/multi-model-review.sh --models

# Dry run (preview without executing)
~/.claude/scripts/multi-model-review.sh --dry-run path/to/spec.md

# Run review
~/.claude/scripts/multi-model-review.sh path/to/spec.md
```

**Output Directory:** `~/.claude/reviews/reviews-YYYY-MM-DD-HHMM/`

---

## Files Created

| File | Created By | Purpose |
|------|-----------|---------|
| `SPEC.md` | /plan-master | Detailed specification |
| `*_feedback.md` | /spec-review-multi | Model reviews |
| `consolidated_feedback.md` | /spec-review-multi | Merged feedback |
| `ROADMAP.md` | /roadmap-with-validation | Implementation plan |
| `v2_parking_lot.md` | /roadmap-with-validation | Deferred features |
| `AGENT_BOUNDARIES.md` | /plan-master | Domain ownership |
| `features.json` | /plan-master | Feature tracking |
| `PROGRESS.md` | /session-end | Session log |
| `.claude/workflow-state.json` | /plan-master | Workflow state |

---

## Solutions Library

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

**Capture:** `/compound` or `/session-end` (prompted after debugging)
**Search:** Automatic in `/session-start`
