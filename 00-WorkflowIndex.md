# Workflow Index

> **Purpose:** Master navigation for the idea-to-implementation workflow system.

---

## Quick Start

```
What do you have?
    │
    ├── Just an idea/PRD ─────────────▶ 01-PLAN-SpecInterview.md
    ├── A detailed spec ──────────────▶ 02 (Full) or 04 (Lite)
    ├── Multiple AI reviews ──────────▶ 03-PLAN-FeedbackConsolidation.md
    ├── Spec + feedback ──────────────▶ 04-PLAN-ScopingAndRoadmap.md
    ├── Roadmap, want validation ─────▶ 05-PLAN-RoadmapValidation.md (optional)
    ├── Roadmap with exec mode ───────▶ 06-EXEC-Setup.md
    └── Scaffolded, ready to build ───▶ 07-EXEC-RalphLoop.md
```

---

## Workflow Tiers

### 🟢 Lite — `01 → 04 → 06 → 07`
Side projects, toys, prototypes. Skip multi-AI review and validation.

**Signals:** Built similar before • No external APIs • Single domain • Explain in 2 min • Low stakes

### 🔵 Full — `01 → 02 → 03 → 04 → 05 → 06 → 07`
Production apps, integrations, multi-domain complexity.

**Signals:** External APIs • AI/LLM components • Multiple domains • Data that matters • Parallel likely

### Quick Decision
```
Real project with integrations or data that matters? → 🔵 Full
Could rebuild in a weekend if it burned down? → 🟢 Lite
Otherwise → 🔵 Full
```

---

## Workflow Flow

```
PLANNING                                    EXECUTION
────────────────────────────────────────    ──────────────────────────

01: Spec Interview ──▶ 02: Spec Review ──▶ 03: Consolidate
                                                   │
                                                   ▼
                                           04: Scoping & Roadmap
                                           ⭐ DECIDES: PAR vs SEQ
                                                   │
                                                   ▼
                                           05: Validation (optional)
                                                   │
                                                   ▼
                                           06: Execution Setup
                                                   │
                              ┌────────────────────┴────────────────────┐
                              ▼                                         ▼
                        SEQUENTIAL                                 PARALLEL
                        1 Ralph Loop                              2+ Ralph Loops
                        07-EXEC-RalphLoop                         07-EXEC-RalphLoop
```

**Meta-rule:** If parallelizable → parallel ralph loops. If not → sequential ralph loop.

---

## Steps Reference

| Step | File | Input → Output |
|------|------|----------------|
| 01 | [SpecInterview](01-PLAN-SpecInterview.md) | PRD → Detailed Spec |
| 02 | [SpecReview](02-PLAN-SpecReview.md) | Spec → AI Reviews |
| 03 | [FeedbackConsolidation](03-PLAN-FeedbackConsolidation.md) | Reviews → Consolidated Feedback |
| 04 | [ScopingAndRoadmap](04-PLAN-ScopingAndRoadmap.md) | Spec + Feedback → ROADMAP.md |
| 05 | [RoadmapValidation](05-PLAN-RoadmapValidation.md) | ROADMAP.md → Validated Roadmap *(optional)* |
| 06 | [Setup](06-EXEC-Setup.md) | Roadmap → Scaffolded Project |
| 07 | [RalphLoop](07-EXEC-RalphLoop.md) | Scaffolded Project → Completed Code |

**Reference docs:** [parallel-build](reference/parallel-build.md) • [session-management](reference/session-management.md) • [setup](reference/setup.md)

---

## Variables

Use consistently across prompts:

| Variable | Example |
|----------|---------|
| `[PROJECT_NAME]` | "HRSkills Desktop" |
| `[V1_GOAL]` | "Track skills for 50 employees" |
| `[TECH_STACK]` | "Next.js 14, Supabase, TypeScript" |
| `[TARGET_USER]` | "Me (single user, no auth)" |

---

## Plugins

| Command | Purpose |
|---------|---------|
| `/feature-dev` | Feature breakdown and architecture |
| `/code-review` | Review completed work |
| `/commit` | Commit changes |
| `/ralph-loop` | Start autonomous execution loop |

---

*Version 5.0 | Consolidated from feedback review*
