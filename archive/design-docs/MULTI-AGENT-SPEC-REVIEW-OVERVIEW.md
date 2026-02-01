# Multi-Agent Spec Review Orchestrator — Comprehensive Overview

> **Status:** Design Document | **Created:** 2026-02-01  
> **Purpose:** Automate the multi-model spec review workflow (Steps 02-03) into a single orchestrated command

---

## Executive Summary

**Problem:** Currently, running multi-model spec review requires:
1. Manually opening 4 separate Cursor instances
2. Copying the spec review prompt to each
3. Configuring each to use a different model (Claude, GPT-4, Grok, Gemini)
4. Waiting for each to complete and save their feedback file
5. Manually running consolidation
6. Proceeding to scoping/roadmap

**Solution:** A single slash command `/spec-review-multi` that orchestrates all of this automatically using Cursor's CLI capabilities.

**Impact:** Reduces a 4-step manual process to a single command, saving ~15-20 minutes per project and eliminating coordination overhead.

---

## Architecture Overview

### High-Level Flow

```
User: /spec-review-multi [SPEC_FILE]
  │
  ├─► 1. Validate inputs (spec file exists, variables filled)
  │
  ├─► 2. Generate model-specific prompts from 02-PLAN-SpecReview.md
  │     └─► Replace [OUTPUT_FILENAME] with model name (claude_feedback.md, etc.)
  │
  ├─► 3. Spawn 4 parallel Cursor agent instances via CLI
  │     ├─► Agent 1: Claude (claude_feedback.md)
  │     ├─► Agent 2: GPT-4 (gpt4_feedback.md)
  │     ├─► Agent 3: Grok (grok_feedback.md)
  │     └─► Agent 4: Gemini (gemini_feedback.md)
  │
  ├─► 4. Monitor for completion (poll files or wait for signals)
  │
  ├─► 5. Auto-consolidate when all complete (run 03-PLAN-FeedbackConsolidation.md)
  │
  └─► 6. Optionally proceed to scoping/roadmap (04-PLAN-ScopingAndRoadmap.md)
```

### Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Orchestrator Skill                       │
│              (.claude/commands/spec-review-multi.md)        │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│   Prompt     │   │   Agent      │   │   Monitor    │
│  Generator   │   │   Spawner    │   │   & Wait     │
└──────────────┘   └──────────────┘   └──────────────┘
        │                   │                   │
        │                   │                   │
        ▼                   ▼                   ▼
┌─────────────────────────────────────────────────────────────┐
│              Cursor CLI (agent chat)                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │ Claude   │  │  GPT-4   │  │   Grok   │  │  Gemini  │  │
│  │ Agent    │  │  Agent   │  │  Agent   │  │  Agent   │  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
              ┌─────────────────────────┐
              │   Feedback Files        │
              │  • claude_feedback.md   │
              │  • gpt4_feedback.md     │
              │  • grok_feedback.md     │
              │  • gemini_feedback.md   │
              └─────────────────────────┘
                            │
                            ▼
              ┌─────────────────────────┐
              │   Consolidator         │
              │  (03-PLAN-Feedback...)  │
              └─────────────────────────┘
                            │
                            ▼
              ┌─────────────────────────┐
              │ consolidated_feedback.md│
              └─────────────────────────┘
```

---

## User Experience Flow

### Before (Current Manual Process)

```
1. User opens Cursor Terminal 1
   → Loads 02-PLAN-SpecReview.md
   → Replaces variables manually
   → Sets model to Claude
   → Runs review
   → Waits for claude_feedback.md

2. User opens Cursor Terminal 2
   → Loads 02-PLAN-SpecReview.md
   → Replaces variables manually
   → Sets model to GPT-4
   → Runs review
   → Waits for gpt4_feedback.md

3. User opens Cursor Terminal 3
   → Loads 02-PLAN-SpecReview.md
   → Replaces variables manually
   → Sets model to Grok
   → Runs review
   → Waits for grok_feedback.md

4. User opens Cursor Terminal 4
   → Loads 02-PLAN-SpecReview.md
   → Replaces variables manually
   → Sets model to Gemini
   → Runs review
   → Waits for gemini_feedback.md

5. User manually runs 03-PLAN-FeedbackConsolidation.md
   → Consolidates all feedback
   → Produces consolidated_feedback.md

6. User proceeds to 04-PLAN-ScopingAndRoadmap.md
```

**Time:** ~20-30 minutes of active coordination  
**Error-prone:** Manual variable replacement, model selection, file tracking

### After (Orchestrated)

```
User: /spec-review-multi @SPEC.md

Orchestrator:
  ✓ Validating spec file...
  ✓ Extracting project variables...
  ✓ Generating prompts for 4 models...
  ✓ Spawning agents:
    • Claude agent started (PID: 12345)
    • GPT-4 agent started (PID: 12346)
    • Grok agent started (PID: 12347)
    • Gemini agent started (PID: 12348)
  
  ⏳ Waiting for reviews to complete...
  [Progress: ████░░░░░░] 2/4 complete
  
  ✓ All reviews complete!
  ✓ Consolidating feedback...
  ✓ Saved: consolidated_feedback.md
  
  → Proceed to scoping? (y/n)
```

**Time:** ~5 minutes (mostly waiting for agents)  
**Error-free:** Automated variable replacement, model selection, file tracking

---

## Technical Implementation

### 1. Skill File Structure

**Location:** `.claude/commands/spec-review-multi.md`

```markdown
---
description: Orchestrate multi-model spec review - spawns 4 agents, consolidates feedback automatically
arguments:
  - name: spec_file
    required: true
    description: Path to spec file (e.g., @SPEC.md or docs/SPEC.md)
  - name: auto_scope
    required: false
    description: Automatically proceed to scoping after consolidation (default: false)
---

# Multi-Agent Spec Review Orchestrator

[Implementation details below]
```

### 2. Prompt Generation

The orchestrator reads `02-PLAN-SpecReview.md` and generates model-specific prompts:

**Input:** `02-PLAN-SpecReview.md` template with variables:
- `[PROJECT_NAME]`
- `[PROJECT_DESCRIPTION]`
- `[PLATFORM_FOCUS]`
- `[OUTPUT_FILENAME]` ← **This changes per model**

**Process:**
1. Read spec file to extract project variables
2. Read `02-PLAN-SpecReview.md` template
3. For each model, replace `[OUTPUT_FILENAME]` with model-specific name:
   - Claude → `claude_feedback.md`
   - GPT-4 → `gpt4_feedback.md`
   - Grok → `grok_feedback.md`
   - Gemini → `gemini_feedback.md`
4. Generate 4 prompt files (or in-memory strings)

### 3. Agent Spawning

**Using Cursor CLI:**

```bash
# Spawn Claude agent
cursor agent chat --model claude-opus "
[Generated prompt for Claude]
" &

# Spawn GPT-4 agent
cursor agent chat --model gpt-4 "
[Generated prompt for GPT-4]
" &

# Spawn Grok agent
cursor agent chat --model grok "
[Generated prompt for Grok]
" &

# Spawn Gemini agent
cursor agent chat --model gemini-pro "
[Generated prompt for Gemini]
" &
```

**Alternative (if CLI doesn't support model flags):**
- Use environment variables or config files
- Or spawn via separate terminal windows/tabs
- Or use Cursor's API if available

### 4. Completion Detection

**Option A: File Polling**
```bash
# Poll every 5 seconds for all 4 files
while [ ! -f claude_feedback.md ] || [ ! -f gpt4_feedback.md ] || \
      [ ! -f grok_feedback.md ] || [ ! -f gemini_feedback.md ]; do
  sleep 5
  echo "Waiting for reviews... ($(ls *_feedback.md 2>/dev/null | wc -l)/4)"
done
```

**Option B: Process Monitoring**
```bash
# Wait for all agent processes to complete
wait $PID_CLAUDE $PID_GPT4 $PID_GROK $PID_GEMINI
```

**Option C: Completion Signals**
- Agents write completion markers (`.claude/review-complete-claude`, etc.)
- Orchestrator watches for all 4 markers

**Recommended:** Hybrid approach — poll files with timeout (15 min per agent)

### 5. Consolidation

Once all files exist:
1. Read `03-PLAN-FeedbackConsolidation.md`
2. Extract feedback file list: `claude_feedback.md, gpt4_feedback.md, grok_feedback.md, gemini_feedback.md`
3. Execute consolidation prompt
4. Save `consolidated_feedback.md`

### 6. Optional Scoping

If `auto_scope=true`:
- Automatically proceed to `04-PLAN-ScopingAndRoadmap.md`
- Pass `consolidated_feedback.md` as input

---

## File Structure

```
claude-setup/
├── .claude/
│   └── commands/
│       └── spec-review-multi.md          # NEW: Orchestrator skill
├── scripts/                               # NEW: Helper scripts
│   ├── spawn-review-agents.sh            # Agent spawning logic
│   ├── wait-for-reviews.sh               # Completion detection
│   └── consolidate-feedback.sh            # Auto-consolidation
├── 02-PLAN-SpecReview.md                  # Template (unchanged)
├── 03-PLAN-FeedbackConsolidation.md      # Template (unchanged)
└── MULTI-AGENT-SPEC-REVIEW-OVERVIEW.md    # This document
```

---

## Error Handling

### Failure Scenarios

| Scenario | Detection | Recovery |
|----------|-----------|----------|
| **Spec file missing** | File read fails | Prompt user for correct path |
| **Variables not filled** | Template has `[VAR]` | Extract from spec or prompt user |
| **Agent fails to spawn** | Process start fails | Retry with different method, log error |
| **Agent times out** | No file after 15 min | Mark as incomplete, proceed with available reviews |
| **Partial completion** | Only 2/4 files exist | Ask user: wait more, proceed with 2, or retry failed agents |
| **Consolidation fails** | Error reading feedback files | Show error, allow manual consolidation |
| **CLI not available** | `cursor` command not found | Fallback to manual instructions |

### Timeout Strategy

- **Per-agent timeout:** 15 minutes
- **Total timeout:** 20 minutes (all agents should complete)
- **Graceful degradation:** Proceed with available reviews if ≥2 complete

### Logging

Create `.claude/review-orchestrator.log`:
```
[2026-02-01 10:15:23] Starting multi-agent review
[2026-02-01 10:15:24] Spawned Claude agent (PID: 12345)
[2026-02-01 10:15:24] Spawned GPT-4 agent (PID: 12346)
[2026-02-01 10:15:25] Spawned Grok agent (PID: 12347)
[2026-02-01 10:15:25] Spawned Gemini agent (PID: 12348)
[2026-02-01 10:18:42] Claude review complete (claude_feedback.md)
[2026-02-01 10:19:15] GPT-4 review complete (gpt4_feedback.md)
[2026-02-01 10:22:08] Grok review complete (grok_feedback.md)
[2026-02-01 10:23:31] Gemini review complete (gemini_feedback.md)
[2026-02-01 10:23:32] All reviews complete, consolidating...
[2026-02-01 10:24:15] Consolidation complete (consolidated_feedback.md)
```

---

## Integration with Existing Workflow

### Current Workflow (Steps 01-04)

```
01-PLAN-SpecInterview.md
  ↓
02-PLAN-SpecReview.md (manual, 4x)
  ↓
03-PLAN-FeedbackConsolidation.md (manual)
  ↓
04-PLAN-ScopingAndRoadmap.md
```

### New Workflow (Steps 01-04)

```
01-PLAN-SpecInterview.md
  ↓
/spec-review-multi @SPEC.md
  ├─► Auto-runs 02 (4x parallel)
  ├─► Auto-runs 03 (consolidation)
  └─► Optionally auto-runs 04 (scoping)
```

### Backward Compatibility

- Manual process still works (users can run 02-03 manually)
- Orchestrator is optional enhancement
- Can be used standalone or as part of full workflow

---

## Configuration Options

### Model Selection

Allow users to customize which models to use:

```bash
/spec-review-multi @SPEC.md --models claude,gpt4,gemini
# Excludes Grok

/spec-review-multi @SPEC.md --models claude,gpt4
# Only 2 models (faster)
```

### Timeout Configuration

```bash
/spec-review-multi @SPEC.md --timeout 20
# 20 minutes per agent (default: 15)
```

### Output Directory

```bash
/spec-review-multi @SPEC.md --output-dir reviews/
# Save feedback files to reviews/ subdirectory
```

---

## Implementation Phases

### Phase 1: MVP (Core Functionality)
- ✅ Basic orchestrator skill
- ✅ Prompt generation from template
- ✅ Agent spawning via CLI (or manual instructions if CLI unavailable)
- ✅ File polling for completion
- ✅ Auto-consolidation

### Phase 2: Robustness
- ✅ Error handling and timeouts
- ✅ Logging
- ✅ Graceful degradation (partial completion)
- ✅ Progress indicators

### Phase 3: Polish
- ✅ Configuration options (models, timeouts)
- ✅ Auto-scoping option
- ✅ Better UX (progress bars, status updates)
- ✅ Integration tests

### Phase 4: Advanced Features
- ✅ Retry failed agents
- ✅ Parallel consolidation (if multiple projects)
- ✅ Webhook/notification when complete
- ✅ Review quality scoring

---

## Technical Considerations

### Cursor CLI Limitations

**Known Constraints:**
- CLI is in beta (behavior may change)
- Model selection may require different syntax
- Authentication/API keys may be needed
- Process management varies by OS

**Fallback Strategies:**
1. **If CLI unavailable:** Generate instructions for manual execution
2. **If model selection fails:** Use default model, warn user
3. **If spawning fails:** Provide copy-paste prompts for manual execution

### Resource Management

**Concurrent Agents:**
- 4 agents running simultaneously
- Each may consume significant memory/CPU
- Monitor system resources

**Recommendations:**
- Stagger agent starts by 2-3 seconds (reduce initial load)
- Monitor system resources
- Allow user to reduce concurrent agents

### File System Coordination

**Potential Issues:**
- Multiple agents writing to same directory
- File locking (unlikely with markdown)
- Race conditions (very unlikely)

**Mitigation:**
- Each agent writes to unique filename (already handled)
- Use atomic file writes (create temp, then rename)
- Verify file integrity before consolidation

---

## Testing Strategy

### Unit Tests

1. **Prompt Generation**
   - Test variable replacement
   - Test model-specific filename generation
   - Test template parsing

2. **File Detection**
   - Test polling logic
   - Test timeout handling
   - Test partial completion scenarios

### Integration Tests

1. **End-to-End (Mock)**
   - Mock agent spawning
   - Mock file creation
   - Test full orchestration flow

2. **Manual Testing**
   - Run with real Cursor CLI
   - Test with different models
   - Test error scenarios

### Test Scenarios

| Scenario | Expected Behavior |
|----------|-------------------|
| All agents succeed | Consolidation runs automatically |
| 1 agent fails | Proceed with 3 reviews, warn user |
| 2+ agents fail | Ask user: retry or proceed |
| Spec file invalid | Show error, prompt for correct path |
| CLI unavailable | Fallback to manual instructions |
| Consolidation fails | Show error, allow manual run |

---

## Future Enhancements

### Short-Term (v1.1)

1. **Progress Dashboard**
   - Real-time status of each agent
   - Estimated completion times
   - Live file monitoring

2. **Review Quality Metrics**
   - Check feedback file completeness
   - Score feedback quality (length, structure)
   - Flag incomplete reviews

3. **Custom Model Support**
   - Allow users to add custom models
   - Support for local models (Ollama, etc.)

### Medium-Term (v2.0)

1. **Distributed Execution**
   - Run agents on remote machines
   - Cloud-based agent pool
   - Cost optimization (use cheaper models for simple reviews)

2. **Review Comparison**
   - Side-by-side comparison view
   - Highlight unique insights per model
   - Consensus heatmap

3. **Incremental Consolidation**
   - Start consolidating as reviews arrive
   - Update consolidated file progressively
   - Show "pending" sections

### Long-Term (v3.0)

1. **AI-Powered Orchestration**
   - Learn which models work best for which spec types
   - Auto-select optimal model set
   - Adaptive timeout based on spec complexity

2. **Review Synthesis**
   - Generate executive summary
   - Extract action items automatically
   - Create prioritized improvement list

3. **Integration with Execution**
   - Auto-generate roadmap from consolidated feedback
   - Link feedback to roadmap tasks
   - Track feedback implementation status

---

## Success Metrics

### Quantitative

- **Time Saved:** Reduce from 20-30 min to 5-10 min per review cycle
- **Error Rate:** Reduce manual errors (wrong model, wrong filename) to 0%
- **Adoption:** 80%+ of users prefer orchestrator over manual process
- **Reliability:** 95%+ success rate (all 4 agents complete)

### Qualitative

- **User Satisfaction:** "This is exactly what I needed"
- **Workflow Integration:** Seamless fit into existing process
- **Error Recovery:** Graceful handling of edge cases
- **Documentation:** Clear, actionable error messages

---

## Risks & Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| **CLI changes break compatibility** | High | Medium | Version detection, fallback to manual |
| **Agents timeout frequently** | Medium | Low | Configurable timeouts, retry logic |
| **File system race conditions** | Low | Very Low | Atomic writes, file locking |
| **Resource exhaustion (4 agents)** | Medium | Low | Staggered starts, resource monitoring |
| **Consolidation quality degrades** | Medium | Low | Validation checks, manual override |

---

## Dependencies

### Required

- **Cursor CLI:** `cursor` command available in PATH
- **Bash/Shell:** For script execution (macOS/Linux)
- **02-PLAN-SpecReview.md:** Template file exists
- **03-PLAN-FeedbackConsolidation.md:** Consolidation template exists

### Optional

- **jq:** For JSON parsing (if using config files)
- **notify-send/terminal-notifier:** For completion notifications
- **tmux/screen:** For terminal session management (advanced)

---

## Documentation Requirements

### User Documentation

1. **Quick Start Guide**
   - Basic usage: `/spec-review-multi @SPEC.md`
   - Common options
   - Troubleshooting

2. **Advanced Usage**
   - Custom model selection
   - Timeout configuration
   - Output directory customization

3. **Troubleshooting Guide**
   - Common errors and solutions
   - CLI setup instructions
   - Fallback to manual process

### Developer Documentation

1. **Architecture Overview** (this document)
2. **API Reference** (if exposing functions)
3. **Extension Guide** (adding new models, custom logic)

---

## Conclusion

The Multi-Agent Spec Review Orchestrator transforms a manual, error-prone 4-step process into a single automated command. By leveraging Cursor's CLI capabilities, we can:

- **Save time:** 15-20 minutes per project
- **Reduce errors:** Eliminate manual coordination mistakes
- **Improve consistency:** Standardized prompt generation and file naming
- **Enhance workflow:** Seamless integration with existing steps

The implementation is feasible with current Cursor capabilities, with graceful fallbacks if CLI features are limited. The phased approach allows for MVP delivery followed by iterative improvements based on user feedback.

**Next Steps:**
1. Validate Cursor CLI capabilities (model selection, process management)
2. Build MVP orchestrator skill
3. Test with real spec files
4. Iterate based on feedback
5. Document and promote to global skills

---

*Document Version: 1.0 | Last Updated: 2026-02-01*
