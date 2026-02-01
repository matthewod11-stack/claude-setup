# 04: Scoping and Roadmap Creation

> **Position:** Step 4 | After: 03-PLAN-FeedbackConsolidation | Before: 05-PLAN-RoadmapValidation
> **Requires:** Detailed spec + consolidated feedback
> **Produces:** `ROADMAP.md` + `v2_parking_lot.md`
> **Purpose:** Transform a massive spec and feedback into a focused, actionable v1 roadmap

---

## Variables

Replace these before using:
- `[PROJECT_NAME]` - Your project name
- `[PROJECT_DESCRIPTION]` - One-line description
- `[V1_SUCCESS_CRITERIA]` - Concrete success criteria (e.g., "I can fully plan a 20-person gathering using at least 2 uploaded recipes")
- `[TECH_STACK]` - Core technologies (e.g., "Next.js 14, Supabase, TypeScript")
- `[TARGET_USER]` - Who v1 is for (e.g., "Me (single user, no auth)")
- `[SPEC_FILE]` - Path to your spec document
- `[FEEDBACK_FILE]` - Path to consolidated feedback

---

## Role

**Role:** You are a product strategist and technical planner. Your job is to transform a large spec and consolidated feedback into a focused v1 roadmap that won't suffer from scope creep.

**Context:**
- Project: `[PROJECT_NAME]` — `[PROJECT_DESCRIPTION]`
- Success criteria: `[V1_SUCCESS_CRITERIA]`
- Tech Stack: `[TECH_STACK]`
- Target User: `[TARGET_USER]`
- I'm building this for myself first. Multi-user features are v2.

**Inputs:**
- `[SPEC_FILE]` — detailed specification
- `[FEEDBACK_FILE]` — consolidated feedback from multiple sources

---

## Phase 1: Strategic Scoping (Interactive)

Before diving into features, establish the strategic constraints.

**Instructions:**
Use Claude's `AskUserQuestion` tool to present 3-4 strategic questions. **Derive these from the actual spec and feedback** — don't use generic canned questions.

**Question categories to cover:**

1. **Success Criteria Validation**
   - Is the stated v1 goal still the right target?
   - Did feedback surface a different/better MVP definition?

2. **Non-Negotiables vs Nice-to-Haves**
   - What features MUST be in v1 to hit the success criteria?
   - What looked core but is actually deferrable?

3. **Architecture & Quality Stance**
   - How much technical debt is acceptable?
   - What quality bar must v1 meet? (functional only, polished, production-ready)

4. **Constraints**
   - Timeline pressure? Effort limits?
   - Any hard blockers or dependencies?

**Format:**
```
Use AskUserQuestion with:
- 3-4 questions max (batch into one call)
- Each question: 3-4 options + implicit "Other"
- Options should reflect actual tradeoffs from the feedback
- Include brief context explaining why this decision matters
```

**After receiving answers:** Document the decisions at the top of the roadmap as "Strategic Constraints."

---

## Phase 2: Domain-by-Domain Triage

Walk through each major domain/feature area in the spec. For each:

### 2.1 Summarize
What does the spec propose for this domain?

### 2.2 Surface Conflicts
What did the consolidated feedback say? Any disagreements, concerns, or alternative approaches?

### 2.3 Clarify (if needed)
If there's ambiguity or a meaningful tradeoff, ask conversationally. Don't batch these — ask as you encounter them.

### 2.4 Categorize
Place each feature into one of:

| Category | Definition |
|----------|------------|
| **V1 Core** | Required to hit `[V1_SUCCESS_CRITERIA]`. Ship blocker. |
| **V1 Polish** | Not required, but significantly improves v1 quality. Include if time allows. |
| **V2** | Deferred. Doesn't block v1 success. |

**Output:** Feature categorization table

```markdown
| Feature | Domain | Category | Rationale |
|---------|--------|----------|-----------|
| Recipe import | Recipes | V1 Core | Can't plan meals without recipes |
| Recipe scaling | Recipes | V1 Polish | Helpful but manual calc works |
| Multi-user sharing | Social | V2 | Only matters with multiple users |
```

---

## Phase 3: Dependency Mapping & Sequencing

### 3.1 Dependency Mapping

For each V1 feature, identify:
- **Requires:** What must exist before this works?
- **Enables:** What does this unblock?
- **Parallel:** Can this be built alongside other features?

```
Foundation → Recipe CRUD
Recipe CRUD → Recipe Import
Recipe CRUD → Meal Planning (parallel to Import)
Meal Planning → Shopping List
```

### 3.2 Parallelizability Analysis

Answer: **Can features be cleanly split into independent domains?**

**Criteria for parallel execution:**
- [ ] Features belong to distinct domains (e.g., "recipes" vs "meals")
- [ ] Each domain has its own routes, services, and components
- [ ] Domains share contracts/types but don't modify each other's implementation
- [ ] Integration points are well-defined interfaces, not shared state

**If parallelizable:**
```markdown
> **Execution Mode:** PARALLEL-READY | Agents: 2
> **Agent A Domain:** [domain-a] (routes, services, components)
> **Agent B Domain:** [domain-b] (routes, services, components)
> **Shared (read-only):** types/, contracts/, components/ui/, lib/
```

**If sequential:**
```markdown
> **Execution Mode:** SEQUENTIAL
> **Reason:** [why parallelization doesn't work]
```

### 3.3 Phase Definition

Group features into phases:

**Phase 0: Foundation**
- Project scaffolding, core types, database schema
- Base UI components, essential infrastructure
- Goal: `npm run dev` shows a working shell

**Phase 1-N: Feature Phases**
- Group by domain or dependency chain
- Each phase = a usable increment
- 3-7 tasks per phase
- Natural pause points for review

---

## Phase 4: Task Breakdown

For each V1 feature, define:

```markdown
### [Feature Name]

**Why V1:** [Ties to success criteria]

**Tasks:**
- [ ] **[Task Name]**
  - Scope: [What's in / what's explicitly out]
  - Acceptance: [How to verify it's done]
  - Verification: [test / manual / visual]

- [ ] **[Task Name]**
  - Scope: [...]
  - Acceptance: [...]
  - Verification: [...]

**Risks:** [Any technical uncertainty or scope creep potential]
```

---

## Phase 5: Output Generation

Generate two files:

### File 1: `ROADMAP.md`

```markdown
# [PROJECT_NAME] — V1 Roadmap

> **V1 Goal:** [V1_SUCCESS_CRITERIA]
> **Tech Stack:** [TECH_STACK]
> **Target User:** [TARGET_USER]
> **Created:** [DATE]
> **Execution Mode:** [PARALLEL-READY | SEQUENTIAL]

---

## Strategic Constraints

Decisions made during scoping:
- [Decision 1]: [Choice made] — [rationale]
- [Decision 2]: [Choice made] — [rationale]

---

## Phase Overview

| Phase | Focus | Tasks | Pause Point |
|-------|-------|-------|-------------|
| 0 | Foundation | X | Review scaffolding |
| 1 | [Name] | X | [Checkpoint] |
| 2 | [Name] | X | [Checkpoint] |

---

## Phase 0: Foundation

**Goal:** Establish project infrastructure before feature work.

### Tasks
- [ ] Project scaffolding ([TECH_STACK] setup)
- [ ] Core types and interfaces
- [ ] Database schema and migrations
- [ ] Base UI component library

### Deliverables
- [ ] `npm run dev` shows styled app shell
- [ ] Database connected, can read/write
- [ ] All type files compile without errors

### Pause Point 0A
**Review:** Verify foundation is solid before feature work.

---

## Phase 1: [Feature Group Name]

**Goal:** [One sentence outcome]

### [Feature Name]

**Why V1:** [Ties to success criteria]

**Tasks:**
- [ ] **[Task Name]**
  - Scope: [in/out]
  - Acceptance: [criteria]
  - Verification: [method]

### Deliverables
- [ ] [Tangible outcome]

### Pause Point 1A
**Review:** [What to verify]

---

[Continue for all phases...]

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
| [Description] | [How to handle] | [When] |
```

### File 2: `v2_parking_lot.md`

```markdown
# V2 Parking Lot — [PROJECT_NAME]

Everything deferred from v1, organized for future planning.

---

## By Theme

### [Theme 1: e.g., Multi-User Features]

| Feature | Impact | Lift | Notes |
|---------|--------|------|-------|
| User authentication | High | High | Required for any sharing |
| Shared meal plans | High | Medium | Enables collaboration |
| Permission system | Medium | High | Only if sharing is complex |

### [Theme 2: e.g., Enhanced Recipes]

| Feature | Impact | Lift | Notes |
|---------|--------|------|-------|
| Recipe scaling | Medium | Low | Quality of life |
| Nutrition info | Low | High | Requires API integration |
| Recipe suggestions | Medium | High | AI/ML complexity |

### [Theme 3: e.g., Integrations]

| Feature | Impact | Lift | Notes |
|---------|--------|------|-------|

---

## Quick Reference Matrix

For prioritization — pick high-impact, low-lift items first.

| | Low Lift | Medium Lift | High Lift |
|-------------|----------|-------------|-----------|
| **High Impact** | [features] | [features] | [features] |
| **Medium Impact** | [features] | [features] | [features] |
| **Low Impact** | [features] | [features] | [features] |

---

## Open Questions for V2

Questions that didn't need answering for v1:
- [Question]
- [Question]

---

## Dependencies on V1

Features that require v1 to be complete first:
- [Feature] — requires [v1 feature] to exist
```

---

## Scoping Guidelines

When deciding V1 vs V2:

1. **Does it help achieve `[V1_SUCCESS_CRITERIA]`?** If no → V2
2. **Does it require multi-user infrastructure?** If yes → V2
3. **Is it polish or function?** Function first, but quality bar is a v1 requirement
4. **What's the dependency chain?** If B requires A, and A is v1, consider B

When sequencing:
1. Each feature should be a vertical slice you can complete and use
2. Earlier features should unblock later ones
3. Flag higher-risk items that might need iteration

---

## Verification

Before marking this step complete:
- [ ] All features from spec appear (categorized as v1 or v2)
- [ ] Strategic decisions documented
- [ ] Dependencies mapped and sequenced correctly
- [ ] Each v1 task has acceptance criteria
- [ ] Pause points allow for human review
- [ ] V2 parking lot has impact/lift ratings
- [ ] Out of scope list prevents creep

---

## Next Step

Proceed to: **[05-PLAN-RoadmapValidation.md](05-PLAN-RoadmapValidation.md)** to validate the roadmap before execution.

---

*Template version 1.0 | Part of the Workflow Documentation System*
