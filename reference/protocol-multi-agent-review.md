---
description: Orchestrate multi-model spec review - spawns 4 parallel agents, consolidates feedback
---

# Multi-Agent Review Protocol

> **Purpose:** Define the orchestration logic for parallel multi-model reviews
> **Used By:** `/spec-review-multi`, `/roadmap-with-validation`

---

## Overview

Multi-agent review spawns parallel agents to review documents from different perspectives. Each agent receives a model-specific prompt emphasizing that model's strengths.

---

## Agent Configuration

### Default Models

| Model | Filename Suffix | Strengths |
|-------|----------------|-----------|
| Claude | `claude_*.md` | Edge cases, security, architectural coherence |
| GPT-4 | `gpt4_*.md` | Implementation feasibility, API design |
| Grok | `grok_*.md` | Unconventional approaches, simplification |
| Gemini | `gemini_*.md` | Industry patterns, breadth, documentation |

### Model-Specific Focus Areas

**Claude:**
```
Focus especially on:
- Edge cases and failure modes
- Security implications
- Architectural coherence
- Long-term maintainability
- Subtle logical errors
```

**GPT-4:**
```
Focus especially on:
- Implementation feasibility
- API design patterns
- Code structure recommendations
- Developer experience
- Practical tradeoffs
```

**Grok:**
```
Focus especially on:
- Unconventional approaches
- Simplification opportunities
- What's over-engineered
- Bold suggestions
- Contrarian perspectives
```

**Gemini:**
```
Focus especially on:
- Industry patterns and alternatives
- Documentation completeness
- Breadth of considerations
- Research-backed recommendations
- Cross-domain insights
```

---

## Spawning Pattern

### Parallel Spawn

All agents should be spawned in a SINGLE message with multiple Task tool calls.

```
Task tool call 1:
- subagent_type: "general-purpose"
- description: "Claude spec review"
- prompt: [Full prompt with Claude focus]

Task tool call 2:
- subagent_type: "general-purpose"
- description: "GPT-4 spec review"
- prompt: [Full prompt with GPT-4 focus]

Task tool call 3:
- subagent_type: "general-purpose"
- description: "Grok spec review"
- prompt: [Full prompt with Grok focus]

Task tool call 4:
- subagent_type: "general-purpose"
- description: "Gemini spec review"
- prompt: [Full prompt with Gemini focus]
```

### Prompt Template

Each agent prompt includes:

1. **Role definition**
2. **Document to review** (full content)
3. **Review instructions** (from template)
4. **Model-specific focus areas**
5. **Output filename instruction**

---

## Monitoring Strategy

### File Polling

Check for output files every 30 seconds:

```bash
# Count completed reviews
ls -la *_feedback.md 2>/dev/null | wc -l
ls -la *_validation.md 2>/dev/null | wc -l
```

### Progress Reporting

Report to user periodically:

```
Review Progress:
- Claude:  ✓ Complete
- GPT-4:   ⏳ Working (5 min)
- Grok:    ⏳ Working (3 min)
- Gemini:  ✗ Not started

Files found: 1/4
```

### Timeout Configuration

- **Per-agent timeout:** 15 minutes
- **Total timeout:** 20 minutes
- **Check interval:** 30 seconds

---

## Completion Handling

### Full Completion (4/4)

Proceed immediately to consolidation.

### Partial Completion (2-3/4)

After timeout:
```
3/4 reviews complete. Grok timed out.

Options:
A) Proceed with 3 reviews (sufficient for consensus detection)
B) Wait 5 more minutes for Grok
C) Retry Grok agent
```

### Minimal Completion (1/4)

```
Only 1/4 reviews complete.

Options:
A) Proceed with single review (no consensus possible)
B) Wait longer (extend timeout by 10 min)
C) Abort and try manual review
```

### No Completion (0/4)

```
No reviews completed within timeout.

This might indicate:
- Model API issues
- Prompt too large
- System resource constraints

Options:
A) Retry with fresh agents
B) Fall back to manual review instructions
C) Check logs for errors
```

---

## Consolidation Logic

### Source Attribution

Every point must be tagged with source model(s):

```markdown
- [Point] — [Claude]
- [Point] — [GPT-4, Grok]
- [Point] — [Claude, GPT-4, Grok, Gemini]
```

### Consensus Detection

**Definition:** Item raised by 2+ models (even if worded differently)

**Detection Method:**
1. Parse all feedback files
2. Extract individual points
3. Semantic matching (not exact wording)
4. Tag matches with 🔺 CONSENSUS

**Semantic Matching Examples:**
- "Needs error handling" ≈ "Failure states undefined"
- "Missing dependency" ≈ "Order unclear"
- "Too complex" ≈ "Should simplify"

### Divergence Detection

**Definition:** Models explicitly disagree on approach

**Tagging:** ⚠️ DIVERGENT

**Format:**
```markdown
⚠️ DIVERGENT: [Topic]
- [Position A] — Claude, GPT-4
- [Position B] — Grok, Gemini
- **Resolution needed:** [What decision is required]
```

---

## Output Format

### Consolidated Feedback (Spec Review)

```markdown
# Consolidated Spec Feedback — [PROJECT_NAME]

**Sources:** claude_feedback.md, gpt4_feedback.md, grok_feedback.md, gemini_feedback.md
**Date:** [DATE]

---

## Consensus Summary

🔺 Items flagged by 2+ reviewers:

1. [Issue] — Claude, GPT-4, Grok
2. [Issue] — Claude, Gemini
3. [Issue] — All 4 models

---

## By Section

### 1. Structure & Detail Assessment
[Points with attribution]

### 2. Existing Feature Enhancement
[Points with attribution]

### 3. New Ideas
[Points with attribution]

### 4. Jobs Innovation Lens
[Points with attribution]

### 5. Technical Considerations
[Points with attribution]

---

## Divergent Opinions

[Any ⚠️ DIVERGENT items]

---

## Appendix: Full Reviews

### Claude
[Full content]

### GPT-4
[Full content]

### Grok
[Full content]

### Gemini
[Full content]
```

### Consolidated Validation (Roadmap)

```markdown
# Roadmap Validation — [PROJECT_NAME]

**Verdict:** [APPROVED / APPROVED WITH CHANGES / NEEDS REVISION]
**Sources:** claude_validation.md, gpt4_validation.md, grok_validation.md, gemini_validation.md
**Date:** [DATE]

---

## Consensus Summary

🔺 High-priority items (2+ validators):

1. [Issue] — Claude, GPT-4, Grok
2. [Issue] — Claude, Gemini

---

## Required Changes

### Critical (Must Fix)
- [ ] [Change] — Flagged by: [Models]

### Important (Should Fix)
- [ ] [Change] — Flagged by: [Models]

### Suggestions (Nice to Have)
- [ ] [Change] — Flagged by: [Models]

---

## Risks Identified

| Risk | Severity | Flagged By | Mitigation |
|------|----------|------------|------------|

---

## Divergent Opinions

[Any ⚠️ DIVERGENT items with resolution guidance]
```

---

## Quality Validation

### Pre-Consolidation Checks

For each feedback file, verify:
- [ ] File exists and has content
- [ ] Contains expected section headers
- [ ] Has substantive content (not just headers)
- [ ] Follows output format

### Post-Consolidation Checks

- [ ] All source files referenced
- [ ] Consensus items tagged with 🔺
- [ ] Divergent items tagged with ⚠️
- [ ] Appendix contains full reviews
- [ ] No points lost in consolidation

---

## Error Handling

### Agent Spawn Failure

```
Failed to spawn [Model] agent.

Options:
A) Continue without [Model]
B) Retry spawn
C) Use different model configuration
```

### Output File Corruption

```
[Model] output file appears corrupted or incomplete.

Options:
A) Exclude from consolidation
B) Request agent retry
C) Include partial content with warning
```

### Consolidation Failure

```
Consolidation failed: [reason]

Manual consolidation instructions:
1. Read all feedback files
2. Identify overlapping concerns
3. Create consolidated document using template
```

---

*Protocol version: 1.0 | Created: 2026-02-01*
