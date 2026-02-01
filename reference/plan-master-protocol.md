# Plan Master Protocol

> **Purpose:** Define the orchestration logic for the `/plan-master` skill
> **Skill Location:** `.claude/commands/plan-master.md`

---

## Overview

The Plan Master is a "meta-orchestrator" that chains Steps 01-06 into an interactive wizard. It provides:

1. **Entry wizard** — Determine starting point based on existing artifacts
2. **Workflow tiers** — Lite vs Full depending on project complexity
3. **Checkpoints** — Pause points for review and decision-making
4. **State persistence** — Resume interrupted workflows
5. **Handoff** — Clean transition to execution phase

---

## Workflow Flow

```
Entry Wizard
    │
    ├─► Determine Starting Point
    │   ├── Just an idea → Step 01
    │   ├── Detailed spec → Step 02 or 04
    │   ├── Multiple reviews → Step 03
    │   ├── Spec + feedback → Step 04
    │   ├── Roadmap (want validation) → Step 05
    │   └── Validated roadmap → Step 06
    │
    ├─► Determine Workflow Tier
    │   ├── Lite: 01 → 04 → 06
    │   └── Full: 01 → 02 → 03 → 04 → 05 → 06
    │
    └─► Execute Workflow
        │
        ├─► Step 01: Spec Interview
        │   └─► Checkpoint
        │
        ├─► Steps 02-03: /spec-review-multi
        │   └─► Checkpoint
        │
        ├─► Steps 04-05: /roadmap-with-validation
        │   └─► Checkpoint
        │
        └─► Step 06: Exec Setup
            └─► Handoff to /orchestrate or /session-start
```

---

## State Management

### State File Location

`.claude/workflow-state.json`

### State Schema

```json
{
  "project_name": "string",
  "workflow_tier": "lite | full",
  "current_step": "01 | 02 | 03 | 04 | 05 | 06",
  "completed_steps": ["01", "02", ...],
  "artifacts": {
    "spec_file": "path/to/SPEC.md",
    "feedback_files": ["claude_feedback.md", ...],
    "consolidated_feedback": "path/to/consolidated_feedback.md",
    "roadmap": "path/to/ROADMAP.md",
    "validation_files": ["claude_validation.md", ...]
  },
  "decisions": {
    "quality_bar": "functional | polished | production-ready",
    "timeline": "no rush | 2-4 weeks | asap",
    "execution_mode": "PARALLEL-READY | SEQUENTIAL"
  },
  "started_at": "ISO8601 timestamp",
  "last_checkpoint": "ISO8601 timestamp"
}
```

### State Transitions

```
Initialize → Step 01 → Checkpoint → Step 02 → ... → Complete
                 ↓
              Save State (on exit)
                 ↓
              Resume (on next invocation)
```

---

## Checkpoint Pattern

Each checkpoint follows this structure:

### 1. Announce Completion

```
## Checkpoint: Step [N] Complete
```

### 2. List Artifacts

```
### Artifacts Created
- [file1.md]
- [file2.md]
```

### 3. Provide Summary

```
### Summary
[Brief description of what was accomplished]
[Key decisions made]
[Metrics: N features, N phases, etc.]
```

### 4. Present Options

Use AskUserQuestion:

**Question:** "Step [N] complete. What next?"

**Options:**
1. **Proceed to Step [N+1]** — Continue workflow
2. **Revise this step** — Re-run current step
3. **Skip ahead** — Jump to later step
4. **End workflow** — Save state and exit

### 5. Handle Selection

- **Proceed:** Update state, move to next step
- **Revise:** Clear current step artifacts, re-run
- **Skip:** Update state, jump to selected step
- **End:** Save state, output resume instructions

---

## Workflow Tier Selection

### Lite Tier Criteria

Use Lite when:
- Project is a side project or toy
- You've built similar before
- No external API integrations
- Single domain (no parallelization needed)
- Low stakes (could rebuild in a weekend)

### Full Tier Criteria

Use Full when:
- Production application
- External API integrations
- AI/LLM components
- Multiple domains (parallelization likely)
- Data that matters (can't lose it)

### Decision Guidance

```
Quick Decision:
  Real project with integrations or data that matters? → Full
  Could rebuild in a weekend if it burned down? → Lite
  Otherwise → Full (better to plan more)
```

---

## Subskill Invocation

### /spec-review-multi (Steps 02-03)

**When:** After Step 01 (Full tier) or when user has spec and wants review

**Invocation:**
```
Invoke /spec-review-multi skill
Pass: spec_file path
Receive: 4 feedback files + consolidated_feedback.md
```

**Integration:**
- Save feedback file paths to state
- Update completed_steps
- Present checkpoint

### /roadmap-with-validation (Steps 04-05)

**When:** After Step 03 (Full tier) or after Step 01 (Lite tier)

**Invocation:**
```
Invoke /roadmap-with-validation skill
Pass: spec_file, consolidated_feedback (if exists)
Receive: ROADMAP.md, v2_parking_lot.md, optional validation files
```

**Integration:**
- Save roadmap path to state
- Extract execution mode (PARALLEL-READY or SEQUENTIAL)
- Update completed_steps
- Present checkpoint

---

## Exec Setup Logic (Step 06)

### For PARALLEL-READY Projects

Create:

1. **AGENT_BOUNDARIES.md**
   ```markdown
   # Agent Boundaries — [PROJECT_NAME]

   ## Agent A: [Domain A]
   **Owns:** /app/[domain-a]/, /lib/services/[domain-a]/, /components/[domain-a]/
   **Read-only:** /types/, /lib/db/, /components/ui/

   ## Agent B: [Domain B]
   **Owns:** /app/[domain-b]/, /lib/services/[domain-b]/, /components/[domain-b]/
   **Read-only:** /types/, /lib/db/, /components/ui/

   ## Shared (Orchestrator Manages)
   - /types/
   - /lib/db/
   - /components/ui/
   ```

2. **scripts/dev-init.sh**
   ```bash
   #!/bin/bash
   # Session initialization script

   # Verify environment
   [ -f package.json ] && [ ! -d node_modules ] && npm install

   # Check for uncommitted changes
   git status --porcelain

   # Output ready message
   echo "Environment ready. Waiting for orchestrator signal."
   ```

3. **features.json**
   ```json
   {
     "features": [
       {"id": "F001", "name": "[Feature]", "status": "not-started", "agent": "A"},
       {"id": "F002", "name": "[Feature]", "status": "not-started", "agent": "B"}
     ]
   }
   ```

### For SEQUENTIAL Projects

Create:

1. **PROGRESS.md** (if not exists)
   ```markdown
   # Progress Log — [PROJECT_NAME]

   ---

   ## Session: [DATE]

   ### Starting Point
   - Roadmap created via /plan-master
   - Execution mode: SEQUENTIAL

   ### Next Session Should
   - Begin with Phase 0 tasks
   - Run /session-start to get context
   ```

2. **features.json**
   ```json
   {
     "features": [
       {"id": "F001", "name": "[Feature]", "status": "not-started"},
       {"id": "F002", "name": "[Feature]", "status": "not-started"}
     ]
   }
   ```

---

## Handoff Protocol

### To /orchestrate (Parallel)

```
Planning complete! Ready for parallel execution.

Execution Mode: PARALLEL-READY
Agent A Domain: [domain-a]
Agent B Domain: [domain-b]

Created:
- AGENT_BOUNDARIES.md
- scripts/dev-init.sh
- features.json

Next Steps:
1. Open 3 terminals
2. Terminal 1: Run `npm run dev` (orchestrator)
3. Run /orchestrate → "Generate agent prompt" → Agent A
4. Paste prompt to Terminal 2
5. Run /orchestrate → "Generate agent prompt" → Agent B
6. Paste prompt to Terminal 3
7. Use /orchestrate for phase transitions
```

### To /session-start (Sequential)

```
Planning complete! Ready for sequential execution.

Execution Mode: SEQUENTIAL

Created:
- PROGRESS.md
- features.json

Next Steps:
1. Run /session-start to begin
2. Work through ROADMAP.md phases in order
3. Run /session-end to commit and document

For autonomous execution:
- Use /ralph-loop with clear completion criteria
```

---

## Error Recovery

### State Corruption

If `.claude/workflow-state.json` is corrupted or missing:

1. Scan for existing artifacts (SPEC.md, ROADMAP.md, etc.)
2. Infer completed steps from artifacts
3. Ask user to confirm inferred state
4. Rebuild state file

### Step Failure

If a step fails:

1. Save current state (including partial progress)
2. Report the failure with details
3. Offer options:
   - Retry the failed step
   - Skip to next step
   - End workflow with saved state

### Interrupted Workflow

On `/plan-master` invocation:

1. Check for existing state file
2. If found, offer to resume
3. If user declines, offer to clear state

---

## Boris Tips Integration

### Plan Mode Suggestion

At workflow start:
```
TIP: For complex planning, consider entering plan mode (shift+tab twice).
This helps iterate on decisions before committing to implementation.
```

### Subagent Context

When spawning review/validation agents:
```
Spawning parallel agents to keep main context clean.
- Main context handles orchestration
- Subagents handle individual reviews
- Results consolidated when all complete
```

### CLAUDE.md Learning

At workflow end:
```
Workflow complete!

Any learnings to capture?
- Patterns that worked well
- Decisions that should be remembered
- Guidelines for future projects

If yes, will append to CLAUDE.md.
```

---

*Protocol version: 1.0 | Created: 2026-02-01*
