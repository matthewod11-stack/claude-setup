# Workflow Index

> **Purpose:** Master navigation for the idea-to-implementation workflow system.
> **Last Updated:** 2025-01-03

---

## Workflow Overview

```
PLANNING PHASE                          EXECUTION PHASE
─────────────────────────────────────   ─────────────────────────────────────

┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ 01: Spec    │────▶│ 02: Roadmap │────▶│ 03: Feedback│
│  Interview  │     │   Review    │     │   Consol.   │
└─────────────┘     └─────────────┘     └─────────────┘
                          │                    │
                          │                    ▼
                          │              ┌─────────────┐
                          │              │ 04: V1      │ (conditional)
                          │              │   Scoping   │
                          │              └─────────────┘
                          │                    │
                          ▼                    ▼
                    ┌─────────────┐     ┌─────────────┐
                    │ 05: Roadmap │◀────│   Merge     │
                    │  Creation   │     │   Feedback  │
                    │ ⭐ DECIDES  │     └─────────────┘
                    │  PAR vs SEQ │
                    └─────────────┘
                          │
                          ▼
                    ┌─────────────┐
                    │ 06: Exec    │──────────────────────┐
                    │   Setup     │                      │
                    └─────────────┘                      │
                          │                              │
                          │ (reads mode from roadmap)    │
                          │                              │
            ┌─────────────┴─────────────┐               ▼
            ▼                           ▼         ┌──────────┐
      ┌──────────────┐          ┌──────────────┐  │09:Session│
      │ SEQUENTIAL   │          │ PARALLEL     │  │  Mgmt    │
      │ 1 Ralph Loop │          │ 2+ Ralph     │  └──────────┘
      │              │          │ Loops        │
      │ 07-RalphLoop │          │ 07+08        │
      └──────────────┘          └──────────────┘
```

**The meta-rule:** If parallelizable → parallel + ralph. If not → sequential + ralph. Simple.

---

## Quick Start

| If you have... | Start at... |
|----------------|-------------|
| A PRD from ideation | **01-SpecInterview.md** |
| A detailed spec | **02-RoadmapReview.md** |
| Multiple AI reviews | **03-FeedbackConsolidation.md** |
| Scope creep concerns | **04-V1Scoping.md** |
| Spec + consolidated feedback | **05-RoadmapCreation.md** (sets parallel vs sequential) |
| A roadmap with execution mode | **06-ExecutionSetup.md** (scaffolds, then you're ready) |
| Scaffolded project, ready to run | **07-RalphLoop.md** (start ralph loop(s)) |

---

## Workflow Steps

### Planning Phase

| Step | File | Input | Output | When to Use |
|------|------|-------|--------|-------------|
| 01 | [01-SpecInterview.md](01-SpecInterview.md) | PRD | Detailed Spec | Have a PRD, need detailed spec |
| 02 | [02-RoadmapReview.md](02-RoadmapReview.md) | Spec | Multiple Reviews | Want diverse AI perspectives |
| 03 | [03-FeedbackConsolidation.md](03-FeedbackConsolidation.md) | Reviews | Consolidated Feedback | Have 2+ AI reviews to merge |
| 04 | [04-V1Scoping.md](04-V1Scoping.md) | Spec + Feedback | v1_roadmap.md | **Conditional:** Scope is creeping |
| 05 | [05-RoadmapCreation.md](05-RoadmapCreation.md) | Spec + Feedback | Actionable Roadmap | Ready to plan implementation |

### Execution Phase

| Step | File | Input | Output | When to Use |
|------|------|-------|--------|-------------|
| 06 | [06-ExecutionSetup.md](06-ExecutionSetup.md) | Roadmap | **Ready to run** (all scaffolding done) | Ready to start building |
| 07 | [07-RalphLoop.md](07-RalphLoop.md) | Scaffolded project | Completed Code | Autonomous execution (1 or more loops) |
| 08 | [08-ParallelBuild.md](08-ParallelBuild.md) | Scaffolded project | Completed Code | Parallel agent coordination details |
| 09 | [09-LongRunningWorkflow.md](09-LongRunningWorkflow.md) | — | — | **Reference:** Session prompts, tips |

---

## Decision Points

### After Step 03 (Feedback Consolidation)
**Question:** Is scope creeping beyond reality?
- **Yes** → Go to **04-V1Scoping.md** to refocus
- **No** → Continue to **05-RoadmapCreation.md**

### At Step 05 (Roadmap Creation) ⭐ KEY DECISION
**Question:** Can features be split into independent domains?

| Answer | Roadmap Header | Execution |
|--------|----------------|-----------|
| **Yes** | `Execution Mode: PARALLEL-READY` | 2+ ralph loops, one per agent |
| **No** | `Execution Mode: SEQUENTIAL` | 1 ralph loop |

**Criteria for parallelization:**
- Features belong to distinct domains (e.g., "recipes" vs "meals")
- Each domain has its own routes, services, components
- Integration points are contracts, not shared state

### At Step 06 (Execution Setup)
**Question:** Already answered — just read the roadmap header!

The 05-RoadmapCreation step now includes parallelizability analysis. Step 06 simply scaffolds infrastructure based on that decision.

---

## Standard Variables

Use these consistently across all prompts:

| Variable | Description | Example |
|----------|-------------|---------|
| `[PROJECT_NAME]` | Name of the project | "HRSkills Desktop" |
| `[V1_GOAL]` | Single-sentence success criteria | "Track skills for 50 employees" |
| `[TECH_STACK]` | Core technologies | "Next.js 14, Supabase, TypeScript" |
| `[TARGET_USER]` | Who this is for initially | "Me (single user, no auth)" |
| `[TIMELINE]` | Estimated build duration | "8 weeks" |
| `[SPEC_FILE]` | Path to spec document | "SPEC.md" |
| `[ROADMAP_FILE]` | Path to roadmap | "ROADMAP.md" |
| `[OUTPUT_DIR]` | Where to save outputs | "docs/" |

---

## Reference Documents

| Document | Purpose |
|----------|---------|
| [BorisWorkflow.md](BorisWorkflow.md) | Claude Code power user best practices |
| [SETUP.md](SETUP.md) | Plugins and MCP configuration |

---

## Plugin Integration

| Plugin | Used In | Purpose |
|--------|---------|---------|
| `/feature-dev` | 01, 05, 08 | Feature breakdown and architecture |
| `/code-review` | 07, 08 | Review completed work |
| `/commit` | 06, 07, 08 | Commit changes |
| `/ralph-loop` | 06, 07 | Start autonomous execution loop |

---

## Typical Full Workflow

```
Day 1: Ideation (Claude Desktop)
  └─▶ PRD generated

Day 2: Specification (Claude Code)
  └─▶ 01-SpecInterview → Detailed Spec

Day 3: Multi-Agent Review (Cursor + multiple AI)
  └─▶ 02-RoadmapReview → claude_review.md, grok_review.md, etc.

Day 4: Consolidation (Claude Code)
  └─▶ 03-FeedbackConsolidation → consolidated_feedback.md
  └─▶ 04-V1Scoping (if needed) → v1_roadmap.md

Day 5: Roadmap + Setup (Claude Code)
  └─▶ 05-RoadmapCreation → ROADMAP.md (with execution mode)
  └─▶ 06-ExecutionSetup → All infrastructure scaffolded, READY TO RUN

Day 5+: Execution (Claude Code)
  └─▶ Start ralph loop(s) per 07-RalphLoop.md
  └─▶ Use 09-LongRunningWorkflow.md for session prompts
```

---

*Version 2.0 | Updated 2025-01-03 | Decision point moved to Step 05*
