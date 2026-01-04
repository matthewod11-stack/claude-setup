# Workflow Index

> **Purpose:** Master navigation for the idea-to-implementation workflow system.
> **Last Updated:** 2026-01-04

---

## Folder Structure

```
claude-setup/
├── 00-WorkflowIndex.md          ← You are here
│
├── PLANNING PHASE (01-05)
│   ├── 01-PLAN-SpecInterview.md
│   ├── 02-PLAN-SpecReview.md
│   ├── 03-PLAN-FeedbackConsolidation.md
│   ├── 04-PLAN-ScopingAndRoadmap.md
│   └── 05-PLAN-RoadmapValidation.md (optional)
│
├── EXECUTION PHASE (06-07)
│   ├── 06-EXEC-Setup.md
│   └── 07-EXEC-RalphLoop.md
│
├── reference/                   ← Supporting docs
│   ├── parallel-build.md
│   ├── session-management.md
│   └── setup.md
│
└── archive/                     ← Legacy docs
    └── boris-workflow.md
```

---

## Workflow Overview

```
PLANNING PHASE                          EXECUTION PHASE
─────────────────────────────────────   ─────────────────────────────────────

┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ 01: Spec    │────▶│ 02: Spec    │────▶│ 03: Feedback│
│  Interview  │     │   Review    │     │   Consol.   │
└─────────────┘     └─────────────┘     └─────────────┘
                                              │
                                              ▼
                                        ┌─────────────┐
                                        │ 04: Scoping │
                                        │  & Roadmap  │
                                        │ ⭐ DECIDES  │
                                        │  PAR vs SEQ │
                                        └─────────────┘
                                              │
                                              ▼
                                        ┌─────────────┐
                                        │ 05: Roadmap │ (optional)
                                        │ Validation  │
                                        └─────────────┘
                                              │
                                              ▼
                                        ┌─────────────┐
                                        │ 06: Exec    │
                                        │   Setup     │
                                        └─────────────┘
                                              │
                                              │ (reads mode from roadmap)
                                              │
                            ┌─────────────────┴─────────────┐
                            ▼                               ▼
                      ┌──────────────┐          ┌──────────────┐
                      │ SEQUENTIAL   │          │ PARALLEL     │
                      │ 1 Ralph Loop │          │ 2+ Ralph     │
                      │              │          │ Loops        │
                      │ 07-EXEC-     │          │ 07-EXEC-     │
                      │ RalphLoop    │          │ RalphLoop    │
                      └──────────────┘          └──────────────┘
```

**The meta-rule:** If parallelizable → parallel + ralph. If not → sequential + ralph. Simple.

---

## Quick Start

| If you have... | Start at... |
|----------------|-------------|
| A PRD from ideation | **01-PLAN-SpecInterview.md** |
| A detailed spec | **02-PLAN-SpecReview.md** |
| Multiple AI reviews | **03-PLAN-FeedbackConsolidation.md** |
| Spec + consolidated feedback | **04-PLAN-ScopingAndRoadmap.md** |
| A roadmap, want validation | **05-PLAN-RoadmapValidation.md** (optional) |
| A roadmap with execution mode | **06-EXEC-Setup.md** |
| Scaffolded project, ready to run | **07-EXEC-RalphLoop.md** |

---

## Workflow Steps

### Planning Phase

| Step | File | Input | Output | When to Use |
|------|------|-------|--------|-------------|
| 01 | [01-PLAN-SpecInterview.md](01-PLAN-SpecInterview.md) | PRD | Detailed Spec | Have a PRD, need detailed spec |
| 02 | [02-PLAN-SpecReview.md](02-PLAN-SpecReview.md) | Spec | Multiple Reviews | Want diverse AI perspectives |
| 03 | [03-PLAN-FeedbackConsolidation.md](03-PLAN-FeedbackConsolidation.md) | Reviews | Consolidated Feedback | Have 2+ AI reviews to merge |
| 04 | [04-PLAN-ScopingAndRoadmap.md](04-PLAN-ScopingAndRoadmap.md) | Spec + Feedback | v1_roadmap.md + v2_parking_lot.md | Interactive scoping → roadmap |
| 05 | [05-PLAN-RoadmapValidation.md](05-PLAN-RoadmapValidation.md) | v1_roadmap.md | Validated Roadmap | **Optional:** Skeptical review |

### Execution Phase

| Step | File | Input | Output | When to Use |
|------|------|-------|--------|-------------|
| 06 | [06-EXEC-Setup.md](06-EXEC-Setup.md) | Roadmap | Scaffolded project | Ready to start building |
| 07 | [07-EXEC-RalphLoop.md](07-EXEC-RalphLoop.md) | Scaffolded project | Completed Code | Autonomous execution |

### Reference Documents

| Document | Purpose |
|----------|---------|
| [reference/parallel-build.md](reference/parallel-build.md) | Multi-agent parallel development coordination |
| [reference/session-management.md](reference/session-management.md) | Session prompts, checkpointing, long-running work |
| [reference/setup.md](reference/setup.md) | Plugins and MCP configuration |
| [archive/boris-workflow.md](archive/boris-workflow.md) | Legacy: Claude Code power user best practices |

---

## Decision Points

### At Step 04 (Scoping and Roadmap) ⭐ KEY DECISIONS

**Interactive scoping uses `AskUserQuestion` to resolve:**
1. Success criteria validation
2. Non-negotiables vs nice-to-haves
3. Architecture/quality stance
4. Timeline constraints

**Parallelizability decision:**

| Answer | Roadmap Header | Execution |
|--------|----------------|-----------|
| **Yes** | `Execution Mode: PARALLEL-READY` | 2+ ralph loops, one per agent |
| **No** | `Execution Mode: SEQUENTIAL` | 1 ralph loop |

**Criteria for parallelization:**
- Features belong to distinct domains (e.g., "recipes" vs "meals")
- Each domain has its own routes, services, components
- Integration points are contracts, not shared state

### At Step 05 (Roadmap Validation) — Optional

**Question:** Do you want a skeptical review before committing?
- **Yes** → Run through the validation checklist
- **No** → Skip to 06-EXEC-Setup

**Recommended if:**
- New domain for you
- Complex spec with many interactions
- Planning parallel execution

### At Step 06 (Execution Setup)

Already answered — just read the roadmap header! Step 04 includes parallelizability analysis. Step 06 scaffolds infrastructure based on that decision.

---

## Standard Variables

Use these consistently across all prompts:

| Variable | Description | Example |
|----------|-------------|---------|
| `[PROJECT_NAME]` | Name of the project | "HRSkills Desktop" |
| `[V1_GOAL]` | Single-sentence success criteria | "Track skills for 50 employees" |
| `[TECH_STACK]` | Core technologies | "Next.js 14, Supabase, TypeScript" |
| `[TARGET_USER]` | Who this is for initially | "Me (single user, no auth)" |
| `[SPEC_FILE]` | Path to spec document | "SPEC.md" |
| `[ROADMAP_FILE]` | Path to roadmap | "ROADMAP.md" |
| `[OUTPUT_DIR]` | Where to save outputs | "docs/" |

---

## Plugin Integration

| Plugin | Used In | Purpose |
|--------|---------|---------|
| `/feature-dev` | 01, 04 | Feature breakdown and architecture |
| `/code-review` | 07 | Review completed work |
| `/commit` | 06, 07 | Commit changes |
| `/ralph-loop` | 06, 07 | Start autonomous execution loop |

---

## Typical Full Workflow

```
Day 1: Ideation (Claude Desktop)
  └─▶ PRD generated

Day 2: Specification (Claude Code)
  └─▶ 01-PLAN-SpecInterview → Detailed Spec

Day 3: Multi-Agent Review (Cursor + multiple AI)
  └─▶ 02-PLAN-SpecReview → claude_review.md, grok_review.md, etc.

Day 4: Consolidation + Scoping (Claude Code)
  └─▶ 03-PLAN-FeedbackConsolidation → consolidated_feedback.md
  └─▶ 04-PLAN-ScopingAndRoadmap → v1_roadmap.md + v2_parking_lot.md

Day 5: Validation + Setup (Claude Code)
  └─▶ 05-PLAN-RoadmapValidation (optional) → Validated roadmap
  └─▶ 06-EXEC-Setup → All infrastructure scaffolded

Day 5+: Execution (Claude Code)
  └─▶ Start ralph loop(s) per 07-EXEC-RalphLoop.md
  └─▶ Use reference/session-management.md for session prompts
```

---

*Version 4.0 | Updated 2026-01-04 | Reorganized with phase prefixes and reference folders*
