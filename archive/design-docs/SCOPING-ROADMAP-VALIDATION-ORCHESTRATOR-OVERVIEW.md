# Scoping, Roadmap & Validation Orchestrator — Comprehensive Overview

> **Status:** Design Document | **Created:** 2026-02-01  
> **Purpose:** Automate the scoping, roadmap generation, and multi-agent validation workflow (Steps 04-05) into a single orchestrated command

---

## Executive Summary

**Problem:** Currently, creating a validated roadmap requires:
1. Manually running interactive scoping (Step 04) with AskUserQuestion interviews
2. Generating ROADMAP.md from scoping decisions
3. Manually running roadmap validation (Step 05) in separate agents
4. Consolidating validation feedback
5. Incorporating changes back into roadmap

**Solution:** A single slash command `/roadmap-with-validation` that:
- Conducts interactive scoping interviews (AskUserQuestion)
- Generates ROADMAP.md automatically
- Spawns multiple agents for validation (similar to spec review)
- Consolidates validation feedback
- Optionally updates roadmap with validation changes

**Impact:** Reduces a multi-step, multi-agent process to a single interactive command, ensuring roadmap quality before execution begins.

---

## Architecture Overview

### High-Level Flow

```
User: /roadmap-with-validation [SPEC_FILE] [CONSOLIDATED_FEEDBACK]
  │
  ├─► 1. Validate inputs (spec + feedback files exist)
  │
  ├─► 2. Extract project variables from spec
  │
  ├─► 3. PHASE 1: Interactive Scoping (AskUserQuestion)
  │     ├─► Strategic questions (3-4 batches)
  │     ├─► Domain-by-domain triage (with clarifications)
  │     └─► User decisions captured
  │
  ├─► 4. PHASE 2: Generate ROADMAP.md
  │     ├─► Strategic constraints (from Phase 1)
  │     ├─► Feature categorization (V1 Core/Polish/V2)
  │     ├─► Dependency mapping & sequencing
  │     ├─► Parallelizability analysis
  │     ├─► Phase definition & task breakdown
  │     └─► Generate v2_parking_lot.md
  │
  ├─► 5. PHASE 3: Multi-Agent Roadmap Validation
  │     ├─► Generate validation prompts from 05-PLAN-RoadmapValidation.md
  │     ├─► Spawn 4 parallel agents (Claude, GPT-4, Grok, Gemini)
  │     ├─► Each agent reviews ROADMAP.md
  │     └─► Save model-specific validation files
  │
  ├─► 6. PHASE 4: Consolidate Validation Feedback
  │     ├─► Merge all validation reviews
  │     ├─► Identify consensus issues
  │     └─► Generate consolidated_validation.md
  │
  └─► 7. PHASE 5: Update Roadmap (Optional)
        ├─► Incorporate required changes
        ├─► Update ROADMAP.md
        └─► Mark as validated
```

### Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│              Orchestrator Skill                              │
│      (.claude/commands/roadmap-with-validation.md)          │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│   Scoping    │   │   Roadmap    │   │  Validation   │
│  Interviewer │   │   Generator  │   │  Orchestrator │
└──────────────┘   └──────────────┘   └──────────────┘
        │                   │                   │
        │                   │                   │
        ▼                   ▼                   ▼
┌─────────────────────────────────────────────────────────────┐
│                    AskUserQuestion                          │
│              (Interactive decision points)                  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
              ┌─────────────────────────┐
              │      ROADMAP.md         │
              │   v2_parking_lot.md     │
              └─────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│              Cursor CLI (agent chat)                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │ Claude   │  │  GPT-4   │  │   Grok   │  │  Gemini  │  │
│  │ Validator│  │ Validator│  │ Validator│  │ Validator│  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
              ┌─────────────────────────┐
              │  Validation Files       │
              │  • claude_validation.md │
              │  • gpt4_validation.md   │
              │  • grok_validation.md   │
              │  • gemini_validation.md │
              └─────────────────────────┘
                            │
                            ▼
              ┌─────────────────────────┐
              │   Consolidator          │
              │  (consolidated_validation)│
              └─────────────────────────┘
                            │
                            ▼
              ┌─────────────────────────┐
              │  Updated ROADMAP.md     │
              │  (with validation fixes)│
              └─────────────────────────┘
```

---

## User Experience Flow

### Before (Current Manual Process)

```
1. User runs 04-PLAN-ScopingAndRoadmap.md
   → Reads spec + consolidated feedback
   → Uses AskUserQuestion for strategic decisions
   → Categorizes features (V1 Core/Polish/V2)
   → Maps dependencies
   → Generates ROADMAP.md + v2_parking_lot.md
   → Time: ~30-45 minutes

2. User opens Cursor Terminal 1
   → Loads 05-PLAN-RoadmapValidation.md
   → Sets model to Claude
   → Reviews ROADMAP.md
   → Saves claude_validation.md

3. User opens Cursor Terminal 2
   → Loads 05-PLAN-RoadmapValidation.md
   → Sets model to GPT-4
   → Reviews ROADMAP.md
   → Saves gpt4_validation.md

4. User opens Cursor Terminal 3
   → Loads 05-PLAN-RoadmapValidation.md
   → Sets model to Grok
   → Reviews ROADMAP.md
   → Saves grok_validation.md

5. User opens Cursor Terminal 4
   → Loads 05-PLAN-RoadmapValidation.md
   → Sets model to Gemini
   → Reviews ROADMAP.md
   → Saves gemini_validation.md

6. User manually consolidates validation feedback
   → Reads all 4 validation files
   → Identifies consensus issues
   → Updates ROADMAP.md manually
   → Time: ~20-30 minutes
```

**Total Time:** ~50-75 minutes  
**Error-prone:** Manual coordination, missed validation issues, inconsistent updates

### After (Orchestrated)

```
User: /roadmap-with-validation @SPEC.md @consolidated_feedback.md

Orchestrator:
  ✓ Validating inputs...
  ✓ Extracting project variables...
  
  📋 PHASE 1: Interactive Scoping
  → Asking strategic questions...
  
  [AskUserQuestion appears]
  Q1: Success Criteria - Is your v1 goal still correct?
     A) Yes, as stated
     B) Modified based on feedback
     C) Need to refine
  
  [User selects B]
  
  Q2: Quality Bar - What quality level for v1?
     A) Functional only
     B) Polished
     C) Production-ready
  
  [User selects B]
  
  → Processing domain triage...
  → Categorizing features...
  
  📋 PHASE 2: Generating Roadmap
  ✓ Strategic constraints documented
  ✓ Features categorized (12 V1 Core, 5 V1 Polish, 8 V2)
  ✓ Dependencies mapped
  ✓ Parallelizability: PARALLEL-READY (2 agents)
  ✓ ROADMAP.md generated
  ✓ v2_parking_lot.md generated
  
  📋 PHASE 3: Multi-Agent Validation
  ✓ Generating validation prompts...
  ✓ Spawning agents:
    • Claude validator started (PID: 12345)
    • GPT-4 validator started (PID: 12346)
    • Grok validator started (PID: 12347)
    • Gemini validator started (PID: 12348)
  
  ⏳ Waiting for validations...
  [Progress: ████████░░] 3/4 complete
  
  ✓ All validations complete!
  
  📋 PHASE 4: Consolidating Feedback
  ✓ Consensus issues identified (3 high-priority)
  ✓ Divergent opinions flagged (1)
  ✓ consolidated_validation.md saved
  
  📋 PHASE 5: Updating Roadmap
  → Found 3 required changes:
    1. Add missing dependency: Auth → User Profile
    2. Clarify acceptance criteria for Task X
    3. Split complex task into 3 subtasks
  
  → Apply changes automatically? (y/n)
  [User selects y]
  
  ✓ ROADMAP.md updated with validation fixes
  ✓ Roadmap marked as VALIDATED
  
  🎉 Ready for execution! (06-EXEC-Setup.md)
```

**Total Time:** ~20-30 minutes (mostly waiting for validation)  
**Error-free:** Automated validation, consensus detection, roadmap updates

---

## Technical Implementation

### 1. Skill File Structure

**Location:** `.claude/commands/roadmap-with-validation.md`

```markdown
---
description: Interactive scoping → roadmap generation → multi-agent validation → consolidated updates
arguments:
  - name: spec_file
    required: true
    description: Path to spec file (e.g., @SPEC.md)
  - name: feedback_file
    required: true
    description: Path to consolidated feedback (e.g., @consolidated_feedback.md)
  - name: auto_update
    required: false
    description: Automatically apply validation changes (default: false, asks first)
  - name: skip_validation
    required: false
    description: Skip validation phase, just generate roadmap (default: false)
---

# Roadmap with Validation Orchestrator

[Implementation details below]
```

### 2. Phase 1: Interactive Scoping

**Process:**
1. Read spec file and consolidated feedback
2. Extract project variables:
   - `[PROJECT_NAME]`
   - `[PROJECT_DESCRIPTION]`
   - `[V1_SUCCESS_CRITERIA]`
   - `[TECH_STACK]`
   - `[TARGET_USER]`
3. Generate strategic questions from spec/feedback context
4. Use `AskUserQuestion` tool for interactive decisions
5. Capture decisions for roadmap generation

**Question Generation Logic:**
- Analyze spec for ambiguous decisions
- Check consolidated feedback for flagged issues
- Generate 3-4 strategic questions per batch
- Each question has 3-4 options + "Other"
- Ask follow-ups as needed during domain triage

**State Management:**
- Store decisions in `.claude/roadmap-scoping-state.json`
- Persist between AskUserQuestion calls
- Use for roadmap generation

### 3. Phase 2: Roadmap Generation

**Process:**
1. Use scoping decisions from Phase 1
2. Read `04-PLAN-ScopingAndRoadmap.md` template
3. Execute roadmap generation logic:
   - Strategic constraints section
   - Feature categorization (V1 Core/Polish/V2)
   - Dependency mapping
   - Parallelizability analysis
   - Phase definition
   - Task breakdown
4. Generate `ROADMAP.md`
5. Generate `v2_parking_lot.md`

**Template Processing:**
- Replace all `[VARIABLE]` placeholders
- Use scoping decisions for strategic constraints
- Categorize features based on success criteria
- Map dependencies from spec analysis
- Determine parallelizability from domain boundaries

### 4. Phase 3: Multi-Agent Validation

**Process:**
1. Read `05-PLAN-RoadmapValidation.md` template
2. Generate model-specific prompts:
   - Replace `[ROADMAP_FILE]` with `ROADMAP.md`
   - Replace `[PROJECT_NAME]` with actual name
   - Replace `[V1_SUCCESS_CRITERIA]` with actual criteria
   - Set output filename per model:
     - Claude → `claude_validation.md`
     - GPT-4 → `gpt4_validation.md`
     - Grok → `grok_validation.md`
     - Gemini → `gemini_validation.md`
3. Spawn 4 parallel agents via Cursor CLI
4. Monitor for completion (file polling or process monitoring)

**Validation Prompt Structure:**
```markdown
Review this implementation roadmap for [PROJECT_NAME].

Success Criteria: [V1_SUCCESS_CRITERIA]

Your job: Stress-test the roadmap. Look for:
- Missing dependencies
- Underestimated complexity
- Scope creep
- Sequencing mistakes
- Unclear acceptance criteria

Be skeptical. Assume something is wrong.

[Paste ROADMAP.md content]

Output format: Use the structure from 05-PLAN-RoadmapValidation.md
Save as: [MODEL]_validation.md
```

### 5. Phase 4: Consolidation

**Process:**
1. Read all validation files when complete
2. Extract key findings from each:
   - Required changes
   - Risks identified
   - Consensus issues (2+ agents agree)
   - Divergent opinions
3. Generate `consolidated_validation.md`:
   - Summary verdict (APPROVED / APPROVED WITH CHANGES / NEEDS REVISION)
   - Consensus findings (🔺 tag)
   - Divergent opinions (⚠️ tag)
   - Required changes list
   - Risk assessment table

**Consolidation Logic:**
- Semantic matching for consensus (not just exact wording)
- Prioritize high-severity issues
- Group similar findings
- Preserve all unique insights in appendix

### 6. Phase 5: Roadmap Updates

**Process:**
1. Parse `consolidated_validation.md` for required changes
2. Categorize changes:
   - **Critical:** Must fix (missing dependencies, sequencing errors)
   - **Important:** Should fix (unclear acceptance criteria, scope issues)
   - **Suggestions:** Nice to have (polish, clarifications)
3. If `auto_update=true` or user approves:
   - Apply critical and important changes
   - Update ROADMAP.md
   - Add validation section to roadmap header
   - Generate changelog

**Update Strategies:**
- **Dependency fixes:** Add missing dependencies to phase definitions
- **Task splits:** Break complex tasks into subtasks
- **Acceptance criteria:** Clarify vague criteria
- **Sequencing:** Reorder phases if needed
- **Scope:** Move features between V1/V2 if consensus suggests

---

## File Structure

```
claude-setup/
├── .claude/
│   ├── commands/
│   │   └── roadmap-with-validation.md    # NEW: Orchestrator skill
│   └── roadmap-scoping-state.json        # NEW: Scoping state (temporary)
├── scripts/                              # NEW: Helper scripts
│   ├── generate-roadmap.sh               # Roadmap generation logic
│   ├── spawn-validation-agents.sh        # Validation agent spawning
│   ├── consolidate-validation.sh         # Validation consolidation
│   └── update-roadmap.sh                 # Roadmap update logic
├── 04-PLAN-ScopingAndRoadmap.md          # Template (unchanged)
├── 05-PLAN-RoadmapValidation.md          # Template (unchanged)
└── SCOPING-ROADMAP-VALIDATION-ORCHESTRATOR-OVERVIEW.md  # This document
```

---

## Error Handling

### Failure Scenarios

| Scenario | Detection | Recovery |
|----------|-----------|----------|
| **Spec/feedback missing** | File read fails | Prompt user for correct paths |
| **Variables not extracted** | Template has `[VAR]` | Extract from spec or prompt user |
| **AskUserQuestion fails** | Tool unavailable | Fallback to conversational questions |
| **Roadmap generation fails** | Template error | Show error, allow manual generation |
| **Validation agent fails** | Process/timeout | Retry or proceed with available reviews |
| **Consolidation fails** | Error reading files | Show error, allow manual consolidation |
| **Roadmap update fails** | Parse/apply error | Show changes, allow manual update |

### Timeout Strategy

- **Scoping phase:** No timeout (user-driven)
- **Roadmap generation:** 5 minutes max
- **Per-validation agent:** 15 minutes
- **Total validation:** 20 minutes
- **Consolidation:** 5 minutes
- **Roadmap update:** 5 minutes

### Graceful Degradation

- **Partial validation:** Proceed with ≥2 reviews
- **No consensus:** Flag as "needs manual review"
- **Update failures:** Show diff, allow manual application

---

## Integration with Existing Workflow

### Current Workflow (Steps 01-05)

```
01-PLAN-SpecInterview.md
  ↓
/spec-review-multi @SPEC.md
  ├─► Auto-runs 02 (4x parallel)
  ├─► Auto-runs 03 (consolidation)
  └─► Produces consolidated_feedback.md
  ↓
04-PLAN-ScopingAndRoadmap.md (manual)
  ↓
05-PLAN-RoadmapValidation.md (manual, 4x)
  ↓
06-EXEC-Setup.md
```

### New Workflow (Steps 01-05)

```
01-PLAN-SpecInterview.md
  ↓
/spec-review-multi @SPEC.md
  ├─► Auto-runs 02 (4x parallel)
  ├─► Auto-runs 03 (consolidation)
  └─► Produces consolidated_feedback.md
  ↓
/roadmap-with-validation @SPEC.md @consolidated_feedback.md
  ├─► Interactive scoping (AskUserQuestion)
  ├─► Auto-generates ROADMAP.md
  ├─► Auto-runs validation (4x parallel)
  ├─► Auto-consolidates validation
  └─► Optionally updates ROADMAP.md
  ↓
06-EXEC-Setup.md
```

### Backward Compatibility

- Manual process still works (users can run 04-05 separately)
- Orchestrator is optional enhancement
- Can skip validation with `--skip-validation` flag
- Can skip auto-update (review changes manually)

---

## Configuration Options

### Validation Models

```bash
/roadmap-with-validation @SPEC.md @feedback.md --models claude,gpt4,gemini
# Excludes Grok

/roadmap-with-validation @SPEC.md @feedback.md --models claude,gpt4
# Only 2 models (faster)
```

### Auto-Update Behavior

```bash
/roadmap-with-validation @SPEC.md @feedback.md --auto-update
# Automatically apply validation changes

/roadmap-with-validation @SPEC.md @feedback.md --no-auto-update
# Show changes, ask before applying (default)
```

### Skip Validation

```bash
/roadmap-with-validation @SPEC.md @feedback.md --skip-validation
# Generate roadmap only, skip validation phase
```

### Output Directory

```bash
/roadmap-with-validation @SPEC.md @feedback.md --output-dir roadmaps/
# Save roadmap and validation files to roadmaps/ subdirectory
```

---

## Implementation Phases

### Phase 1: MVP (Core Functionality)
- ✅ Basic orchestrator skill
- ✅ Interactive scoping with AskUserQuestion
- ✅ Roadmap generation from template
- ✅ Validation agent spawning
- ✅ Basic consolidation

### Phase 2: Robustness
- ✅ Error handling and timeouts
- ✅ State persistence (scoping decisions)
- ✅ Graceful degradation (partial validation)
- ✅ Progress indicators

### Phase 3: Auto-Updates
- ✅ Validation change detection
- ✅ Roadmap update logic
- ✅ Changelog generation
- ✅ Diff preview before applying

### Phase 4: Polish
- ✅ Configuration options
- ✅ Better UX (progress bars, status updates)
- ✅ Integration tests
- ✅ Documentation

### Phase 5: Advanced Features
- ✅ Retry failed validators
- ✅ Validation quality scoring
- ✅ Historical validation tracking
- ✅ Roadmap versioning

---

## AskUserQuestion Integration

### Strategic Questions (Phase 1)

**Batch 1: Success Criteria & Scope**
```markdown
Based on the spec and feedback, I need to confirm your v1 goals:

1. Success Criteria: [Current criteria from spec]
   - Is this still correct?
   - Options: A) Yes, B) Modified, C) Need to refine

2. Quality Bar: What quality level for v1?
   - Options: A) Functional only, B) Polished, C) Production-ready

3. Timeline: Any constraints?
   - Options: A) No rush, B) 2-4 weeks, C) ASAP
```

**Batch 2: Feature Prioritization**
```markdown
From the feedback, these features were flagged. Which are non-negotiable for v1?

[List 3-4 features from feedback]
- Options: A) All v1, B) Some v1, C) Defer to v2
```

### Domain Triage Questions (Phase 1, as needed)

**Per Domain:**
```markdown
Domain: [Domain Name]

The spec proposes: [Summary]
Feedback suggests: [Key points]

Questions:
1. Is [Feature X] required for v1 success?
   - Options: A) Yes (V1 Core), B) Nice to have (V1 Polish), C) Defer (V2)

2. [If ambiguous] How should [Edge Case] be handled?
   - Options: [Context-specific options]
```

### Question Generation Logic

1. **Analyze spec** for ambiguous decisions
2. **Check feedback** for flagged issues or consensus items
3. **Generate questions** that:
   - Are specific to this project (not generic)
   - Have clear options based on actual tradeoffs
   - Include context explaining why it matters
   - Batch related questions together

---

## Validation Consolidation Format

### Consolidated Validation Structure

```markdown
# Roadmap Validation — [PROJECT_NAME]

**Reviewed:** [DATE]
**Sources:** claude_validation.md, gpt4_validation.md, grok_validation.md, gemini_validation.md
**Verdict:** [APPROVED / APPROVED WITH CHANGES / NEEDS REVISION]

---

## Consensus Summary

Items flagged by 2+ validators (high priority):

1. 🔺 **Missing Dependency:** Auth → User Profile
   - Flagged by: Claude, GPT-4, Grok
   - Impact: User Profile phase will fail without auth
   - Required Change: Add Auth to Phase 0

2. 🔺 **Unclear Acceptance Criteria:** Task "Implement Recipe Import"
   - Flagged by: Claude, Gemini
   - Issue: Doesn't specify error handling or validation
   - Required Change: Add detailed acceptance criteria

3. 🔺 **Complex Task:** "Build Dashboard" is too large
   - Flagged by: GPT-4, Grok, Gemini
   - Issue: Should be split into 3-4 subtasks
   - Required Change: Break into subtasks

---

## Required Changes

### Critical (Must Fix)

- [ ] Add Auth dependency to Phase 0
- [ ] Clarify acceptance criteria for Recipe Import
- [ ] Split Dashboard task into subtasks

### Important (Should Fix)

- [ ] Add error handling to Shopping List
- [ ] Clarify mobile responsiveness requirements

### Suggestions (Nice to Have)

- [ ] Add more pause points for review
- [ ] Expand risk mitigation strategies

---

## Risks Identified

| Risk | Severity | Flagged By | Mitigation | Phase |
|------|----------|------------|------------|-------|
| External API dependency | High | Claude, GPT-4 | Add fallback plan | Phase 2 |
| State management complexity | Medium | Grok | Simplify approach | Phase 1 |

---

## Divergent Opinions

⚠️ **Parallelization Strategy**
- Claude, GPT-4: Roadmap correctly identifies parallelizable domains
- Grok: Suggests sequential execution for first phase
- **Resolution:** Keep parallel, but add integration checkpoint

---

## Appendix: Per-Model Reviews

### Claude Validation
[Full review content]

### GPT-4 Validation
[Full review content]

### Grok Validation
[Full review content]

### Gemini Validation
[Full review content]
```

---

## Roadmap Update Logic

### Change Detection

**Parse consolidated_validation.md for:**
- Required changes (checkboxes)
- Critical/Important/Suggestions categories
- Specific task/phase references

### Update Strategies

**1. Dependency Addition**
```markdown
Before: Phase 1: User Profile
After: Phase 0: Foundation
  - [ ] Authentication setup
Phase 1: User Profile (requires Auth)
```

**2. Task Splitting**
```markdown
Before:
- [ ] Build Dashboard

After:
- [ ] Build Dashboard Layout
- [ ] Add Dashboard Widgets
- [ ] Implement Dashboard Data Fetching
```

**3. Acceptance Criteria Clarification**
```markdown
Before:
- [ ] Implement Recipe Import
  - Acceptance: User can import recipes

After:
- [ ] Implement Recipe Import
  - Scope: URL paste, parsing, preview, confirmation
  - Acceptance: User pastes URL → system extracts title/ingredients/instructions → displays preview → user confirms → recipe appears in list within 3 seconds
  - Error Handling: Show error if URL invalid or parsing fails
  - Verification: Manual test with 5 different recipe sites
```

**4. Sequencing Changes**
```markdown
Before:
Phase 1: Feature A
Phase 2: Feature B

After:
Phase 0: Foundation (includes dependency for Feature B)
Phase 1: Feature A
Phase 2: Feature B
```

### Update Application

1. **Parse ROADMAP.md** into structured format
2. **Apply changes** in order (dependencies first)
3. **Validate** updated roadmap (no broken references)
4. **Generate changelog** of applied changes
5. **Add validation header** to roadmap:
   ```markdown
   > **Validated:** [DATE]
   > **Validation Sources:** claude, gpt4, grok, gemini
   > **Status:** APPROVED WITH CHANGES
   ```

---

## Testing Strategy

### Unit Tests

1. **Scoping State Management**
   - Test decision capture
   - Test state persistence
   - Test variable extraction

2. **Roadmap Generation**
   - Test template processing
   - Test feature categorization
   - Test dependency mapping

3. **Validation Consolidation**
   - Test consensus detection
   - Test change extraction
   - Test risk aggregation

4. **Roadmap Updates**
   - Test change application
   - Test validation (no broken refs)
   - Test changelog generation

### Integration Tests

1. **End-to-End (Mock)**
   - Mock AskUserQuestion responses
   - Mock validation agent outputs
   - Test full orchestration flow

2. **Manual Testing**
   - Run with real spec/feedback
   - Test interactive scoping
   - Test validation spawning
   - Test roadmap updates

### Test Scenarios

| Scenario | Expected Behavior |
|----------|-------------------|
| All phases succeed | Roadmap generated and validated |
| User cancels scoping | Save partial state, allow resume |
| Validation fails (1 agent) | Proceed with 3 reviews, warn user |
| Validation fails (2+ agents) | Ask: retry or proceed |
| Consolidation finds critical issues | Flag as "NEEDS REVISION" |
| Roadmap update fails | Show diff, allow manual update |
| AskUserQuestion unavailable | Fallback to conversational |

---

## Success Metrics

### Quantitative

- **Time Saved:** Reduce from 50-75 min to 20-30 min per roadmap
- **Quality Improvement:** Catch 80%+ of roadmap issues before execution
- **Adoption:** 70%+ of users prefer orchestrator over manual process
- **Validation Coverage:** 95%+ success rate (all 4 validators complete)

### Qualitative

- **User Satisfaction:** "This caught issues I would have missed"
- **Workflow Integration:** Seamless fit into planning → execution flow
- **Decision Quality:** Better scoping decisions through structured questions
- **Roadmap Quality:** Fewer execution surprises due to validation

---

## Risks & Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| **AskUserQuestion fails** | High | Low | Fallback to conversational questions |
| **Scoping state lost** | Medium | Low | Persist to file, allow resume |
| **Validation agents timeout** | Medium | Low | Configurable timeouts, retry logic |
| **Roadmap update breaks structure** | High | Low | Validate after updates, show diff |
| **Too many questions overwhelm user** | Medium | Medium | Batch questions, limit to 3-4 per batch |

---

## Dependencies

### Required

- **Cursor CLI:** `cursor` command available
- **AskUserQuestion tool:** Available in Cursor
- **04-PLAN-ScopingAndRoadmap.md:** Template exists
- **05-PLAN-RoadmapValidation.md:** Template exists
- **Spec file:** From Step 01
- **Consolidated feedback:** From `/spec-review-multi`

### Optional

- **jq:** For JSON parsing (scoping state)
- **diff:** For roadmap change visualization

---

## Future Enhancements

### Short-Term (v1.1)

1. **Scoping Resume**
   - Save state if user cancels
   - Allow resume from last question
   - Show progress indicator

2. **Validation Quality Scoring**
   - Score each validation review
   - Flag low-quality reviews
   - Weight consensus by quality

3. **Roadmap Versioning**
   - Track roadmap versions
   - Show validation history
   - Compare versions

### Medium-Term (v2.0)

1. **Adaptive Question Generation**
   - Learn from user answers
   - Skip questions when answers are obvious
   - Generate follow-ups based on context

2. **Validation Templates**
   - Custom validation checklists per project type
   - Domain-specific validators
   - Integration with project templates

3. **Roadmap Simulation**
   - Estimate timeline from roadmap
   - Identify critical path
   - Suggest optimizations

### Long-Term (v3.0)

1. **AI-Powered Scoping**
   - Suggest feature categorization
   - Recommend dependencies
   - Predict parallelizability

2. **Continuous Validation**
   - Re-validate roadmap as execution progresses
   - Track validation accuracy
   - Learn from execution outcomes

3. **Roadmap Analytics**
   - Track roadmap → execution success rate
   - Identify common validation patterns
   - Improve question generation

---

## Conclusion

The Scoping, Roadmap & Validation Orchestrator combines three critical workflow steps into a single, interactive command. By integrating:

- **Interactive scoping** (AskUserQuestion)
- **Automated roadmap generation**
- **Multi-agent validation**
- **Consolidated feedback**
- **Automated roadmap updates**

We create a seamless flow from spec + feedback → validated roadmap, ensuring quality before execution begins.

**Key Benefits:**
- **Time savings:** 50-75 min → 20-30 min
- **Quality improvement:** Catch issues before execution
- **Consistency:** Standardized validation process
- **User control:** Interactive scoping with automated validation

**Next Steps:**
1. Validate AskUserQuestion integration approach
2. Build MVP orchestrator skill
3. Test with real spec/feedback files
4. Iterate based on feedback
5. Document and promote to global skills

---

*Document Version: 1.0 | Last Updated: 2026-02-01*
