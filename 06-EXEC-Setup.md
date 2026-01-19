# 06: Execution Setup (Ready to Run)

> **Position:** Step 6 | After: 04-PLAN-ScopingAndRoadmap (or 05-PLAN-RoadmapValidation) | Before: 07-EXEC-RalphLoop
> **Requires:** Completed roadmap with execution mode (ROADMAP.md)
> **Produces:** Fully scaffolded session infrastructure — ready to run ralph loops
> **Exit State:** You can start ralph loops immediately after this step

---

## Task Flow

```
┌─────────────────────────────────────────────────────────────────┐
│  TASK 1: Core Setup (ALWAYS DO)                                 │
│  Parts 1-2: Read mode, scaffold docs/PROGRESS.md, features.json,│
│  scripts, SESSION_PROMPTS.md, PLANS/                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │ Roadmap says PARALLEL-READY?  │
              └───────────────────────────────┘
                    │                  │
                   YES                 NO
                    │                  │
                    ▼                  ▼
┌─────────────────────────────┐  ┌─────────────────────────────┐
│  TASK 2: Parallel Setup     │  │  Skip to Exit Checklist     │
│  Part 3: Agent boundaries,  │  │  You're ready to run a      │
│  orchestrator, prompts      │  │  single ralph loop          │
└─────────────────────────────┘  └─────────────────────────────┘
                    │                  │
                    └────────┬─────────┘
                             ▼
              ┌───────────────────────────────┐
              │  Exit Checklist → Start       │
              │  07-EXEC-RalphLoop            │
              └───────────────────────────────┘
```

**Quick nav:**
- [Part 1: Read Execution Mode](#part-1-read-execution-mode-from-roadmap)
- [Part 2: Scaffold Core Infrastructure](#part-2-scaffold-session-infrastructure) ← Always
- [Part 3: Parallel-Specific Setup](#part-3-parallel-specific-setup-if-applicable) ← Only if PARALLEL-READY
- [Exit Checklist](#exit-checklist)

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

### 6. SESSION_PROMPTS.md (Quick Reference)

Session management is handled by Claude Code skills. Scaffold this quick reference in your project root.

```markdown
# Session Management — [PROJECT_NAME]

> **PRIMARY METHOD:** Use Claude Code skills (available in all projects with the plugin installed)
> **FALLBACK:** Scripts and manual prompts below

---

## Quick Reference

| When | Skill Command | Fallback |
|------|---------------|----------|
| Starting work | `/session-start` | `./scripts/dev-init.sh` |
| Mid-session save | `/checkpoint` | Manual: update PROGRESS.md |
| Ending work | `/session-end` | `./scripts/session-end.sh` |

---

## What the Skills Do

**`/session-start`** — Verifies environment, reads progress, identifies next task
**`/checkpoint`** — Saves current state without full shutdown
**`/session-end`** — Runs verification, updates docs, prepares handoff notes

---

## Key Files

| File | Purpose |
|------|---------|
| `docs/PROGRESS.md` | Session-by-session work log |
| `features.json` | Pass/fail status tracking |
| `docs/KNOWN_ISSUES.md` | Blockers and parking lot |
| `ROADMAP.md` | Task checklist |

---

## Manual Fallback (if skills unavailable)

**Session Start:** Run `./scripts/dev-init.sh`, then read PROGRESS.md and ROADMAP.md

**Session End:** Run verification, update PROGRESS.md (entry at TOP), update features.json, check off ROADMAP.md tasks, commit

**Checkpoint:** Update PROGRESS.md and features.json with current state

---
```

### 7. scripts/session-end.sh

```bash
#!/bin/bash
# Session End Script
# Run at the end of each development session (or use the CHECK OUT prompt)

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Session End Checklist ===${NC}"
echo ""

# 1. Run verification
echo -e "${BLUE}Running verification...${NC}"

if npm run typecheck > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Type check passes"
else
    echo -e "${YELLOW}⚠${NC} Type check failed or not configured"
fi

if npm test > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Tests pass"
else
    echo -e "${YELLOW}⚠${NC} Tests failed or not configured"
fi

# 2. Check uncommitted changes
echo ""
echo -e "${BLUE}Git status:${NC}"
git status --short

if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}⚠ You have uncommitted changes${NC}"
else
    echo -e "${GREEN}✓${NC} Working tree clean"
fi

# 3. Remind about docs
echo ""
echo -e "${BLUE}=== Before Closing ===${NC}"
echo -e "Have you:"
echo -e "  [ ] Added session entry to TOP of docs/PROGRESS.md?"
echo -e "  [ ] Updated features.json with pass/fail status?"
echo -e "  [ ] Checked off completed task in ROADMAP.md?"
echo -e "  [ ] Written 'Next Session Should' note?"
echo ""

echo -e "${YELLOW}Run session end:${NC}"
echo ""
echo "  /session-end"
echo ""
echo -e "${BLUE}(Or manually: update PROGRESS.md, features.json, ROADMAP.md, then commit)${NC}"

echo ""
echo -e "${GREEN}=== Done ===${NC}"
```

Make it executable:

```bash
chmod +x scripts/session-end.sh
```

---

## Part 3: Parallel-Specific Setup (if applicable)

**Skip this if your roadmap says `SEQUENTIAL`.**

### The Three-Terminal Pattern

Parallel execution requires **three terminals**, not two:

```
┌─────────────────────────────────────────────────────────────────────┐
│                      ORCHESTRATOR TERMINAL                          │
│  • Runs dev server (agents don't fight over it)                     │
│  • Generates prompts for each phase                                 │
│  • Monitors progress                                                │
│  • Signals phase transitions                                        │
└─────────────────────────────────────────────────────────────────────┘
         │                                      │
         ▼                                      ▼
┌─────────────────────────┐      ┌─────────────────────────┐
│     AGENT A TERMINAL    │      │     AGENT B TERMINAL    │
│  • Owns [domain-a]      │      │  • Owns [domain-b]      │
│  • Runs ralph loop      │      │  • Runs ralph loop      │
│  • Never starts server  │      │  • Never starts server  │
└─────────────────────────┘      └─────────────────────────┘
```

**Why this matters:**
- Without an orchestrator, agents start/stop each other's servers in loops
- Orchestrator is the single source of truth for phase transitions
- Agents get their prompts from orchestrator, not self-generated

### 3.1 Agent Boundaries

Create `AGENT_BOUNDARIES.md` in project root:

```markdown
# Agent Boundaries — [PROJECT_NAME]

## Agent A: [Domain A Name]

**Owns (can modify):**
- /app/[domain-a]/
- /lib/services/[domain-a]/
- /components/[domain-a]/

**Reads (no modifications):**
- /types/
- /lib/db/
- /components/ui/

## Agent B: [Domain B Name]

**Owns (can modify):**
- /app/[domain-b]/
- /lib/services/[domain-b]/
- /components/[domain-b]/

**Reads (no modifications):**
- /types/
- /lib/db/
- /components/ui/

## Shared Resources (Read-Only for Both)

- /types/ — Type definitions
- /contracts/ — API contracts
- /components/ui/ — Shared UI components
- /lib/db/ — Database utilities

## Conflict Resolution

If both agents need to modify shared code:
1. STOP both agents
2. Make shared change in orchestrator terminal
3. Commit with message: `chore(shared): description [Orchestrator]`
4. Both agents pull before resuming

## Commit Convention

- Agent A: `feat([domain-a]): description [Agent A]`
- Agent B: `feat([domain-b]): description [Agent B]`
- Orchestrator: `chore(shared): description [Orchestrator]`
```

### 3.2 Agent Prompt Template

Create `scripts/agent-prompt-template.md`:

```markdown
# Agent [A/B] — Phase [X]: [Phase Name]

## Your Identity

You are **Agent [A/B]**, working on **[domain]** for [PROJECT_NAME].

## Your Boundaries

**You OWN (can modify):**
- [list of paths]

**You READ ONLY (never modify):**
- [list of paths]

**If you need to modify shared code:** STOP and tell me. I'll handle it from orchestrator.

## Current Phase Tasks

Work through these in order:

- [ ] [Task 1]
- [ ] [Task 2]
- [ ] [Task 3]

## Session Protocol

1. Run `./scripts/dev-init.sh` (server already running in orchestrator)
2. Read `docs/PROGRESS.md` for context
3. Work ONE task at a time
4. Commit after each task: `feat([domain]): description [Agent A/B]`
5. Update `features.json` after each task

## Completion Signal

When ALL tasks above are complete:
1. Run tests for your domain
2. Update PROGRESS.md with session entry
3. Say: **"PHASE [X] COMPLETE — Agent [A/B]"**

I'll coordinate with the other agent before starting the next phase.

## DO NOT

- Start or stop the dev server (orchestrator handles it)
- Modify files outside your boundaries
- Start next phase without my signal
- Work on multiple tasks simultaneously
```

### 3.3 Orchestrator Script

Create `scripts/orchestrator.sh`:

```bash
#!/bin/bash
# Orchestrator Script for Parallel Execution
# Run this in your orchestrator terminal

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

PROJECT_NAME="[PROJECT_NAME]"

show_header() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          ORCHESTRATOR — $PROJECT_NAME                         ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_menu() {
    echo -e "${BLUE}Commands:${NC}"
    echo "  1) Start dev server"
    echo "  2) Generate Agent A prompt for phase"
    echo "  3) Generate Agent B prompt for phase"
    echo "  4) Check agent status"
    echo "  5) Signal phase transition"
    echo "  6) Handle shared code change"
    echo "  q) Quit"
    echo ""
}

generate_agent_prompt() {
    local agent=$1
    local phase=$2
    local domain=$3

    echo -e "${GREEN}=== Agent $agent Prompt — Phase $phase ===${NC}"
    echo ""
    echo "Copy this to Agent $agent terminal:"
    echo ""
    echo "─────────────────────────────────────────"
    cat << EOF
# Agent $agent — Phase $phase: [Phase Name]

## Your Identity
You are **Agent $agent**, working on **$domain** for $PROJECT_NAME.

## Your Boundaries
**You OWN:** /app/$domain/, /lib/services/$domain/, /components/$domain/
**READ ONLY:** /types/, /lib/db/, /components/ui/

## Current Phase Tasks
[PASTE TASKS FROM ROADMAP]

## Session Protocol
1. Server is running (don't start it)
2. Work ONE task at a time
3. Commit: feat($domain): description [Agent $agent]
4. When done: "PHASE $phase COMPLETE — Agent $agent"

## DO NOT
- Start/stop dev server
- Modify files outside your boundaries
- Start next phase without orchestrator signal
EOF
    echo "─────────────────────────────────────────"
    echo ""
}

check_status() {
    echo -e "${BLUE}=== Agent Status ===${NC}"
    echo ""

    if [ -f "features.json" ]; then
        echo -e "${YELLOW}Feature Status:${NC}"
        grep -E '"status"' features.json | head -10
    fi

    echo ""
    echo -e "${YELLOW}Recent Commits:${NC}"
    git log --oneline -5

    echo ""
    echo -e "${YELLOW}Uncommitted Changes:${NC}"
    git status --short
}

# Main loop
show_header

echo -e "${YELLOW}Starting dev server...${NC}"
echo "(Keep this terminal open. Server runs here.)"
echo ""
echo "Press Enter to start server, or 's' to skip if already running"
read -r choice

if [ "$choice" != "s" ]; then
    npm run dev &
    DEV_PID=$!
    echo -e "${GREEN}Dev server started (PID: $DEV_PID)${NC}"
fi

echo ""
show_menu

while true; do
    echo -n "> "
    read -r cmd

    case $cmd in
        1)
            npm run dev &
            ;;
        2)
            echo -n "Phase number: "
            read -r phase
            echo -n "Domain name: "
            read -r domain
            generate_agent_prompt "A" "$phase" "$domain"
            ;;
        3)
            echo -n "Phase number: "
            read -r phase
            echo -n "Domain name: "
            read -r domain
            generate_agent_prompt "B" "$phase" "$domain"
            ;;
        4)
            check_status
            ;;
        5)
            echo -e "${GREEN}=== Phase Transition ===${NC}"
            echo "1. Verify both agents said 'PHASE X COMPLETE'"
            echo "2. Run: git pull (in both agent terminals)"
            echo "3. Generate new prompts for next phase"
            echo "4. Paste to agent terminals"
            ;;
        6)
            echo -e "${YELLOW}=== Shared Code Change ===${NC}"
            echo "1. Tell both agents to STOP"
            echo "2. Make your changes here"
            echo "3. Commit: git commit -m 'chore(shared): description [Orchestrator]'"
            echo "4. Tell agents to: git pull"
            echo "5. Resume agents"
            ;;
        q)
            echo "Stopping server..."
            [ -n "$DEV_PID" ] && kill $DEV_PID 2>/dev/null
            exit 0
            ;;
        *)
            show_menu
            ;;
    esac
done
```

Make it executable:

```bash
chmod +x scripts/orchestrator.sh
```

### 3.4 Parallel Execution Workflow

```
PHASE START
───────────
Orchestrator: ./scripts/orchestrator.sh
    │
    ├──► Start dev server
    │
    ├──► Generate Agent A prompt (option 2)
    │    └──► Copy to Agent A terminal
    │
    └──► Generate Agent B prompt (option 3)
         └──► Copy to Agent B terminal

DURING PHASE
────────────
Agent A: Working on [domain-a] tasks
Agent B: Working on [domain-b] tasks
Orchestrator: Monitoring, answering questions

PHASE END
─────────
Agent A: "PHASE X COMPLETE — Agent A"
Agent B: "PHASE X COMPLETE — Agent B"
    │
    ▼
Orchestrator:
    1. Verify both complete
    2. Check for conflicts: git status
    3. Merge if needed
    4. Signal: "Starting Phase X+1"
    5. Generate new prompts
    6. Paste to agents
```

### 3.5 Quick Reference Card (Parallel)

Add this to your ROADMAP.md:

```
╔═══════════════════════════════════════════════════════════════════════╗
║  PARALLEL EXECUTION — ORCHESTRATOR QUICK REFERENCE                    ║
╠═══════════════════════════════════════════════════════════════════════╣
║                                                                       ║
║  TERMINAL SETUP:                                                      ║
║    Terminal 1: ./scripts/orchestrator.sh (runs server + coordinates)  ║
║    Terminal 2: Agent A (paste prompt from orchestrator)               ║
║    Terminal 3: Agent B (paste prompt from orchestrator)               ║
║                                                                       ║
║  PHASE START:                                                         ║
║    1. Generate prompts in orchestrator (options 2 & 3)                ║
║    2. Paste to agent terminals                                        ║
║    3. Agents work independently                                       ║
║                                                                       ║
║  PHASE END:                                                           ║
║    Wait for: "PHASE X COMPLETE — Agent A/B" from BOTH agents          ║
║    Then: Check status (option 4) → Generate next phase prompts        ║
║                                                                       ║
║  IF AGENTS NEED SHARED CODE:                                          ║
║    1. STOP both agents                                                ║
║    2. Make change in orchestrator terminal                            ║
║    3. Commit: chore(shared): description [Orchestrator]               ║
║    4. Agents: git pull                                                ║
║    5. Resume                                                          ║
║                                                                       ║
║  CONFLICT RESOLUTION:                                                 ║
║    Orchestrator handles ALL merges and shared code                    ║
║    Agents should NEVER modify files outside their boundaries          ║
║                                                                       ║
╚═══════════════════════════════════════════════════════════════════════╝
```

---

## Part 4: Session Management Quick Reference

Paste this into your ROADMAP.md or keep handy:

```
╔═══════════════════════════════════════════════════════════════════════╗
║  SESSION MANAGEMENT - QUICK REFERENCE                                 ║
╠═══════════════════════════════════════════════════════════════════════╣
║                                                                       ║
║  SESSION START:                                                       ║
║    /session-start                                                     ║
║    (or ./scripts/dev-init.sh for env check only)                      ║
║                                                                       ║
║  DURING SESSION:                                                      ║
║    • Work on ONE task at a time                                       ║
║    • Update docs after each completed task                            ║
║    • Commit frequently                                                ║
║                                                                       ║
║  CHECKPOINT (context getting long):                                   ║
║    /checkpoint                                                        ║
║                                                                       ║
║  SESSION END (before compaction):                                     ║
║    /session-end                                                       ║
║                                                                       ║
║  IF BLOCKED:                                                          ║
║    Add to KNOWN_ISSUES.md → Move to next task                         ║
║                                                                       ║
╚═══════════════════════════════════════════════════════════════════════╝
```

---

## Part 5: Commit Infrastructure

### Sequential Projects

```bash
git add docs/ PLANS/ scripts/ features.json ROADMAP.md SESSION_PROMPTS.md
git commit -m "chore: scaffold session management infrastructure

- Add docs/PROGRESS.md for session tracking
- Add docs/KNOWN_ISSUES.md for parking lot
- Add features.json for pass/fail tracking
- Add scripts/dev-init.sh for session init
- Add scripts/session-end.sh for session end
- Add SESSION_PROMPTS.md with check-in/check-out prompts
- Add PLANS/ directory for task plans"
```

### Parallel Projects (additional files)

```bash
git add AGENT_BOUNDARIES.md scripts/orchestrator.sh scripts/agent-prompt-template.md
git commit -m "chore: add parallel execution infrastructure

- Add AGENT_BOUNDARIES.md with domain ownership
- Add scripts/orchestrator.sh for three-terminal coordination
- Add scripts/agent-prompt-template.md for phase prompts"
```

---

## Exit Checklist

Before proceeding, verify:

**Infrastructure (ALL projects):**
- [ ] `docs/PROGRESS.md` exists with initial session entry
- [ ] `docs/KNOWN_ISSUES.md` exists
- [ ] `features.json` exists with all tasks from roadmap
- [ ] `PLANS/` directory exists

**Session Management (NON-NEGOTIABLE):**
- [ ] `SESSION_PROMPTS.md` exists in project root
- [ ] `scripts/dev-init.sh` exists and is executable
- [ ] `scripts/session-end.sh` exists and is executable
- [ ] You know the session skills (`/session-start`, `/session-end`, `/checkpoint`)

**Parallel-Specific (if PARALLEL-READY):**
- [ ] `AGENT_BOUNDARIES.md` exists with domain ownership
- [ ] `scripts/orchestrator.sh` exists and is executable
- [ ] `scripts/agent-prompt-template.md` exists
- [ ] You understand the three-terminal pattern

**Ready to Execute:**
- [ ] Infrastructure committed to git
- [ ] Execution mode confirmed from roadmap header

---

## You're Ready — Start Ralph Loops

### If SEQUENTIAL:

Open one terminal and run:

```bash
/Users/mattod/.claude/plugins/marketplaces/claude-plugins-official/plugins/ralph-wiggum/scripts/setup-ralph-loop.sh "[PHASE_FOCUS]" --completion-promise "PHASE_COMPLETE" --max-iterations 50
```

See [07-EXEC-RalphLoop.md](07-EXEC-RalphLoop.md) for the full autonomous execution protocol.

### If PARALLEL-READY:

Open two terminals. In each, start with the agent prompt from [07-EXEC-RalphLoop.md](07-EXEC-RalphLoop.md) that includes:
- Agent identity (A or B)
- Boundary rules
- Tasks for this agent
- Ralph loop command with unique completion promise

See [reference/parallel-build.md](reference/parallel-build.md) for coordination details.

---

## Reference: Deep Dive on Sessions

Session management is now scaffolded as part of this step (SESSION_PROMPTS.md, scripts/).

For deeper context on WHY this approach works:
- [reference/session-management.md](reference/session-management.md) — Theory, diagrams, tips for long-running work

---

*Template version 2.0 | Part of the Workflow Documentation System*
