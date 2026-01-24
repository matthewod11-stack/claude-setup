# Compound Integration Plan

> **Purpose:** Integrate knowledge compounding concepts into the claude-setup workflow system.
> **Source Research:** [COMPOUND-ENGINEERING-RESEARCH.md](COMPOUND-ENGINEERING-RESEARCH.md)
> **Status:** Planning

---

## Overview

Integrate four enhancements from the Compound Engineering methodology:

| Component | Integration Point | Scope |
|-----------|-------------------|-------|
| Solutions library | New directory structure | Project + global |
| `/compound` capture | Built into `/session-end` | Prompts after significant work |
| Research phase | Augment `01-SpecInterview` | Auto-scan codebase before questions |
| Model-specific reviewers | Enhance `02-SpecReview` | Parallel prompts for Claude/Codex/Gemini |

---

## 1. Solutions Library

### Purpose

Capture problem resolutions and patterns for future reference. First-time problem solving (30 min) becomes future lookup (minutes).

### Structure

**Project-level** (`solutions/` in repo root):
```
solutions/
├── README.md                 # Index, search tips, templates
├── build-errors/
├── test-failures/
├── runtime-errors/
├── performance-issues/
├── database-issues/
├── integration-issues/
└── patterns/
    ├── auth-patterns.md
    ├── error-handling.md
    └── api-design.md
```

**Global-level** (`~/.claude/solutions/`):
```
~/.claude/solutions/
├── README.md
├── universal/               # Cross-project patterns
│   ├── git-workflows.md
│   ├── debugging-strategies.md
│   └── performance-profiling.md
├── typescript/
├── react/
├── node/
└── [framework]/
```

### Solution Document Template

```markdown
# [Brief Problem Description]

> **Category:** [build-error | test-failure | runtime-error | etc.]
> **Created:** YYYY-MM-DD
> **Project:** [project-name] (or "universal")

## Symptoms

- What error messages appeared?
- What behavior was observed?

## Investigation

### What I tried (including failures)
1. [Approach 1] — Result: [didn't work because...]
2. [Approach 2] — Result: [partially worked but...]

### Root Cause
[The actual underlying issue]

## Solution

```[language]
// Working code or configuration
```

## Prevention

- [ ] Add test case for this scenario
- [ ] Update CLAUDE.md with guideline
- [ ] Create lint rule if applicable

## Related

- [Link to similar solutions]
- [Relevant documentation]
```

### Integration with Session Management

**`/session-start`** should:
- Search `solutions/` for keywords related to current task
- Surface relevant prior learnings

**`/session-end`** should:
- Prompt to run `/compound` if significant work detected

---

## 2. `/compound` Integration into `/session-end`

### Trigger Logic

Prompt "Document what you learned?" when `/session-end` detects:
- Bug fix commits (commit messages containing "fix", "bug", "resolve")
- Significant time spent on single issue (multiple related commits)
- New patterns introduced
- User explicitly requests

### Flow

```
/session-end
    │
    ├── Run verification (typecheck, tests)
    ├── Archive old sessions
    ├── Update PROGRESS.md
    │
    └── [NEW] Compound check
            │
            ├── Detect: Was significant problem solved?
            │     │
            │     ├── YES → Prompt: "Document what you learned? (y/n)"
            │     │           │
            │     │           ├── y → Run compound capture
            │     │           │       • Extract problem/solution
            │     │           │       • Determine category
            │     │           │       • Ask: project or global?
            │     │           │       • Write to solutions/
            │     │           │
            │     │           └── n → Continue
            │     │
            │     └── NO → Skip
            │
            └── Commit and finish
```

### Compound Capture Process

When triggered:

1. **Analyze session** — Review commits, PROGRESS.md, conversation
2. **Extract problem** — What symptoms, errors, unexpected behavior?
3. **Extract investigation** — What approaches were tried?
4. **Extract solution** — What worked and why?
5. **Categorize** — Which category fits best?
6. **Scope decision** — Project-local or global pattern?
7. **Write document** — Generate markdown to appropriate location

### Skill Modification

Update `.claude/commands/session-end.md` to include compound prompt logic.

---

## 3. Research-Enhanced Spec Interview

### Current State

`01-PLAN-SpecInterview.md` focuses on asking the user questions to refine requirements.

### Enhancement

Add automated codebase research **before** asking questions.

### Research Phase

```
01-SpecInterview
    │
    ├── [NEW] Research phase (parallel)
    │     │
    │     ├── Pattern scanner
    │     │   "How do we handle similar features?"
    │     │   → Search for related implementations
    │     │
    │     ├── Convention checker
    │     │   "What patterns does CLAUDE.md prescribe?"
    │     │   → Extract relevant guidelines
    │     │
    │     └── Solutions searcher
    │         "Have we solved related problems before?"
    │         → Search solutions/ for relevant entries
    │
    ├── Synthesize research findings
    │
    └── Begin interview (informed by research)
          "I found we handle auth with [pattern] in [file].
           Should this feature follow the same approach?"
```

### Implementation

Modify `01-PLAN-SpecInterview.md`:

```markdown
## Before Asking Questions

Research the codebase to inform your questions:

1. **Similar features:** Use Grep/Glob to find related implementations
   - Search for domain terms (e.g., "auth", "payment", "notification")
   - Identify existing patterns

2. **Project conventions:** Read CLAUDE.md for relevant guidelines
   - Note any prescribed patterns for this domain
   - Check for anti-patterns to avoid

3. **Prior solutions:** Search solutions/ directory
   - Look for related problem resolutions
   - Surface relevant learnings

4. **Synthesize:** Summarize findings before asking questions
   - "I found X pattern in Y location"
   - "CLAUDE.md says to Z for this type of feature"
   - "A previous solution addressed similar issue with..."

Then proceed with interview, referencing research findings.
```

---

## 4. Model-Specific Reviewer Personas

### Concept

Run spec review in **parallel terminals** with different AI models, each with prompts optimized for their strengths.

```
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│  Claude Term    │  │  Codex Term     │  │  Gemini Term    │
│                 │  │                 │  │                 │
│  spec-review-   │  │  spec-review-   │  │  spec-review-   │
│  claude.md      │  │  codex.md       │  │  gemini.md      │
└────────┬────────┘  └────────┬────────┘  └────────┬────────┘
         │                    │                    │
         └────────────────────┼────────────────────┘
                              ▼
                    03-Consolidate Feedback
```

### Model Strengths (To Research)

| Model | Potential Strengths | Review Focus |
|-------|---------------------|--------------|
| **Claude** | Nuance, safety, long context | Edge cases, security implications, architectural coherence |
| **Codex** | Code generation, API knowledge | Implementation feasibility, API design, code patterns |
| **Gemini** | Multimodal, research, breadth | Industry patterns, alternative approaches, documentation |

*Note: These are hypothetical. Actual strengths should be validated through use.*

### Prompt Structure

Each model-specific prompt should:
1. State the review goal
2. Provide the spec to review
3. Emphasize areas where that model excels
4. Request structured output (P1/P2/P3 severity)

### File Structure

```
templates/
├── spec-review-claude.md    # Optimized for Claude's strengths
├── spec-review-codex.md     # Optimized for Codex's strengths
└── spec-review-gemini.md    # Optimized for Gemini's strengths
```

Or integrate into workflow docs:
```
02-PLAN-SpecReview.md
├── ## Claude Review Prompt
├── ## Codex Review Prompt
└── ## Gemini Review Prompt
```

### Output Format (All Models)

```markdown
## Spec Review — [Model Name]

### P1 (Critical) — Must Address
- [Issue]: [Explanation]

### P2 (Important) — Should Address
- [Issue]: [Explanation]

### P3 (Nice-to-Have) — Consider
- [Issue]: [Explanation]

### Questions for Clarification
- [Question]

### Strengths of This Spec
- [Positive observation]
```

### Consolidation

`03-PLAN-ConsolidateFeedback.md` already handles merging divergent feedback. Update to:
- Accept multiple review files as input
- Note which model raised which concern
- Identify consensus vs divergent opinions

---

## Implementation Phases

### Phase 1: Solutions Library (Foundation)

**Effort:** Low
**Value:** High — Creates infrastructure for knowledge capture

Tasks:
- [ ] Create `solutions/` directory structure in repo
- [ ] Create `solutions/README.md` with templates and search tips
- [ ] Create `~/.claude/solutions/` global structure
- [ ] Document 2-3 existing learnings as examples
- [ ] Update `/session-start` to search solutions

**Files to create/modify:**
- `solutions/README.md` (new)
- `solutions/patterns/.gitkeep` (new, category dirs)
- `~/.claude/solutions/README.md` (new)
- `.claude/commands/session-start.md` (modify)

### Phase 2: Compound Skill (Capture Mechanism)

**Effort:** Medium
**Value:** High — Makes the library grow organically

Tasks:
- [ ] Create `reference/compound-protocol.md` with capture process
- [ ] Modify `/session-end` to detect significant work
- [ ] Add compound prompt to session-end flow
- [ ] Implement solution document generation
- [ ] Add project vs global scope selection

**Files to create/modify:**
- `reference/compound-protocol.md` (new)
- `.claude/commands/session-end.md` (modify)

### Phase 3: Research-Enhanced Planning (Smarter Interviews)

**Effort:** Medium
**Value:** Medium — Improves spec quality

Tasks:
- [ ] Add research phase to `01-PLAN-SpecInterview.md`
- [ ] Define research prompts for common domains
- [ ] Test parallel research with Task tool
- [ ] Document research patterns in reference/

**Files to create/modify:**
- `01-PLAN-SpecInterview.md` (modify)
- `reference/research-patterns.md` (new, optional)

### Phase 4: Model-Specific Reviewers (Multi-Perspective)

**Effort:** Medium-High
**Value:** Medium — Better review coverage

Tasks:
- [ ] Research actual model strengths through use
- [ ] Create `spec-review-claude.md` prompt
- [ ] Create `spec-review-codex.md` prompt
- [ ] Create `spec-review-gemini.md` prompt
- [ ] Update `02-PLAN-SpecReview.md` with multi-model workflow
- [ ] Update `03-PLAN-ConsolidateFeedback.md` for multi-source input

**Files to create/modify:**
- `templates/spec-review-claude.md` (new)
- `templates/spec-review-codex.md` (new)
- `templates/spec-review-gemini.md` (new)
- `02-PLAN-SpecReview.md` (modify)
- `03-PLAN-ConsolidateFeedback.md` (modify)

---

## Open Questions

1. **Solution naming convention?**
   - Slugified title: `fix-typescript-module-resolution.md`
   - Date-prefixed: `2026-01-24-typescript-module-resolution.md`
   - Auto-generated ID: `sol-001-typescript-module-resolution.md`

2. **How to search solutions efficiently?**
   - Grep by keywords
   - Maintain an index file
   - Tags in frontmatter

3. **Global vs project solution criteria?**
   - Global: Applies to any project using that technology
   - Project: Specific to this codebase's patterns/architecture

4. **Model reviewer prompt maintenance?**
   - How often to update based on model capability changes?
   - Should prompts be versioned?

---

## Success Metrics

After implementation, measure:

1. **Knowledge reuse:** How often are solutions referenced?
2. **Resolution time:** Does time-to-fix decrease for similar issues?
3. **Spec quality:** Do multi-model reviews catch more issues?
4. **Interview efficiency:** Does research phase reduce back-and-forth?

---

*Plan created: 2026-01-24*
*Based on: COMPOUND-ENGINEERING-RESEARCH.md*
