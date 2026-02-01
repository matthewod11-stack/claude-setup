---
description: Master planning wizard - chains Steps 01-06 into interactive workflow with checkpoints
---

# Master Planning Orchestrator

Unifies Steps 01-06 into an interactive wizard with checkpoints. Chains to `/orchestrate` for parallel execution.

---

## Architecture Overview

```
/plan-master (This skill - Steps 01-06)
    │
    ├─► Step 01: Spec Interview (inline)
    │   └─► Checkpoint: Review SPEC.md
    │
    ├─► Steps 02-03: /spec-review-multi
    │   └─► Checkpoint: Review consolidated_feedback.md
    │
    ├─► Steps 04-05: /roadmap-with-validation
    │   └─► Checkpoint: Review ROADMAP.md
    │
    └─► Step 06: Exec Setup (inline)
        └─► Handoff to /orchestrate (Step 07)
```

---

## Step 1: Entry Wizard

Use AskUserQuestion to determine starting point.

**Question 1:** "What do you have?"

**Options:**
1. **Just an idea/PRD** — Start from Step 01 (Spec Interview)
2. **Detailed spec** — Start from Step 02 or 04
3. **Multiple AI reviews** — Start from Step 03 (Consolidation)
4. **Spec + consolidated feedback** — Start from Step 04 (Scoping)
5. **Roadmap (want validation)** — Start from Step 05 (Validation)
6. **Validated roadmap** — Start from Step 06 (Exec Setup)

**Question 2:** "What workflow tier?"

**Options:**
1. **Lite (Recommended for side projects)** — 01 → 04 → 06 (Skip multi-AI review + validation)
2. **Full** — 01 → 02 → 03 → 04 → 05 → 06 (Complete workflow)

---

## Step 2: Initialize Workflow State

Create or load `.claude/workflow-state.json`:

```json
{
  "project_name": "",
  "workflow_tier": "full",
  "current_step": "01",
  "completed_steps": [],
  "artifacts": {
    "spec_file": "",
    "feedback_files": [],
    "consolidated_feedback": "",
    "roadmap": "",
    "validation_files": []
  },
  "decisions": {},
  "started_at": "2026-02-01T10:00:00Z",
  "last_checkpoint": ""
}
```

---

## Step 3: Execute Based on Entry Point

### If Starting at Step 01: Spec Interview

1. Read the template from `01-PLAN-SpecInterview.md`
2. Conduct interactive interview with user
3. Generate SPEC.md from responses
4. **Checkpoint:** Present spec for review

**Checkpoint Prompt:**
```
Step 01 Complete. Artifacts: SPEC.md

What next?
  A) Proceed to Step 02 (Spec Review) [if Full tier]
  A) Proceed to Step 04 (Scoping) [if Lite tier]
  B) Revise this step
  C) Skip ahead
  D) End workflow (save state)
```

### If Starting at Steps 02-03: Spec Review

Invoke `/spec-review-multi`:
- Pass spec file path
- Monitor 4 parallel agents
- Auto-consolidate feedback

**Checkpoint Prompt:**
```
Steps 02-03 Complete. Artifacts:
- claude_feedback.md
- gpt4_feedback.md
- grok_feedback.md
- gemini_feedback.md
- consolidated_feedback.md

Consensus items: [N]
Divergent items: [N]

What next?
  A) Proceed to Step 04 (Scoping & Roadmap)
  B) Review feedback files
  C) Re-run review with different models
  D) End workflow (save state)
```

### If Starting at Step 04-05: Scoping & Roadmap

Invoke `/roadmap-with-validation`:
- Interactive scoping with AskUserQuestion
- Generate ROADMAP.md
- Optional multi-agent validation

**Checkpoint Prompt:**
```
Steps 04-05 Complete. Artifacts:
- ROADMAP.md (Execution Mode: [PARALLEL-READY | SEQUENTIAL])
- v2_parking_lot.md
- consolidated_validation.md (if validated)

V1 Features: [N]
V2 Features: [N]
Phases: [N]

What next?
  A) Proceed to Step 06 (Exec Setup)
  B) Review roadmap
  C) Re-run validation
  D) End workflow (save state)
```

### If Starting at Step 06: Exec Setup

Execute setup inline:

1. **Read ROADMAP.md** for execution mode
2. **If PARALLEL-READY:**
   - Generate `AGENT_BOUNDARIES.md`
   - Create `scripts/dev-init.sh`
   - Initialize `features.json`
   - Output: Ready for `/orchestrate`

3. **If SEQUENTIAL:**
   - Initialize `PROGRESS.md`
   - Create `features.json`
   - Output: Ready for `/session-start`

**Checkpoint Prompt:**
```
Step 06 Complete. Project scaffolded.

Execution Mode: [PARALLEL-READY | SEQUENTIAL]

[If PARALLEL:]
  Created: AGENT_BOUNDARIES.md, scripts/dev-init.sh, features.json

  Next: Run /orchestrate to generate agent prompts
  Setup: 3 terminals (Orchestrator + Agent A + Agent B)

[If SEQUENTIAL:]
  Created: PROGRESS.md, features.json

  Next: Run /session-start to begin work
  Use /ralph-loop for autonomous execution

What next?
  A) Start execution (handoff to /orchestrate or /session-start)
  B) Review setup files
  C) Go back and revise roadmap
  D) End workflow (save state)
```

---

## Step 4: Workflow State Management

### Save State on Each Checkpoint

Update `.claude/workflow-state.json`:

```json
{
  "current_step": "04",
  "completed_steps": ["01", "02", "03"],
  "artifacts": {
    "spec_file": "SPEC.md",
    "feedback_files": ["claude_feedback.md", "gpt4_feedback.md", "grok_feedback.md", "gemini_feedback.md"],
    "consolidated_feedback": "consolidated_feedback.md",
    "roadmap": "",
    "validation_files": []
  },
  "decisions": {
    "quality_bar": "polished",
    "timeline": "2-4 weeks"
  },
  "last_checkpoint": "2026-02-01T11:30:00Z"
}
```

### Resume from State

On `/plan-master` invocation, check for existing state:

```bash
cat .claude/workflow-state.json 2>/dev/null
```

If state exists, use AskUserQuestion:

**Question:** "Found workflow in progress. Resume?"

**Options:**
1. **Yes, continue from Step [N]** — Resume workflow
2. **No, start fresh** — Clear state and restart
3. **View current state** — Show what's been done

---

## Step 5: Checkpoint Pattern

Every checkpoint follows this pattern:

```
## Checkpoint: Step [N] Complete

### Artifacts Created
- [file1]
- [file2]

### Summary
[Brief summary of what was accomplished]

### What Next?

Use AskUserQuestion:

**Question:** "Step [N] complete. What next?"

**Options:**
1. **Proceed to Step [N+1]** — Continue workflow
2. **Revise this step** — Re-run current step
3. **Skip ahead** — Jump to later step
4. **End workflow** — Save state and exit
```

---

## Step 6: Boris Tips Integration

### Plan Mode Enforcement

At workflow start, suggest:
```
TIP: Consider entering plan mode (shift+tab twice) for this workflow.
Plan mode helps iterate on decisions before committing to implementation.
```

### Subagent Delegation

When spawning review/validation agents:
```
Spawning subagents to keep main context clean.
Each agent handles one review independently.
Results consolidated when all complete.
```

### CLAUDE.md Self-Improvement

At workflow end, prompt:
```
Workflow complete! Any learnings to add to CLAUDE.md?

Use AskUserQuestion:
  A) Yes, add lesson learned
  B) No, proceed
```

If yes, append to CLAUDE.md:
```markdown
## Learned from [PROJECT_NAME] (2026-02-01)
- [Learning 1]
- [Learning 2]
```

---

## Handoff to Execution

### If PARALLEL-READY → /orchestrate

```
Planning complete! Ready for parallel execution.

Run: /orchestrate

This will:
1. Generate prompts for Agent A and Agent B
2. Help coordinate phase transitions
3. Track progress across both agents

Setup required:
- Terminal 1: Orchestrator (run dev server here)
- Terminal 2: Agent A (paste prompt)
- Terminal 3: Agent B (paste prompt)
```

### If SEQUENTIAL → /session-start

```
Planning complete! Ready for sequential execution.

Run: /session-start

This will:
1. Check environment
2. Show current task from ROADMAP.md
3. Begin implementation

For autonomous execution: /ralph-loop
```

---

## Workflow Tiers

### Lite Workflow (01 → 04 → 06)

Skip multi-AI review and validation. Best for:
- Side projects and toys
- Projects you've built before
- Low-stakes prototypes
- Simple single-domain apps

**Steps:**
1. Spec Interview → SPEC.md
2. Scoping & Roadmap → ROADMAP.md (no validation)
3. Exec Setup → Ready to build

### Full Workflow (01 → 02 → 03 → 04 → 05 → 06)

Complete planning with multi-AI review and validation. Best for:
- Production apps
- External API integrations
- Multi-domain complexity
- Projects with data that matters

**Steps:**
1. Spec Interview → SPEC.md
2. Multi-Agent Spec Review → 4 feedback files
3. Feedback Consolidation → consolidated_feedback.md
4. Interactive Scoping → ROADMAP.md
5. Multi-Agent Validation → consolidated_validation.md
6. Exec Setup → Ready for /orchestrate

---

## Error Handling

### If step fails:
- Save current state
- Report the failure
- Offer to retry or skip

### If user exits early:
- Save state to `.claude/workflow-state.json`
- Output resume instructions

### If state file corrupted:
- Ask user which step to start from
- Rebuild state from existing artifacts

---

## Files Created/Modified

| Step | Creates | Modifies |
|------|---------|----------|
| 01 | SPEC.md | - |
| 02-03 | *_feedback.md, consolidated_feedback.md | - |
| 04-05 | ROADMAP.md, v2_parking_lot.md, consolidated_validation.md | - |
| 06 | AGENT_BOUNDARIES.md, features.json, scripts/* | PROGRESS.md |
| - | .claude/workflow-state.json | Updated each checkpoint |

---

## Notes

- This is the master orchestrator for planning (Steps 01-06)
- Execution (Step 07) handled by `/orchestrate` or `/session-start`
- Workflow state persists between sessions
- Checkpoints allow pause/resume at any point
- Boris tips: plan mode, subagents, CLAUDE.md improvement
