---
description: Orchestrate multi-model spec review - spawns 4 parallel agents, consolidates feedback automatically
---

# Multi-Agent Spec Review Orchestrator

Automates Steps 02-03: Spawns 4 parallel review agents (Claude, GPT-4, Grok, Gemini), monitors completion, and auto-consolidates feedback.

---

## Step 1: Validate Inputs

Check that the spec file exists:

```bash
ls -la SPEC.md 2>/dev/null || ls -la docs/SPEC.md 2>/dev/null || echo "NOT_FOUND"
```

If not found, use AskUserQuestion:

**Question:** "Where is the spec file?"

**Options:**
1. **SPEC.md** — Root directory
2. **docs/SPEC.md** — Docs folder
3. **Other** — I'll specify the path

---

## Step 2: Extract Project Variables

Read the spec file and extract:
- `[PROJECT_NAME]` — From title or first heading
- `[PROJECT_DESCRIPTION]` — From overview/summary section
- `[PLATFORM_FOCUS]` — From technical stack or requirements

If variables are unclear, ask user to confirm.

---

## Step 3: Generate Model-Specific Prompts

Using the template from `02-PLAN-SpecReview.md`, generate 4 prompts:

### Prompt Generation Rules

For each model, replace:
- `[PROJECT_NAME]` → extracted project name
- `[PROJECT_DESCRIPTION]` → extracted description
- `[PLATFORM_FOCUS]` → extracted platform
- `[OUTPUT_FILENAME]` → model-specific filename

**Filenames:**
- Claude → `claude_feedback.md`
- GPT-4 → `gpt4_feedback.md`
- Grok → `grok_feedback.md`
- Gemini → `gemini_feedback.md`

### Model-Specific Emphasis

Each prompt should emphasize that model's strengths:

**Claude Prompt Addition:**
```
Focus especially on:
- Edge cases and failure modes
- Security implications
- Architectural coherence
- Long-term maintainability
```

**GPT-4 Prompt Addition:**
```
Focus especially on:
- Implementation feasibility
- API design patterns
- Code structure recommendations
- Developer experience
```

**Grok Prompt Addition:**
```
Focus especially on:
- Unconventional approaches
- Simplification opportunities
- What's over-engineered
- Bold suggestions
```

**Gemini Prompt Addition:**
```
Focus especially on:
- Industry patterns and alternatives
- Documentation completeness
- Breadth of considerations
- Research-backed recommendations
```

---

## Step 4: User Configuration

Use AskUserQuestion:

**Question:** "How many models should review the spec?"

**Options:**
1. **All 4 (Recommended)** — Claude, GPT-4, Grok, Gemini
2. **3 models** — Skip one (I'll specify which)
3. **2 models** — Faster, less comprehensive

---

## Step 5: Spawn Review Agents

For each selected model, use the Task tool to spawn a parallel agent.

**Important:** Spawn all agents in a SINGLE message with multiple Task tool calls.

### Agent Spawning Pattern

For each model:

```
Task tool call:
- subagent_type: "general-purpose"
- description: "[Model] spec review"
- prompt: [Generated prompt with spec content and model-specific focus]
```

The prompt for each agent should include:
1. Full spec content (read from file)
2. Review instructions from 02-PLAN-SpecReview.md
3. Model-specific focus areas
4. Output filename instruction

---

## Step 6: Monitor Completion

After spawning agents, monitor for completion.

### Polling Strategy

Check for feedback files every 30 seconds:

```bash
ls -la *_feedback.md 2>/dev/null | wc -l
```

### Progress Tracking

Report progress to user:
```
Review Progress:
- Claude:  [✓ Complete | ⏳ Working | ✗ Failed]
- GPT-4:   [✓ Complete | ⏳ Working | ✗ Failed]
- Grok:    [✓ Complete | ⏳ Working | ✗ Failed]
- Gemini:  [✓ Complete | ⏳ Working | ✗ Failed]

Files found: [N]/4
```

### Timeout Handling

- Per-agent timeout: 15 minutes
- Total timeout: 20 minutes

If timeout reached with partial completion:
- Proceed with available reviews if ≥2 complete
- Report which agents timed out

---

## Step 7: Validate Feedback Quality

For each completed feedback file, verify:
- File exists and has content
- Contains all 5 required sections
- Has substantive feedback (not just headers)

### Quality Check

```bash
for f in *_feedback.md; do
  echo "=== $f ==="
  wc -l "$f"
  grep -c "^##" "$f"  # Count section headers
done
```

---

## Step 8: Auto-Consolidate

Once all reviews complete (or timeout with ≥2), run consolidation.

### Consolidation Process

Using the template from `03-PLAN-FeedbackConsolidation.md`:

1. **Read all feedback files**
2. **Identify consensus items** (raised by 2+ models)
3. **Tag sources** for each point
4. **Mark consensus** with 🔺
5. **Mark divergence** with ⚠️
6. **Generate consolidated_feedback.md**

### Consensus Detection

Look for semantic overlap, not just identical wording:
- "Needs error handling" ≈ "Failure states undefined"
- "Missing dependency" ≈ "Order unclear"

---

## Step 9: Output Summary

```
## Multi-Agent Spec Review Complete

**Reviews Completed:** [N]/4
- ✓ claude_feedback.md
- ✓ gpt4_feedback.md
- ✓ grok_feedback.md
- ✓ gemini_feedback.md

**Consolidation:** consolidated_feedback.md

**Consensus Items:** [N] items flagged by 2+ models
**Divergent Items:** [N] items with disagreement

### Top Consensus Issues
1. 🔺 [Issue 1] — Claude, GPT-4, Grok
2. 🔺 [Issue 2] — Claude, Gemini
3. 🔺 [Issue 3] — All 4 models

→ Ready for: /roadmap-with-validation or 04-PLAN-ScopingAndRoadmap.md
```

---

## Step 10: Next Step Prompt

Use AskUserQuestion:

**Question:** "Spec review complete. What next?"

**Options:**
1. **Proceed to scoping/roadmap** — Continue to Step 04
2. **Review feedback first** — Read consolidated_feedback.md
3. **Update spec** — Incorporate feedback before proceeding
4. **End workflow** — Save state and exit

---

## Error Handling

### If no agents complete:
- Report the failure
- Output manual instructions for running spec review
- Provide copy-paste prompts

### If consolidation fails:
- Show individual feedback file locations
- Provide instructions for manual consolidation

### If spec file not found:
- Ask user for correct path
- Create SPEC.md template if requested

---

## Graceful Degradation

**2/4 agents complete:** Proceed with partial consolidation, note missing perspectives

**1/4 agents complete:** Ask user whether to wait, retry, or proceed with single review

**0/4 agents complete:** Fall back to manual review instructions

---

## Notes

- This skill automates Steps 02-03 of the workflow
- All 4 agents run in parallel for speed
- Consolidation happens automatically when reviews complete
- Use `/plan-master` for full workflow orchestration
