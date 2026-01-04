# 06: Execution Setup (Ready to Run)

> **Position:** Step 6 | After: 05-RoadmapCreation | Before: Running ralph loops
> **Requires:** Completed roadmap with execution mode (ROADMAP.md)
> **Produces:** Fully scaffolded session infrastructure — ready to run ralph loops
> **Exit State:** You can start ralph loops immediately after this step

---

## Variables

Replace these before using:
- `[PROJECT_NAME]` - Your project name
- `[ROADMAP_FILE]` - Path to your roadmap

---

## Role

**Role:** You are scaffolding session management infrastructure so the project is ready for autonomous execution.

**Context:**
- Project: `[PROJECT_NAME]`
- Roadmap: `[ROADMAP_FILE]`

---

## Part 1: Read Execution Mode from Roadmap

Your roadmap (from Step 05) already contains the execution mode. Check the header:

```markdown
> **Execution Mode:** PARALLEL-READY | Agents: 2
> **Agent A Domain:** [domain-a]
> **Agent B Domain:** [domain-b]
```
or
```markdown
> **Execution Mode:** SEQUENTIAL
```

### The Simple Rule

| Roadmap Says | You Do |
|--------------|--------|
| `PARALLEL-READY` | Parallel ralph loops (one per agent) |
| `SEQUENTIAL` | Single ralph loop |

---

## Part 2: Scaffold Session Infrastructure

Create ALL of these files. This is the complete session management setup.

### Directory Structure

```bash
mkdir -p docs PLANS scripts
```

### 1. docs/PROGRESS.md

```markdown
# [PROJECT_NAME] — Session Progress Log

> **Purpose:** Track progress across multiple sessions. Each session adds an entry.
> **How to Use:** Add a new "## Session YYYY-MM-DD" section at the TOP after each work session.

---

<!--
=== ADD NEW SESSIONS AT THE TOP ===
Most recent session should be first.
-->

## Session [DATE] (Setup)

**Phase:** Pre-implementation
**Focus:** Infrastructure scaffolding

### Completed
- [x] Set up session tracking infrastructure
- [x] Created PROGRESS.md, features.json, KNOWN_ISSUES.md
- [x] Created dev-init.sh script

### Verified
- [x] All documentation files created
- [x] Dev init script works

### Next Session Should
- Start with: Phase 0, Task 1
- Be aware of: [Any context]

---

## Pre-Implementation State

**Repository State Before Work:**
- [Describe current state]

**Key Files That Exist:**
- [List existing relevant files]

---

<!-- Template for future sessions:

## Session YYYY-MM-DD

**Phase:** X.Y
**Focus:** [One sentence describing the session goal]

### Completed
- [x] Task 1 description
- [x] Task 2 description

### Verified
- [ ] Tests pass
- [ ] Type check passes

### Notes
[Any important context for future sessions]

### Next Session Should
- Start with: [specific task]
- Be aware of: [any gotchas]

-->
```

### 2. features.json

```json
{
  "$schema": "./features.schema.json",
  "_meta": {
    "description": "Feature tracking. Status: not-started | in-progress | pass | fail | blocked",
    "lastUpdated": "[DATE]",
    "project": "[PROJECT_NAME]",
    "executionMode": "[sequential|parallel]"
  },
  "phase-0": {
    "task-1": { "status": "not-started", "notes": "" },
    "task-2": { "status": "not-started", "notes": "" }
  },
  "phase-1": {
    "feature-1": { "status": "not-started", "notes": "" },
    "feature-2": { "status": "not-started", "notes": "" }
  }
}
```

### 3. docs/KNOWN_ISSUES.md

```markdown
# [PROJECT_NAME] — Known Issues & Parking Lot

> **Purpose:** Track issues, blockers, and deferred decisions.

---

## How to Use

**Add issues here when:**
- You encounter a bug that isn't blocking current work
- You discover something that needs investigation later
- A decision needs to be made but can wait

**Format:**
```
### [PHASE-X] Brief description
**Status:** Open | Resolved | Deferred
**Severity:** Blocker | High | Medium | Low
**Discovered:** YYYY-MM-DD
**Description:** What happened
**Workaround:** (if any)
```

---

## Open Issues

*(Add issues here)*

---

## Resolved Issues

*(Move issues here when resolved)*

---

## Deferred Decisions

*(Decisions that can wait until later)*
```

### 4. scripts/dev-init.sh

```bash
#!/bin/bash
# Session Initialization Script
# Run at the start of each development session

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== [PROJECT_NAME] Session Init ===${NC}"
echo ""

# 1. Check required files
echo -e "${BLUE}Checking files...${NC}"

REQUIRED_FILES=(
    "docs/PROGRESS.md"
    "docs/KNOWN_ISSUES.md"
    "features.json"
    "ROADMAP.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
    else
        echo -e "${RED}✗ MISSING: $file${NC}"
    fi
done

# 2. Install dependencies if needed
if [ -d "node_modules" ]; then
    echo -e "${GREEN}✓${NC} node_modules exists"
else
    echo -e "${YELLOW}Installing dependencies...${NC}"
    npm install
fi

# 3. Run verification
echo ""
echo -e "${BLUE}Running verification...${NC}"

if npm run typecheck > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Type check passes"
else
    echo -e "${YELLOW}⚠${NC} Type check failed or not configured"
fi

# 4. Show progress
echo ""
echo -e "${BLUE}=== Recent Progress ===${NC}"
if [ -f "docs/PROGRESS.md" ]; then
    awk '/^## Session/{if(found)exit; found=1} found' docs/PROGRESS.md | head -20
fi

# 5. Show feature status
echo ""
echo -e "${BLUE}=== Feature Status ===${NC}"
if [ -f "features.json" ]; then
    PASS=$(grep -c '"status": "pass"' features.json 2>/dev/null || echo "0")
    FAIL=$(grep -c '"status": "fail"' features.json 2>/dev/null || echo "0")
    IN_PROGRESS=$(grep -c '"status": "in-progress"' features.json 2>/dev/null || echo "0")
    echo -e "${GREEN}Pass:${NC} $PASS | ${RED}Fail:${NC} $FAIL | ${YELLOW}In Progress:${NC} $IN_PROGRESS"
fi

# 6. Show next tasks
echo ""
echo -e "${BLUE}=== Next Tasks ===${NC}"
if [ -f "ROADMAP.md" ]; then
    grep -n "\[ \]" ROADMAP.md | head -5
fi

echo ""
echo -e "${GREEN}=== Ready ===${NC}"
```

Make it executable:
```bash
chmod +x scripts/dev-init.sh
```

### 5. PLANS/ Directory

```bash
mkdir -p PLANS
```

This is where task plans go before implementation.

---

## Part 3: Parallel-Specific Setup (if applicable)

**Skip this if your roadmap says `SEQUENTIAL`.**

### Agent Boundaries (add to ROADMAP.md or separate file)

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

### Shared (Read-Only for both):
- /types/
- /contracts/
- /components/ui/
- /lib/[database]/
```

### Commit Convention

- Agent A: `feat(domain-a): description [Agent A]`
- Agent B: `feat(domain-b): description [Agent B]`

---

## Part 4: Session Management Quick Reference

Paste this into your ROADMAP.md or keep handy:

```
╔═══════════════════════════════════════════════════════════════════════╗
║  SESSION MANAGEMENT - QUICK REFERENCE                                 ║
╠═══════════════════════════════════════════════════════════════════════╣
║                                                                       ║
║  SESSION START:                                                       ║
║    ./scripts/dev-init.sh                                              ║
║                                                                       ║
║  DURING SESSION:                                                      ║
║    • Work on ONE task at a time                                       ║
║    • Update docs after each completed task                            ║
║    • Commit frequently                                                ║
║                                                                       ║
║  CHECKPOINT (context getting long):                                   ║
║    "Update PROGRESS.md and features.json with current state"          ║
║                                                                       ║
║  SESSION END (before compaction):                                     ║
║    1. Run verification (tests, typecheck)                             ║
║    2. Add session entry to TOP of docs/PROGRESS.md                    ║
║    3. Update features.json status                                     ║
║    4. Check off tasks in ROADMAP.md                                   ║
║    5. Commit with descriptive message                                 ║
║                                                                       ║
║  IF BLOCKED:                                                          ║
║    Add to KNOWN_ISSUES.md → Move to next task                         ║
║                                                                       ║
╚═══════════════════════════════════════════════════════════════════════╝
```

---

## Part 5: Commit Infrastructure

```bash
git add docs/ PLANS/ scripts/ features.json ROADMAP.md
git commit -m "chore: scaffold session management infrastructure

- Add docs/PROGRESS.md for session tracking
- Add docs/KNOWN_ISSUES.md for parking lot
- Add features.json for pass/fail tracking
- Add scripts/dev-init.sh for session init
- Add PLANS/ directory for task plans"
```

---

## Exit Checklist

Before proceeding, verify:

- [ ] `docs/PROGRESS.md` exists with initial session entry
- [ ] `docs/KNOWN_ISSUES.md` exists
- [ ] `features.json` exists with all tasks from roadmap
- [ ] `scripts/dev-init.sh` exists and is executable
- [ ] `PLANS/` directory exists
- [ ] Infrastructure committed to git
- [ ] Execution mode confirmed from roadmap header

---

## You're Ready — Start Ralph Loops

### If SEQUENTIAL:

Open one terminal and run:

```bash
/Users/mattod/.claude/plugins/marketplaces/claude-plugins-official/plugins/ralph-wiggum/scripts/setup-ralph-loop.sh "[PHASE_FOCUS]" --completion-promise "PHASE_COMPLETE" --max-iterations 50
```

See [07-RalphLoop.md](07-RalphLoop.md) for the full autonomous execution protocol.

### If PARALLEL-READY:

Open two terminals. In each, start with the agent prompt from [07-RalphLoop.md](07-RalphLoop.md) that includes:
- Agent identity (A or B)
- Boundary rules
- Tasks for this agent
- Ralph loop command with unique completion promise

See [08-ParallelBuild.md](08-ParallelBuild.md) for coordination details.

---

## Reference: Session Protocols

For ongoing session management (session start/end prompts, checkpointing, etc.), see:
- [09-LongRunningWorkflow.md](09-LongRunningWorkflow.md) — Detailed session management reference

---

*Template version 2.0 | Part of the Workflow Documentation System*
