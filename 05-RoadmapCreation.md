# 05: Roadmap Creation

> **Position:** Step 5 | After: 03-FeedbackConsolidation (or 04-V1Scoping) | Before: 06-ExecutionSetup
> **Requires:** Detailed spec + consolidated feedback (or v1_roadmap.md from scoping)
> **Produces:** Actionable implementation roadmap with phases, tasks, and verification criteria

---

## Variables

Replace these before using:
- `[PROJECT_NAME]` - Your project name
- `[V1_GOAL]` - Single-sentence success criteria
- `[TECH_STACK]` - Core technologies (e.g., "Next.js 14, Supabase, TypeScript")
- `[TIMELINE]` - Estimated build duration (e.g., "8 weeks")
- `[SPEC_FILE]` - Path to your spec document
- `[FEEDBACK_FILE]` - Path to consolidated feedback (or v1_roadmap.md)
- `[OUTPUT_FILE]` - Where to save the roadmap (default: ROADMAP.md)

---

## Role

**Role:** You are a technical product strategist creating an actionable implementation roadmap from a specification and feedback.

**Context:**
- Project: `[PROJECT_NAME]`
- Goal: `[V1_GOAL]`
- Tech Stack: `[TECH_STACK]`
- Timeline: `[TIMELINE]`
- Target User: Solo developer (me), building for personal use first

---

## Your Task

Transform the spec and consolidated feedback into a phased implementation roadmap that:
1. Sequences features by dependency
2. Groups related work into logical phases
3. Defines clear deliverables and verification criteria per feature
4. Creates natural stopping points for review

---

## Process

### Step 1: Feature Extraction

Extract all features from `[SPEC_FILE]` and `[FEEDBACK_FILE]`:

**Core Features** (must have for v1 goal):
- Features directly tied to `[V1_GOAL]`
- Without these, the app doesn't fulfill its purpose

**Supporting Features** (enable core features):
- Infrastructure, utilities, shared components
- Not user-facing but necessary

**Polish Features** (quality of life):
- Nice-to-haves that improve UX
- Can be descoped if timeline is tight

### Step 2: Dependency Mapping

For each feature, answer:
- **Requires:** What must exist before this works?
- **Enables:** What does this unblock?
- **Parallel:** Can this be built alongside other features?

Create a simple dependency list:
```
Feature A → Foundation
Feature B → Feature A
Feature C → Foundation (parallel to A)
```

### Step 2.5: Parallelizability Analysis ⭐

**This step determines your execution strategy.** Answer this question:

> Can features be cleanly split into independent domains with clear file ownership?

**Criteria for parallelization:**
- [ ] Features belong to distinct domains (e.g., "recipes" vs "meals")
- [ ] Each domain has its own routes, services, and components
- [ ] Domains share contracts/types but don't modify each other's implementation
- [ ] Integration points are well-defined interfaces, not shared state

**If YES (parallelizable):**
- Mark the roadmap as `PARALLEL-READY`
- Define agent boundaries (which domain each agent owns)
- Execution will use 2+ ralph loops simultaneously

**If NO (sequential):**
- Mark the roadmap as `SEQUENTIAL`
- Features must be built in dependency order
- Execution will use 1 ralph loop

**Output format (add to roadmap header):**
```markdown
> **Execution Mode:** PARALLEL-READY | Agents: 2
> **Agent A Domain:** [domain-a] (routes, services, components)
> **Agent B Domain:** [domain-b] (routes, services, components)
> **Shared (read-only):** types/, contracts/, components/ui/, lib/[database]/
```
or
```markdown
> **Execution Mode:** SEQUENTIAL
> **Reason:** [why parallelization doesn't work for this project]
```

### Step 3: Phase Definition

Group features into phases:

**Phase 0: Foundation**
- Project scaffolding
- Core types and interfaces
- Database schema
- Base UI components
- Essential infrastructure

**Phase 1-N: Feature Phases**
- Group by domain or dependency chain
- Each phase should be a usable increment
- Aim for 3-7 tasks per phase
- Include buffer/integration time in later phases

### Step 4: Task Breakdown

For each feature, define:
- **Task Name:** Clear, action-oriented
- **Scope:** What's in, what's explicitly out
- **Acceptance Criteria:** How to know it's done
- **Verification Method:** Test, manual check, visual review, etc.
- **Estimated Effort:** S/M/L (optional)

### Step 5: Risk Identification

Flag items that:
- Have technical uncertainty
- Depend on external services/APIs
- Might need iteration
- Could cause scope creep

---

## Output Format

Create `[OUTPUT_FILE]` with this structure:

```markdown
# [PROJECT_NAME] — Implementation Roadmap

> **V1 Goal:** [V1_GOAL]
> **Tech Stack:** [TECH_STACK]
> **Timeline:** [TIMELINE]
> **Created:** [DATE]
> **Execution Mode:** [PARALLEL-READY | SEQUENTIAL]
> **Agent Boundaries:** [if parallel, list domains per agent]

---

## Session Management

This is a multi-session implementation. Follow [09-LongRunningWorkflow.md](09-LongRunningWorkflow.md) protocol.

**Before Each Session:**
```bash
./scripts/dev-init.sh
```

**Single-Task Rule:** Work on ONE checkbox item per session.

---

## Phase Overview

| Phase | Focus | Tasks | Pause Point |
|-------|-------|-------|-------------|
| 0 | Foundation | X | Review scaffolding |
| 1 | [Name] | X | [Checkpoint] |
| 2 | [Name] | X | [Checkpoint] |
| ... | ... | ... | ... |

---

## Phase 0: Foundation

**Goal:** Establish project infrastructure before feature work.

### Tasks
- [ ] Project scaffolding ([TECH_STACK] setup)
- [ ] Core types and interfaces
- [ ] Database schema and migrations
- [ ] Base UI component library
- [ ] Essential utilities (auth, API client, etc.)

### Deliverables
- [ ] `npm run dev` shows styled app shell
- [ ] Database connected, can read/write
- [ ] All type files compile without errors

### Pause Point 0A
**Review:** Verify foundation is solid before feature work.

---

## Phase 1: [Feature Group Name]

**Goal:** [One sentence describing the outcome]

### Tasks
- [ ] **[Task Name]**
  - Scope: [What's included]
  - Acceptance: [How to verify]
  - Verification: [Method: test/manual/visual]

- [ ] **[Task Name]**
  - Scope: [What's included]
  - Acceptance: [How to verify]
  - Verification: [Method]

### Deliverables
- [ ] [Tangible outcome 1]
- [ ] [Tangible outcome 2]

### Pause Point 1A
**Review:** [What to verify before proceeding]

---

## Phase 2: [Feature Group Name]

[Same structure as Phase 1]

---

## Out of Scope (V1)

Explicit list to prevent scope creep:
- [Feature] — revisit in v2
- [Feature] — only matters with multiple users
- [Feature] — nice-to-have, not essential

---

## Risks & Watch Items

| Risk | Mitigation | Phase |
|------|------------|-------|
| [Description] | [How to handle] | [When it applies] |

---

## Linear Checklist

For external tracking:

```
PHASE 0 - FOUNDATION
[ ] Task 1
[ ] Task 2
[ ] PAUSE 0A: Review

PHASE 1 - [NAME]
[ ] Task 1
[ ] Task 2
[ ] PAUSE 1A: Verify
```
```

---

## Plugin Integration

After creating the roadmap:
- Use `/feature-dev` to validate the first feature's breakdown
- Consider running the roadmap through `02-RoadmapReview.md` for a second opinion

---

## Verification

Before marking this step complete:
- [ ] All features from spec appear in roadmap
- [ ] Dependencies are explicit and sequenced correctly
- [ ] Each task has clear acceptance criteria
- [ ] Verification method defined for each task
- [ ] Pause points allow for human review
- [ ] Out of scope list prevents creep

---

## Next Step

Proceed to: **[06-ExecutionSetup.md](06-ExecutionSetup.md)** to select execution strategy and scaffold session infrastructure.

---

*Template version 1.0 | Part of the Workflow Documentation System*
