#!/bin/bash

# Claude Code Workflow Skills Installer
# One-command setup for the planning and session management system

set -e

echo "🔧 Installing Claude Code Workflow Skills..."
echo ""

# Create directories
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/reference
mkdir -p ~/.claude/solutions/{universal,typescript,react,node,python}

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if we're in the repo or if reference/ exists
if [ ! -d "$SCRIPT_DIR/reference" ]; then
    echo "❌ Error: reference/ directory not found."
    echo "   Make sure you're running this from the claude-setup repo."
    exit 1
fi

# Copy reference docs
echo "📚 Copying reference documentation..."
cp -r "$SCRIPT_DIR/reference/"* ~/.claude/reference/

# Copy solutions README if it doesn't exist
if [ ! -f ~/.claude/solutions/README.md ] && [ -f "$SCRIPT_DIR/solutions/README.md" ]; then
    cp "$SCRIPT_DIR/solutions/README.md" ~/.claude/solutions/
fi

# Install skills (self-contained versions)
echo "⚡ Installing skills to ~/.claude/commands/..."

# Session management skills
cat > ~/.claude/commands/session-start.md << 'SKILL_EOF'
---
description: Start a work session - verify env, review progress, find next task
---

# Session Start Protocol

Establish context at the beginning of a work session.

## Step 1: Check Environment

If a `package.json` exists, verify node_modules are installed:
```bash
[ -f package.json ] && [ ! -d node_modules ] && npm install
```

Report any environment issues before proceeding.

## Step 2: Read Recent Progress

Check if `PROGRESS.md` exists. If it does:
- Read the last 50 lines for context
- Note the last session date and accomplishments
- Identify any "Next Session Should" guidance

## Step 2.5: Search Solutions Library

Search for relevant prior learnings:
```bash
grep -r -l "[keyword]" solutions/ ~/.claude/solutions/ 2>/dev/null | head -5
```

Include matches in session summary.

## Step 3: Find Current Task

Check if `ROADMAP.md` exists. If it does:
- Find first unchecked item `[ ]`
- Note the section/phase it belongs to

## Step 4: Check Feature Status

If `features.json` exists, identify WIP or blocked features.

## Step 5: Check for Blockers

- Uncommitted changes: `git status --porcelain`
- TypeScript errors: `npx tsc --noEmit 2>&1 | head -20`

## Output Format

```
## Session Start Summary

**Last Session:** [date] - [summary]
**Previous Guidance:** [notes]

**Current State:**
- Environment: [OK / issues]
- Uncommitted changes: [yes/no]

**Next Task:** [description]

**Ready to begin.**
```
SKILL_EOF

cat > ~/.claude/commands/session-end.md << 'SKILL_EOF'
---
description: End a work session - verify code, update tracking, commit changes
---

# Session End Protocol

Close a work session with documentation and clean handoff.

## Step 1: Verify Code State

```bash
npx tsc --noEmit  # If TypeScript
npm test          # If tests exist
```

## Step 2: Update PROGRESS.md

Append session entry:
```markdown
## Session: [YYYY-MM-DD HH:MM]

### Completed
- [tasks completed]

### Next Session Should
- [guidance for next session]
```

## Step 3: Update features.json (if exists)

Mark completed features as `"status": "pass"`.

## Step 4: Update ROADMAP.md (if exists)

Check off completed items: `[ ]` → `[x]`

## Step 5: Knowledge Compound Check

If session involved significant debugging, prompt:
"Document what you learned?"

## Step 6: Stage and Commit

```bash
git add -A
git commit -m "Session: [summary]"
```

## Step 7: Final Summary

```
## Session End Summary

**Verification:** [passed/failed]

### Completed
- [tasks]

### Next Session Should
1. [priority 1]
2. [priority 2]

**Session ended cleanly.**
```
SKILL_EOF

cat > ~/.claude/commands/checkpoint.md << 'SKILL_EOF'
---
description: Mid-session save - preserve state without full shutdown
---

# Checkpoint Protocol

Quick mid-session save.

## Step 1: Assess Current State

```bash
git status --porcelain | head -10
```

## Step 2: Add Checkpoint Note

Append to `PROGRESS.md`:
```markdown
### Checkpoint: [YYYY-MM-DD HH:MM]

**Currently Working On:** [task]
**If Resuming:** [next steps]
```

## Step 3: Optional WIP Commit

Ask: "Create a WIP commit?"

If yes:
```bash
git add -A && git commit -m "WIP: [task] - checkpoint"
```

## Step 4: Output Resume Instructions

```
## Checkpoint Saved

**Current Task:** [description]

### To Resume
1. [next action]
2. [key context]
```
SKILL_EOF

cat > ~/.claude/commands/compound.md << 'SKILL_EOF'
---
description: Capture session learnings as searchable solution documents
---

# Knowledge Compound Capture

Capture learnings for future reference.

## Step 1: Analyze Session

```bash
git log --oneline -10
git diff --stat HEAD~3
```

## Step 2: Extract Components

- **Symptoms:** Error messages, unexpected behavior
- **Investigation:** Approaches tried, what worked
- **Solution:** Working code/config

## Step 3: Determine Scope

- **Project** (`solutions/`) - specific to this codebase
- **Global** (`~/.claude/solutions/`) - applies to any project

## Step 4: Generate Document

```markdown
# [Problem Description]

> **Category:** [build-error|test-failure|runtime-error|pattern]
> **Keywords:** [searchable terms]

## Symptoms
- [error/behavior]

## Solution
\`\`\`
[working code]
\`\`\`
```

## Step 5: Save

Project: `solutions/[category]/[slug].md`
Global: `~/.claude/solutions/[tech]/[slug].md`
SKILL_EOF

# Planning skills (these are more complex, copy from reference or create simplified versions)
cat > ~/.claude/commands/plan-master.md << 'SKILL_EOF'
---
description: Master planning wizard - chains Steps 01-06 into interactive workflow with checkpoints
---

# Master Planning Orchestrator

Unifies planning into an interactive wizard with checkpoints.

## Entry Wizard

Use AskUserQuestion to determine starting point:

**Question 1:** "What do you have?"
1. Just an idea/PRD — Start from Step 01 (Spec Interview)
2. Detailed spec — Start from Step 02 or 04
3. Spec + feedback — Start from Step 04 (Scoping)
4. Validated roadmap — Start from Step 06 (Exec Setup)

**Question 2:** "What workflow tier?"
1. Lite (side projects) — 01 → 04 → 06
2. Full — 01 → 02 → 03 → 04 → 05 → 06

## Workflow Flow

```
Step 01: Spec Interview → SPEC.md
    ↓
Steps 02-03: /spec-review-multi → consolidated_feedback.md
    ↓
Steps 04-05: /roadmap-with-validation → ROADMAP.md
    ↓
Step 06: Exec Setup → Ready for /orchestrate or /session-start
```

## Checkpoints

Each step ends with:
- Artifacts created
- Summary of decisions
- Options: Proceed / Revise / Skip / End

## State Management

Save to `.claude/workflow-state.json`:
```json
{
  "current_step": "04",
  "completed_steps": ["01", "02", "03"],
  "workflow_tier": "full"
}
```

## Handoff

**PARALLEL-READY:** → `/orchestrate` (multi-terminal)
**SEQUENTIAL:** → `/session-start` (single session)
SKILL_EOF

cat > ~/.claude/commands/spec-review-multi.md << 'SKILL_EOF'
---
description: Orchestrate multi-model spec review - spawns 4 parallel agents
---

# Multi-Agent Spec Review

Spawn 4 parallel agents to review spec from different perspectives.

## Step 1: Validate Inputs

Check SPEC.md exists.

## Step 2: Generate Prompts

For each model (Claude, GPT-4, Grok, Gemini):
- Include full spec content
- Add model-specific focus areas
- Specify output filename

## Step 3: Spawn Agents

Use Task tool with 4 parallel calls:
```
subagent_type: "general-purpose"
description: "[Model] spec review"
```

## Step 4: Monitor Completion

Poll for feedback files every 30 seconds.
Timeout: 15 min per agent, 20 min total.

## Step 5: Consolidate

- Tag consensus (2+ models) with 🔺
- Tag divergence with ⚠️
- Generate consolidated_feedback.md

## Output

```
## Multi-Agent Spec Review Complete

**Reviews:** 4/4
**Consensus Items:** [N]
**Divergent Items:** [N]
```
SKILL_EOF

cat > ~/.claude/commands/roadmap-with-validation.md << 'SKILL_EOF'
---
description: Interactive scoping → roadmap generation → multi-agent validation
---

# Roadmap with Validation

Interactive scoping and optional validation.

## Phase 1: Interactive Scoping

Use AskUserQuestion for:
- Success criteria confirmation
- Quality bar (functional/polished/production)
- Timeline constraints
- Feature prioritization

## Phase 2: Domain Triage

For each domain in spec:
- Summarize proposal
- Surface feedback conflicts
- Categorize: V1 Core / V1 Polish / V2

## Phase 3: Generate ROADMAP.md

- Map dependencies
- Analyze parallelizability
- Define phases (Phase 0: Foundation, then feature phases)
- Write detailed task breakdowns

## Phase 4: Validation (Optional)

Ask: "Run multi-agent validation?"

If yes, spawn 4 validators to stress-test:
- Dependency validation
- Complexity audit
- Acceptance criteria quality
- Risk assessment

## Phase 5: Apply Changes

Consolidate validation feedback and update ROADMAP.md.

## Output

```
## Roadmap Complete

**Execution Mode:** [PARALLEL-READY | SEQUENTIAL]
**V1 Features:** [N]
**V2 Features:** [N]
```
SKILL_EOF

echo ""
echo "✅ Installation complete!"
echo ""
echo "Installed to:"
echo "  ~/.claude/commands/     (6 skills)"
echo "  ~/.claude/reference/    (protocol docs)"
echo "  ~/.claude/solutions/    (learnings library)"
echo ""
echo "🔄 Restart Claude Code to discover new skills."
echo ""
echo "Quick start:"
echo "  /plan-master      Full planning wizard"
echo "  /session-start    Begin work session"
echo "  /session-end      End with commit"
