# 08: Parallel Build Strategy

> **Position:** Step 8 (execution) | After: 06-ExecutionSetup | Parallel to: 07-RalphLoop
> **Requires:** ROADMAP.md with phases defined + clear feature boundaries
> **Produces:** Completed code via multiple parallel agents
> **Best For:** Larger projects with separable domains, compressed timelines

---

## Variables

Replace these before using:
- `[PROJECT_NAME]` - Your project name
- `[TIMELINE]` - Total build duration (e.g., "11 weeks")
- `[AGENT_COUNT]` - Number of concurrent agents (e.g., "1-2")
- `[TECH_STACK]` - Core technologies (e.g., "Next.js 14, Supabase, TypeScript")

---

## Overview

This document outlines how to parallelize development using multiple AI agents. The strategy balances speed gains from parallel work against coordination costs from merge conflicts and interface mismatches.

**Key insight:** 2 well-coordinated agents with clear boundaries outperform 4 agents stepping on each other.

---

## When to Use Parallel Build

Choose Parallel Build when:
- Features can be separated into independent domains
- Tight timeline requires parallelism
- Clear ownership boundaries can be defined
- You can manage coordination overhead

**Typical pattern:**
```
Phase 0: Sequential (Foundation)    — 1 agent
Phase 1-N: Parallel (Features)      — 2 agents
Final: Sequential (Integration)     — 1 agent
```

---

## Phase Overview Template

| Phase | Weeks | Agents | Focus |
|-------|-------|--------|-------|
| **Foundation** | 1-2 | 1 | Contracts, types, shared infrastructure |
| **Core Features** | 3-N | 2 | [Domain A] + [Domain B] |
| **Integration & Polish** | N-1 to N | 1 | Testing, platform-specific, ship |

---

## Phase 0: Foundation (Sequential)

### Agent Assignment: Single Agent

Foundation must be sequential. This agent establishes all contracts that parallel agents will consume.

### Week 1 Deliverables

**Day 1-2: Project Scaffolding**
- [ ] [TECH_STACK] project setup
- [ ] TypeScript strict mode configuration
- [ ] CSS/styling framework with design tokens
- [ ] Database client setup
- [ ] Linting + formatting configuration
- [ ] Directory structure

**Day 3-4: Core Types & Contracts**
- [ ] `types/[domain-a].ts` — Core domain interfaces
- [ ] `types/[domain-b].ts` — Secondary domain interfaces
- [ ] `contracts/[service-a].ts` — Service interface
- [ ] `contracts/[service-b].ts` — Service interface

**Day 5: Database Schema**
- [ ] Database migrations for core tables
- [ ] Access policies (RLS if applicable)
- [ ] Storage configuration

### Week 2 Deliverables

**Day 1-2: Base Components**
- [ ] Design tokens (CSS variables for colors, typography, spacing)
- [ ] Core UI components (Button, Card, Input, Modal)
- [ ] Toast notification system
- [ ] Loading skeletons
- [ ] Error boundary components

**Day 3-4: Infrastructure**
- [ ] API/service abstraction layer
- [ ] Utility functions
- [ ] PWA configuration (if applicable)
- [ ] Offline detection (if applicable)

**Day 5: App Shell**
- [ ] Layout component
- [ ] Navigation structure
- [ ] Empty states
- [ ] Basic routing

### Foundation Outputs

```
/types/
├── [domain-a].ts
├── [domain-b].ts
└── index.ts

/contracts/
├── [service-a].ts
├── [service-b].ts
└── index.ts

/components/ui/
├── button.tsx
├── card.tsx
├── input.tsx
├── modal.tsx
└── ...

/lib/
├── [database-client].ts
├── [api-client].ts
└── [utilities].ts
```

### Definition of Done (Foundation)

- [ ] `npm run dev` shows styled app shell
- [ ] Database connected, can read/write
- [ ] All type files compile without errors
- [ ] Contract interfaces are documented

---

## Parallel Phase Template

### Agent Assignment

| Agent | Owns | Duration |
|-------|------|----------|
| **Agent A** | [Domain A features] | [X weeks] |
| **Agent B** | [Domain B features] | [X weeks] |

### Boundary Rules

```
Agent A owns:
├── /app/[domain-a]/           # Routes
├── /lib/services/[domain-a]/  # Service implementation
├── /components/[domain-a]/    # Domain components
└── /lib/[domain-a-utils]/     # Domain utilities

Agent B owns:
├── /app/[domain-b]/
├── /lib/services/[domain-b]/
├── /components/[domain-b]/
└── /lib/[domain-b-utils]/

Shared (read-only for both):
├── /types/                    # All type definitions
├── /contracts/                # Service interfaces
├── /components/ui/            # Base components
└── /lib/[database-client].ts  # Database client
```

### Week N: [Focus Area]

**Agent A Focus:**
- [ ] [Task 1]
- [ ] [Task 2]
- [ ] [Task 3]

**Agent B Focus:**
- [ ] [Task 1]
- [ ] [Task 2]
- [ ] [Task 3]

### Integration Points

| Integration Point | Agent A Provides | Agent B Consumes |
|-------------------|------------------|------------------|
| [Name] | [Interface/Data] | [How used] |

### Phase Outputs

```
Agent A delivers:
├── /app/[domain-a]/...
├── /lib/services/[domain-a]/
└── /components/[domain-a]/

Agent B delivers:
├── /app/[domain-b]/...
├── /lib/services/[domain-b]/
└── /components/[domain-b]/
```

### Definition of Done (Phase)

- [ ] [Acceptance criteria 1]
- [ ] [Acceptance criteria 2]
- [ ] Integration tested between domains

---

## Final Phase: Integration & Polish (Sequential)

### Agent Assignment: Single Agent

Final phase is sequential to avoid conflicts during polish and ensure cohesive quality.

### Tasks

**Platform Testing**
- [ ] Primary platform testing
- [ ] Cross-browser verification
- [ ] Mobile responsiveness

**Bug Fixes**
- [ ] Issues from platform testing
- [ ] Cross-browser inconsistencies
- [ ] Layout issues

**Performance**
- [ ] Lighthouse audit (target ≥90)
- [ ] Bundle size analysis
- [ ] Loading optimization

**Final Testing**
- [ ] End-to-end flow testing
- [ ] Edge case verification
- [ ] User acceptance testing

### Ship Checklist

- [ ] All success criteria pass
- [ ] No P0 bugs
- [ ] Performance targets met
- [ ] Full flow tested on primary platform
- [ ] Production deployment ready

---

## Coordination Mechanisms

### Daily Sync Points

For phases with parallel agents:

**Morning (5 min):**
- What I'm building today
- Any shared files I need to touch
- Any interface questions

**Evening (5 min):**
- What I shipped
- Any contract changes needed
- Blockers for tomorrow

### Contract Change Protocol

If an agent needs to modify a shared type or interface:

1. **Propose** the change (don't just make it)
2. **Review** impact on other agent's work
3. **Coordinate** timing (both agents update their code)
4. **Merge** contract change first, then implementations

### File Ownership Enforcement

Each agent prompt should include:

```
BOUNDARY RULES:
- You own: [list of directories]
- You may read: [list of shared directories]
- You must NOT modify: [list of other agent's directories]
- If you need a shared change, describe it but don't implement it
```

---

## Risk Mitigation

### Risk: Agents Modify Same File

**Prevention:**
- Clear directory ownership
- Boundary rules in every prompt
- Shared files are read-only

**Recovery:**
- Git diff to identify conflicts
- Manual merge or coordinator agent resolves

### Risk: Interface Mismatch

**Prevention:**
- Contracts defined before parallel work
- JSDoc on all interfaces
- Type checking catches mismatches

**Recovery:**
- Integration week catches issues
- Contract change protocol for fixes

### Risk: Quality Drift

**Prevention:**
- Same design tokens for all agents
- Shared component library
- ESLint enforces consistency

**Recovery:**
- Final polish pass with single agent
- Visual review of all screens together

### Risk: Parallel Agents Slower Than Sequential

**Prevention:**
- Only 2 agents max (coordination overhead grows O(n²))
- Clear, large boundaries (not fine-grained)
- Integration buffer weeks

**Monitoring:**
- If agents are blocking each other often, collapse to 1
- If integration takes more than a week, reduce parallelism next phase

---

## Directory Structure Template

```
[project-name]/
├── app/
│   ├── layout.tsx
│   ├── page.tsx                    # Home/dashboard
│   ├── [domain-a]/
│   │   ├── page.tsx
│   │   ├── new/page.tsx
│   │   └── [id]/page.tsx
│   ├── [domain-b]/
│   │   ├── page.tsx
│   │   └── ...
│   └── ...
├── components/
│   ├── ui/                         # Base components (Foundation)
│   ├── [domain-a]/                 # Agent A
│   ├── [domain-b]/                 # Agent B
│   └── ...
├── lib/
│   ├── [database-client].ts        # Foundation
│   ├── services/
│   │   ├── [domain-a]/             # Agent A
│   │   └── [domain-b]/             # Agent B
│   └── ...
├── types/
│   ├── [domain-a].ts
│   ├── [domain-b].ts
│   └── index.ts
└── contracts/
    ├── [service-a].ts
    ├── [service-b].ts
    └── index.ts
```

---

## Summary Template

| Week | Agent(s) | Deliverables |
|------|----------|--------------|
| 1-2 | 1 | Foundation: types, contracts, base components |
| 3-N | 2 | Parallel feature development |
| N-1 | 2 | Integration testing, bug fixes |
| N | 1 | Polish, platform testing, ship |

**Estimated speedup:** ~30% faster than pure sequential (accounting for coordination overhead)

---

## Plugin Integration

**During parallel phases:**
- `/commit` — Commit completed work (each agent)
- `/code-review` — Review before integration points

**At integration points:**
- `/feature-dev` — If restructuring needed

---

## Session Management

Use [session-management.md](session-management.md) for session management across all agents.

Each agent maintains its own SESSION_STATE.md or contributes to a shared PROGRESS.md.

---

*Template version 1.0 | Part of the Workflow Documentation System*
