# Validation Protocol

> **Purpose:** Define the roadmap validation process for Step 05
> **Used By:** `/roadmap-with-validation`

---

## Overview

Roadmap validation stress-tests the implementation plan before execution begins. Multiple validators review the roadmap looking for:

- Missing dependencies
- Underestimated complexity
- Scope creep
- Sequencing mistakes
- Unclear acceptance criteria

---

## Validation Checklist

### 1. Success Criteria Alignment

**Question:** Does every V1 feature directly contribute to the success criteria?

For each feature:
- How does this help achieve the goal?
- What happens if we cut this?
- Is this actually V1, or V2 in disguise?

**Red Flags:**
- Features justified as "nice to have"
- Features that enable future features but don't serve v1
- Polish items disguised as core functionality

### 2. Dependency Validation

**Question:** Is the sequencing actually correct?

Tests:
- Can Phase 0 deliverables support Phase 1 work?
- Are there hidden dependencies between "parallel" features?
- Does any task assume something not explicitly built earlier?

**Trace Test:**
```
For each task:
  Task X requires → [list everything] → verify each exists earlier
```

**Red Flags:**
- Tasks that "just need" something from another domain
- Shared state modified by multiple features
- Integration points not explicitly defined

### 3. Complexity Audit

**Question:** Are any tasks hiding significant complexity?

For each task:
- Is this one task or 3-5 bundled together?
- Does "implement X" hide research, design, iteration?
- Are there edge cases not in acceptance criteria?

**Red Flags:**
- Vague scope ("handle edge cases")
- Tasks touching multiple files/domains
- External API tasks
- Anything called "simple" or "just"

### 4. Acceptance Criteria Quality

**Question:** Could someone verify each task without asking you?

For each criterion:
- Specific and measurable?
- Covers happy path AND error cases?
- Verification method actually doable?

**Red Flags:**
- "Works correctly" (what is correct?)
- "Handles errors gracefully" (which errors? how?)
- "User can do X" (under what conditions?)

**Fix Pattern:**
```
Before: "User can import recipes"
After: "User pastes URL → system extracts title/ingredients/instructions →
        displays preview → user confirms → recipe appears in list within 3 seconds.
        Error shown if URL invalid or parsing fails."
```

### 5. Risk Assessment

Categories:
- **Technical risk:** Unproven tech, complex integrations
- **Scope risk:** Features likely to expand
- **Dependency risk:** External services, APIs
- **Knowledge risk:** Learning as you build

For each risk:
- Mitigation strategy
- Fallback if it doesn't work
- Phase where addressed

### 6. Parallelization Reality Check

If PARALLEL-READY:
- Are agent boundaries truly independent?
- What happens when both need shared files?
- Is "read-only" list actually read-only?
- How do agents communicate completion?

**Common Issues:**
- Both domains need same component
- Shared types evolve differently
- Integration testing needs both domains

### 7. Out of Scope Validation

Questions:
- All spec features appear in V1 or Out of Scope?
- Any "out of scope" items needed for success criteria?
- Can you resist adding these during execution?

---

## Validator Prompt Template

```markdown
# Roadmap Validation — [MODEL_NAME]

You are a skeptical technical reviewer. Your job is to stress-test this roadmap and find gaps before execution begins.

**Stance:** Assume something is wrong.

**Success Criteria:** [V1_SUCCESS_CRITERIA]

**Review the roadmap below and check:**
1. Success criteria alignment
2. Dependency validation
3. Complexity audit
4. Acceptance criteria quality
5. Risk assessment
6. Parallelization reality check (if applicable)
7. Out of scope validation

**Output Format:**

## Summary Verdict
[APPROVED / APPROVED WITH CHANGES / NEEDS REVISION]

## Key Findings
1. [Finding with severity: Critical/Important/Minor]
2. [Finding]
3. [Finding]

## Required Changes
- [ ] [Specific change needed]
- [ ] [Specific change needed]

## Risks Identified
| Risk | Severity | Mitigation | Phase |
|------|----------|------------|-------|

## Detailed Review
[Section-by-section analysis]

---

**ROADMAP TO REVIEW:**

[PASTE ROADMAP.md CONTENT]
```

---

## Validation Verdicts

### APPROVED

Roadmap is solid. No blocking issues found.

**Criteria:**
- No critical findings
- At most 1-2 minor suggestions
- Dependencies validated
- Acceptance criteria clear

### APPROVED WITH CHANGES

Roadmap is workable but needs specific fixes.

**Criteria:**
- No critical findings
- 1-3 important findings with clear fixes
- Can be fixed without restructuring
- Fixes documented as checklist

### NEEDS REVISION

Roadmap has fundamental issues requiring rework.

**Criteria:**
- Critical findings (missing core dependencies, wrong sequencing)
- Multiple important findings
- Requires restructuring phases
- Success criteria misalignment

---

## Change Application

### Change Categories

**Critical (Must Fix):**
- Missing dependencies
- Wrong phase sequencing
- Success criteria misalignment

**Important (Should Fix):**
- Unclear acceptance criteria
- Complex tasks needing splits
- Missing risk mitigations

**Suggestions (Nice to Have):**
- Additional pause points
- Documentation improvements
- Polish items

### Application Strategies

**Dependency Addition:**
```
Before: Phase 1: User Profile
After:  Phase 0: Foundation
        - [ ] Authentication setup
        Phase 1: User Profile (requires Auth)
```

**Task Splitting:**
```
Before:
- [ ] Build Dashboard

After:
- [ ] Build Dashboard Layout
- [ ] Add Dashboard Widgets
- [ ] Implement Dashboard Data Fetching
```

**Acceptance Criteria Clarification:**
```
Before:
- [ ] Implement Recipe Import
  - Acceptance: User can import recipes

After:
- [ ] Implement Recipe Import
  - Scope: URL paste, parsing, preview, confirmation
  - Acceptance: User pastes URL → system extracts title/ingredients/instructions
                → displays preview → user confirms → recipe appears in list
                within 3 seconds
  - Error Handling: Show error if URL invalid or parsing fails
  - Verification: Manual test with 5 different recipe sites
```

---

## Validation Header

After validation passes, add to ROADMAP.md:

```markdown
> **Validated:** [DATE]
> **Validation Sources:** claude, gpt4, grok, gemini
> **Status:** APPROVED WITH CHANGES
> **Changes Applied:** [N] critical, [N] important
```

---

## Skip Conditions

Skip validation if:
- Project is small (< 2 weeks)
- You've built similar before
- Roadmap came from extensive prior planning
- Using Lite workflow tier

Don't skip if:
- New domain for you
- Large or complex spec
- Multiple interacting features
- Planning parallel execution

---

*Protocol version: 1.0 | Created: 2026-02-01*
