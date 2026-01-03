# 06: Execution Setup

> **Position:** Step 6 | After: 05-RoadmapCreation | Before: 07/08 (execution)
> **Requires:** Completed roadmap (ROADMAP.md)
> **Produces:** Execution strategy recommendation + scaffolded session infrastructure

---

## Variables

Replace these before using:
- `[PROJECT_NAME]` - Your project name
- `[ROADMAP_FILE]` - Path to your roadmap
- `[TIMELINE]` - Estimated build duration

---

## Role

**Role:** You are a technical lead helping select the optimal build strategy and scaffolding the necessary session management infrastructure.

**Context:**
- Project: `[PROJECT_NAME]`
- Roadmap: `[ROADMAP_FILE]`
- Timeline: `[TIMELINE]`

---

## Your Task

1. Evaluate project characteristics using the decision tree
2. Recommend an execution strategy
3. Scaffold the required infrastructure files
4. Prepare the first task for execution

---

## Part 1: Strategy Decision Tree

Answer these questions about `[PROJECT_NAME]`:

### Q1: Timeline Pressure

How tight is the deadline?

- **A) Aggressive** — Need maximum velocity, willing to accept coordination overhead
- **B) Comfortable** — Quality over speed, can work sequentially
- **C) Fixed but realistic** — Deadline exists but scope fits

### Q2: Feature Independence

How separable are the features in your roadmap?

- **A) Highly dependent** — Features chain together, must be sequential
- **B) Partially independent** — Some features can be built in parallel
- **C) Mostly independent** — Clear boundaries between feature domains

### Q3: Risk Tolerance

How much can break during development?

- **A) Low tolerance** — Need frequent human checkpoints, review each feature
- **B) Medium tolerance** — Can tolerate minor issues, review at phase boundaries
- **C) High tolerance** — Prototype mode, fix issues at the end

### Q4: Verification Capability

How will you verify work is correct?

- **A) Comprehensive test suite** — Can run automated tests after each change
- **B) Manual verification** — Need to manually check each feature
- **C) Mixed** — Some automated, some manual verification

### Q5: Codebase State

What's the starting point?

- **A) Greenfield** — Starting from scratch
- **B) Small existing** — Some code exists, patterns established
- **C) Large existing** — Significant codebase with conventions

---

## Part 2: Strategy Recommendations

### Ralph Loop — [07-RalphLoop.md](07-RalphLoop.md)

**Choose when:**
- Features are sequential (Q2 = A)
- Have test suite or clear verification (Q4 = A or C)
- Comfortable timeline (Q1 = B or C)
- Want hands-off autonomous execution

**How it works:**
- Single agent works through roadmap tasks sequentially
- Plan → Execute → Verify loop for each task
- Commits after each completed task
- Natural pause points at phase boundaries

**Best for:**
- Well-defined features with clear acceptance criteria
- Test-driven development workflows
- Overnight or background execution runs

**Plugin:** `/ralph-loop`

---

### Parallel Build — [08-ParallelBuild.md](08-ParallelBuild.md)

**Choose when:**
- Features can parallelize (Q2 = B or C)
- Tight deadline (Q1 = A)
- Clear boundaries between components
- Can manage coordination overhead

**How it works:**
- Multiple agents work on different feature domains
- Each agent owns specific directories/files
- Daily sync points to catch integration issues
- Merge coordination at phase boundaries

**Best for:**
- Larger projects with separable domains
- Compressed timelines where parallelism pays off
- Teams (or multi-agent setups) with clear ownership

**Pattern:**
```
Phase 0: Sequential (Foundation)    — 1 agent
Phase 1-N: Parallel (Features)      — 2+ agents
Final: Sequential (Integration)     — 1 agent
```

---

### Hybrid Approach

**Choose when:**
- Foundation needs sequential work, then features can parallelize
- Some features are independent, others chain
- Want flexibility to adjust during execution

**Pattern:**
1. Start with Ralph Loop for Foundation (Phase 0)
2. Switch to Parallel Build for Core Features
3. Return to Ralph Loop for Integration/Polish

**Implementation:**
- Scaffold for Long-Running Workflow (session management)
- Define agent boundaries for parallel phases
- Use Ralph Loop within each agent's work

---

## Decision Matrix

| Q1 | Q2 | Q3 | Q4 | Q5 | Recommendation |
|----|----|----|----|----|----------------|
| B/C | A | Any | A | Any | **Ralph Loop** |
| A | B/C | B/C | A/C | Any | **Parallel Build** |
| Any | Mixed | A | B | Any | **Hybrid** (Ralph + checkpoints) |
| A | A | C | A | A | **Ralph Loop** (speed from tests) |

**When in doubt:** Start with Ralph Loop. It's simpler to manage and you can always parallelize later if bottlenecked.

---

## Part 3: Infrastructure Scaffolding

Based on your selected strategy, create these artifacts:

### For All Strategies (Long-Running Foundation)

Create in project root:

**1. SESSION_STATE.md** (or docs/PROGRESS.md)
```markdown
# [PROJECT_NAME] — Session Progress Log

> **Purpose:** Track progress across sessions.
> **How to Use:** Add new session entries at TOP.

---

## Session [DATE] (Setup)

**Phase:** Pre-implementation
**Focus:** Infrastructure scaffolding

### Completed
- [x] Created session management files
- [x] Selected execution strategy: [STRATEGY]

### Next Session Should
- Start with: Phase 0, Task 1
- Be aware of: [Any context]

---
```

**2. features.json**
```json
{
  "_meta": {
    "project": "[PROJECT_NAME]",
    "lastUpdated": "[DATE]",
    "strategy": "[ralph-loop|parallel-build|hybrid]"
  },
  "phase-0": {
    "task-1": { "status": "not-started", "notes": "" }
  }
}
```

**3. PLANS/** directory
```
mkdir -p PLANS
```

**4. scripts/dev-init.sh**
```bash
#!/bin/bash
# Session initialization - run at start of each session
echo "=== [PROJECT_NAME] Session Init ==="
echo ""
echo "Recent Progress:"
head -30 SESSION_STATE.md 2>/dev/null || head -30 docs/PROGRESS.md
echo ""
echo "Next Tasks:"
grep -n "\[ \]" ROADMAP.md | head -5
echo ""
echo "=== Ready ==="
```

### Additional for Ralph Loop

Configure Ralph Loop parameters:
```
Completion Promise: PHASE_COMPLETE
Max Iterations: 50 (adjust based on phase size)
```

### Additional for Parallel Build

**1. Define Agent Boundaries**

In ROADMAP.md or separate file:
```markdown
## Agent Boundaries

### Agent A Owns:
- /app/[domain-a]/
- /lib/services/[domain-a]/
- /components/[domain-a]/

### Agent B Owns:
- /app/[domain-b]/
- /lib/services/[domain-b]/
- /components/[domain-b]/

### Shared (Read-Only):
- /types/
- /lib/utils/
- /components/ui/
```

**2. Integration Points**
Document where agents must coordinate:
```markdown
## Integration Points

| Point | Agent A Provides | Agent B Consumes |
|-------|------------------|------------------|
| [Name] | [Interface/Data] | [How used] |
```

---

## Part 4: First Task Preparation

Before ending this setup step:

1. **Identify first task** from Phase 0 of roadmap
2. **Mark it as in_progress** in features.json
3. **Create initial plan file** in PLANS/:
   ```markdown
   # Plan: [Task Name]

   ## Objective
   [One sentence]

   ## Files to Create/Modify
   - [file1]
   - [file2]

   ## Steps
   1. [Step]
   2. [Step]

   ## Verification
   - [ ] [How to verify]
   ```

---

## Plugin Integration

During execution setup:
- `/commit` — Commit scaffolded infrastructure files
- `/ralph-loop` — Start autonomous loop (if Ralph Loop selected)

After setup:
- Use `/feature-dev` to break down first feature if needed

---

## Verification

Before proceeding to execution:
- [ ] Strategy selected and documented
- [ ] SESSION_STATE.md (or PROGRESS.md) created
- [ ] features.json created with all tasks
- [ ] PLANS/ directory exists
- [ ] dev-init.sh created and executable
- [ ] First task identified and plan created
- [ ] Infrastructure committed to git

---

## Next Step

Based on your strategy selection:
- **Ralph Loop** → Proceed to **[07-RalphLoop.md](07-RalphLoop.md)**
- **Parallel Build** → Proceed to **[08-ParallelBuild.md](08-ParallelBuild.md)**
- **Hybrid** → Start with **[07-RalphLoop.md](07-RalphLoop.md)** for Phase 0

All strategies use **[09-LongRunningWorkflow.md](09-LongRunningWorkflow.md)** for session management.

---

*Template version 1.0 | Part of the Workflow Documentation System*
