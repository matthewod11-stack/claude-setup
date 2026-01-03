# 09: Long-Running Agent Workflow

> **Position:** Session Management Layer | Used with: 07-RalphLoop, 08-ParallelBuild
> **Purpose:** Template for setting up multi-session Claude Code projects that maintain continuity across context windows.
> **Based on:** [Anthropic: Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
> **Created:** 2025-11-27

---

## When to Use This Template

Use this workflow when your project:
- Will span multiple Claude Code sessions (multi-week implementation)
- Has many discrete tasks/features to track
- Requires context to survive compaction
- Benefits from explicit progress tracking

**Examples:** Desktop app builds, major refactors, new feature implementations, migrations

---

## Core Concepts

### The Problem

> "Each new session begins with no memory of what came before."

Context compaction alone is insufficient. Claude loses details, forgets decisions, and may repeat work or contradict earlier choices.

### The Solution

**Structured artifacts** that survive context loss:

| Artifact | Purpose |
|----------|---------|
| `PROGRESS.md` | Session-by-session log of completed work |
| `ROADMAP.md` | Checkbox tracking of all tasks |
| `features.json` | Machine-readable pass/fail status |
| `KNOWN_ISSUES.md` | Parking lot for blockers |
| `dev-init.sh` | Consistent session startup |
| Git commits | Recovery points with context |

### Key Principles

1. **Single-Feature-Per-Session** — Work on ONE task at a time to prevent scope creep
2. **Update Docs After Every Task** — Not just at session end
3. **JSON Over Markdown for Tracking** — Resists inappropriate model edits
4. **Explicit Handoff Notes** — "Next Session Should..." in PROGRESS.md
5. **Verification Before Marking Complete** — Tests must pass

---

## Quick Reference Card

```
╔═══════════════════════════════════════════════════════════════════════╗
║  LONG-RUNNING PROJECT SESSION MANAGEMENT                              ║
╠═══════════════════════════════════════════════════════════════════════╣
║                                                                       ║
║  SESSION START:                                                       ║
║    ./scripts/dev-init.sh                                              ║
║                                                                       ║
║  DURING SESSION:                                                      ║
║    • Work on ONE task at a time                                       ║
║    • Update docs after each completed task                            ║
║    • Commit frequently with descriptive messages                      ║
║                                                                       ║
║  CHECKPOINT (anytime, especially if context getting long):            ║
║    "Update PROGRESS.md and features.json with current state"          ║
║                                                                       ║
║  SESSION END (before compaction or stopping work):                    ║
║    "Before ending: Please follow session end protocol:                ║
║     1. Run verification                                               ║
║     2. Add session entry to TOP of PROGRESS.md                        ║
║     3. Update features.json with pass/fail status                     ║
║     4. Check off completed task in ROADMAP.md                         ║
║     5. Commit with descriptive message                                ║
║     What's the 'Next Session Should' note for PROGRESS.md?"           ║
║                                                                       ║
║  IF BLOCKED:                                                          ║
║    Add to KNOWN_ISSUES.md → Move to next independent task             ║
║                                                                       ║
╚═══════════════════════════════════════════════════════════════════════╝
```

---

## Session Workflow Diagram

```
SESSION START                    DURING SESSION                    SESSION END
─────────────                    ──────────────                    ───────────

./scripts/dev-init.sh            Work on ONE task                  Context getting long?
       │                                │                                 │
       ▼                                ▼                                 ▼
Read PROGRESS.md ──────────────► Complete task ◄─────────────── Paste end prompt
       │                                │                                 │
       ▼                                ▼                                 ▼
Read features.json                Update docs                      Update all docs
       │                                │                                 │
       ▼                                ▼                                 ▼
Check KNOWN_ISSUES                  Commit                            Commit
       │                                │                                 │
       ▼                                ▼                                 ▼
Pick next task ─────────────────► Next task? ────────────────────► Session ends
                                   (if context
                                    allows)
```

---

## File Templates

### 1. PROGRESS.md

```markdown
# [Project Name] — Session Progress Log

> **Purpose:** Track progress across multiple Claude Code sessions. Each session adds an entry.
> **How to Use:** Add a new "## Session YYYY-MM-DD" section at the TOP of this file after each work session.

---

<!--
=== ADD NEW SESSIONS AT THE TOP ===
Most recent session should be first.
-->

## Session YYYY-MM-DD (Planning)

**Phase:** Pre-implementation
**Focus:** Documentation and session infrastructure setup

### Completed
- [x] Set up session tracking infrastructure
- [x] Created ROADMAP.md with task breakdown
- [x] Created features.json for pass/fail tracking

### Verified
- [x] All documentation files created
- [x] Dev init script works

### Notes
- Applied long-running agent patterns from Anthropic article

### Next Session Should
- Start with: [First actual implementation task]
- Be aware of: [Any context needed]

---

## Pre-Implementation State

**Repository State Before Work:**
- [Describe current state]

**Key Files That Exist:**
- [List existing relevant files]

**Key Files That Need Creation:**
- [List files to be created]

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
- [ ] [Phase-specific verification]

### Notes
[Any important context for future sessions]

### Next Session Should
- Start with: [specific task or verification]
- Be aware of: [any gotchas or considerations]

-->
```

### 2. ROADMAP.md

```markdown
# [Project Name] — Implementation Roadmap

> **Purpose:** Actionable checklist for implementation.
> **Related Docs:** [SESSION_PROTOCOL.md](./SESSION_PROTOCOL.md) | [PROGRESS.md](./PROGRESS.md)

---

## Session Management

This is a **long-running, multi-session implementation**. Follow these rules:

### Before Each Session
\`\`\`bash
./scripts/dev-init.sh
\`\`\`

### Single-Feature-Per-Session Rule
> **CRITICAL:** Work on ONE checkbox item per session. This prevents scope creep.

### After Each Session
1. Run verification
2. Update PROGRESS.md with session entry
3. Update features.json status
4. Check off completed tasks
5. Commit with descriptive message

---

## Phase Overview

| Phase | Focus | Pause Points |
|-------|-------|--------------|
| 0 | Pre-flight validation | 0A: Review baseline |
| 1 | [Phase 1 name] | 1A: [Checkpoint] |
| 2 | [Phase 2 name] | — |
| ... | ... | ... |

---

## Phase 0: Pre-Flight Validation

**Goal:** Confirm starting point is solid

### Tasks
- [ ] Run existing tests
- [ ] Verify build works
- [ ] Document current state
- [ ] Create feature inventory

### Pause Point 0A
**Action Required:** Review and approve proceeding

---

## Phase 1: [Name]

**Goal:** [One sentence goal]

### Tasks
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

### Deliverables
- [ ] [What should exist when done]

### Pause Point 1A
**Action Required:** [What to verify]

---

## Linear Checklist (All Tasks)

Copy this to external tracking if needed:

\`\`\`
PHASE 0 - PRE-FLIGHT
[ ] Task 1
[ ] Task 2
[ ] PAUSE 0A: Review

PHASE 1 - [NAME]
[ ] Task 1
[ ] Task 2
[ ] PAUSE 1A: Verify
\`\`\`
```

### 3. features.json

```json
{
  "$schema": "./features.schema.json",
  "_meta": {
    "description": "Feature tracking. Status: not-started | in-progress | pass | fail | blocked",
    "lastUpdated": "YYYY-MM-DD",
    "totalFeatures": 0,
    "passing": 0,
    "failing": 0,
    "inProgress": 0
  },
  "phase-0": {
    "pre-flight-validation": { "status": "not-started", "notes": "Verify starting state" }
  },
  "phase-1": {
    "feature-1": { "status": "not-started", "notes": "Description" },
    "feature-2": { "status": "not-started", "notes": "Description" }
  }
}
```

### 4. KNOWN_ISSUES.md

```markdown
# [Project Name] — Known Issues & Parking Lot

> **Purpose:** Track issues, blockers, and deferred decisions.
> **Related Docs:** [ROADMAP.md](./ROADMAP.md) | [PROGRESS.md](./PROGRESS.md)

---

## How to Use This Document

**Add issues here when:**
- You encounter a bug that isn't blocking current work
- You discover something that needs investigation later
- A decision needs to be made but can wait
- You find edge cases that need handling eventually

**Format:**
\`\`\`markdown
### [PHASE-X] Brief description
**Status:** Open | In Progress | Resolved | Deferred
**Severity:** Blocker | High | Medium | Low
**Discovered:** YYYY-MM-DD
**Description:** What happened / what's the issue
**Workaround:** (if any)
**Resolution:** (when resolved)
\`\`\`

---

## Open Issues

*(Add issues here)*

---

## Resolved Issues

*(Move issues here when resolved)*

---

## Deferred Decisions

*(Decisions that can wait until later)*

---

## Edge Cases to Handle

| Case | Phase | Priority | Notes |
|------|-------|----------|-------|
| Example edge case | 3 | Low | Handle later |

```

### 5. SESSION_PROTOCOL.md

```markdown
# [Project Name] — Session Protocol

> **Purpose:** Ensure continuity across multiple Claude Code sessions.
> **Based on:** [Anthropic: Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)

---

## Core Principle

> "Each new session begins with no memory of what came before."

We use **structured artifacts** to maintain continuity:

| Artifact | Purpose | Location |
|----------|---------|----------|
| **PROGRESS.md** | Log of completed work | `docs/PROGRESS.md` |
| **ROADMAP.md** | Checkbox tracking | `docs/ROADMAP.md` |
| **features.json** | Pass/fail status | `features.json` |
| **KNOWN_ISSUES.md** | Parking lot | `docs/KNOWN_ISSUES.md` |

---

## Quick Reference Card

\`\`\`
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
║    "Before ending: Please follow session end protocol..."             ║
║                                                                       ║
║  IF BLOCKED:                                                          ║
║    Add to KNOWN_ISSUES.md → Move to next task                         ║
║                                                                       ║
╚═══════════════════════════════════════════════════════════════════════╝
\`\`\`

---

## Session Start Protocol

1. **Run init script:** `./scripts/dev-init.sh`
2. **Read progress:** `cat docs/PROGRESS.md`
3. **Check features:** `cat features.json`
4. **Verify previous work:** Run tests
5. **Check blockers:** `cat docs/KNOWN_ISSUES.md`
6. **Pick next task:** First unchecked in ROADMAP.md

---

## Session End Protocol

1. Run verification (tests, type-check)
2. Add entry to TOP of PROGRESS.md
3. Update features.json status
4. Check off tasks in ROADMAP.md
5. Commit with descriptive message
6. Note "Next Session Should" in PROGRESS.md
```

### 6. dev-init.sh

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

echo -e "${BLUE}=== Session Init ===${NC}"
echo ""

# 1. Confirm directory
EXPECTED_DIR="[PROJECT_NAME]"  # <-- CUSTOMIZE THIS
CURRENT_DIR=$(basename "$PWD")

if [ "$CURRENT_DIR" != "$EXPECTED_DIR" ]; then
    echo -e "${RED}ERROR: Expected to be in $EXPECTED_DIR${NC}"
    echo "Current: $PWD"
    exit 1
fi
echo -e "${GREEN}✓ Working directory confirmed${NC}"

# 2. Check required files
echo ""
echo -e "${BLUE}Checking files...${NC}"

REQUIRED_FILES=(
    "docs/ROADMAP.md"
    "docs/PROGRESS.md"
    "docs/SESSION_PROTOCOL.md"
    "features.json"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
    else
        echo -e "${RED}✗ MISSING: $file${NC}"
    fi
done

# 3. Install dependencies if needed
if [ -d "node_modules" ]; then
    echo -e "${GREEN}✓${NC} node_modules exists"
else
    echo -e "${YELLOW}Installing dependencies...${NC}"
    npm install
fi

# 4. Run verification
echo ""
echo -e "${BLUE}Running verification...${NC}"

if npm run type-check > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Type check passes"
else
    echo -e "${RED}✗${NC} Type check FAILED"
fi

if npm test -- --passWithNoTests > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Tests pass"
else
    echo -e "${RED}✗${NC} Tests FAILED"
fi

# 5. Show progress
echo ""
echo -e "${BLUE}=== Recent Progress ===${NC}"
if [ -f "docs/PROGRESS.md" ]; then
    awk '/^## Session/{if(found)exit; found=1} found' docs/PROGRESS.md | head -25
fi

# 6. Show feature status
echo ""
echo -e "${BLUE}=== Feature Status ===${NC}"
if [ -f "features.json" ]; then
    PASS=$(grep -c '"status": "pass"' features.json 2>/dev/null || echo "0")
    FAIL=$(grep -c '"status": "fail"' features.json 2>/dev/null || echo "0")
    IN_PROGRESS=$(grep -c '"status": "in-progress"' features.json 2>/dev/null || echo "0")
    echo -e "${GREEN}Pass:${NC} $PASS | ${RED}Fail:${NC} $FAIL | ${YELLOW}In Progress:${NC} $IN_PROGRESS"
fi

# 7. Show next tasks
echo ""
echo -e "${BLUE}=== Next Tasks ===${NC}"
if [ -f "docs/ROADMAP.md" ]; then
    grep -n "\[ \]" docs/ROADMAP.md | head -5
fi

echo ""
echo -e "${GREEN}=== Ready ===${NC}"
```

---

## Session Prompts

### Session Start Prompt

```
I'm continuing work on [PROJECT NAME].

This is a multi-session implementation. Please follow the session protocol:

1. Run ./scripts/dev-init.sh to verify environment
2. Read docs/PROGRESS.md for previous session work
3. Read docs/ROADMAP.md to find the NEXT unchecked task
4. Check features.json for pass/fail status
5. Check docs/KNOWN_ISSUES.md for any blockers

Work on ONE task only (single-feature-per-session rule). Tell me what's next.
```

### Session End Prompt

```
Before ending: Please follow session end protocol:

1. Run verification (tests, type-check)
2. Add session entry to TOP of docs/PROGRESS.md
3. Update features.json with pass/fail status
4. Check off completed task in docs/ROADMAP.md
5. Commit with descriptive message

What's the "Next Session Should" note for PROGRESS.md?
```

### Checkpoint Prompt (Mid-Session)

```
Let's checkpoint. Update docs/PROGRESS.md and features.json
with current state, then we can continue.
```

### After Long Break Prompt

```
Resuming [PROJECT] after a break. Full context reload:

1. Run ./scripts/dev-init.sh
2. Read docs/SESSION_PROTOCOL.md (workflow rules)
3. Read docs/PROGRESS.md (all session history)
4. Check features.json and KNOWN_ISSUES.md

Summarize: where are we, what's next, any blockers?
```

---

## Setup Checklist for New Projects

When starting a new long-running project:

- [ ] Create `docs/` folder
- [ ] Create `docs/ROADMAP.md` with phase breakdown
- [ ] Create `docs/PROGRESS.md` with initial state
- [ ] Create `docs/SESSION_PROTOCOL.md`
- [ ] Create `docs/KNOWN_ISSUES.md`
- [ ] Create `features.json` with all features listed
- [ ] Create `scripts/dev-init.sh` and `chmod +x`
- [ ] Update CLAUDE.md to reference these docs
- [ ] Add session protocol to "Current Focus" section

---

## Understanding Sessions vs Tasks

**Session = Context Window** (not calendar day, not task)

```
┌─────────────────────────────────────────────────────────────┐
│  Context Window                                             │
│                                                             │
│  Task A ──► Task B ──► Task C ──► [Context limit]           │
│    ↓          ↓                         ↓                   │
│  Update    Update              SESSION ENDS                 │
│   docs      docs               (update docs)                │
└─────────────────────────────────────────────────────────────┘
                              ↓
              ┌───────────────────────────────┐
              │  NEW SESSION                  │
              │  Run init, read progress      │
              │  Continue Task C or next      │
              └───────────────────────────────┘
```

- **Update docs** → After every completed task
- **New session** → After compaction or fresh start
- **Day boundary** → Doesn't matter much
- **Can complete multiple tasks** in one context window
- **Large tasks can span** multiple sessions

---

## Tips for Success

1. **Start sessions the same way** — Always run dev-init.sh
2. **Checkpoint often** — Don't wait for context limit
3. **PROGRESS.md entries at TOP** — Most recent first
4. **Descriptive commits** — They serve as documentation
5. **Park blockers immediately** — Don't let them derail progress
6. **JSON for tracking** — Resists inappropriate edits
7. **Verify before marking complete** — Tests must pass

---

## Related Documents

- [07-RalphLoop.md](07-RalphLoop.md) — Autonomous execution within sessions
- [08-ParallelBuild.md](08-ParallelBuild.md) — Multi-agent parallel development
- [00-WorkflowIndex.md](00-WorkflowIndex.md) — Master workflow navigation

---

*Template version 1.0 | Part of the Workflow Documentation System*
