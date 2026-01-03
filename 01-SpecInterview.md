# 01: Spec Interview

> **Position:** Step 1 | After: Ideation/PRD | Before: 02-RoadmapReview
> **Requires:** Initial PRD or spec draft
> **Produces:** Detailed specification document with implementation decisions

---

## Variables

Replace these before using:
- `[SPEC_FILE]` - Path to your spec document (e.g., `@SPEC.md`, `docs/SPEC.md`)
- `[PROJECT_NAME]` - Your project name
- `[OUTPUT_FILE]` - Where to write the completed spec (default: same as SPEC_FILE)

---

## Role

**Role:** You are a senior technical product manager conducting a detailed specification interview. Your goal is to surface hidden complexity, challenge assumptions, and ensure the spec is complete enough to build from.

**Context:**
- Project: `[PROJECT_NAME]`
- Spec Document: `[SPEC_FILE]`

---

## Your Task

Read `[SPEC_FILE]` and interview me in detail using the AskUserQuestion tool about anything that could affect implementation. Don't ask obvious questions — focus on:

- Technical implementation decisions
- UI & UX specifics
- Edge cases and error states
- Tradeoffs between approaches
- Scope boundaries (what's in, what's out)
- Dependencies and integration points

Continue interviewing until the spec is complete, then write the refined spec to `[OUTPUT_FILE]`.

---

## Process

### Phase 1: Initial Read
Read the spec document and identify:
1. **Gaps:** What's mentioned but not detailed?
2. **Ambiguities:** What could be interpreted multiple ways?
3. **Assumptions:** What's implied but not stated?
4. **Risks:** What could go wrong or be harder than expected?

### Phase 2: Structured Interview

Interview across these dimensions (use AskUserQuestion):

**Technical Implementation**
- Data models and schema design
- State management approach
- API structure and contracts
- Third-party integrations
- Performance considerations

**User Experience**
- User flows and navigation
- Form behaviors and validation
- Loading and error states
- Mobile/responsive requirements
- Accessibility needs

**Edge Cases**
- What happens when X fails?
- How to handle empty states?
- Offline behavior?
- Data conflicts or race conditions?

**Scope Boundaries**
- What's explicitly NOT in v1?
- What decisions are being deferred?
- What's the MVP vs nice-to-have?

**Tradeoffs**
- Where are we choosing simplicity over flexibility?
- What technical debt are we accepting?
- What could we regret later?

### Phase 3: Spec Refinement

After the interview, update the spec to include:
- All decisions made during the interview
- Explicit scope boundaries
- Technical approach for each feature
- Open questions that need future resolution

---

## Interview Guidelines

**Good Questions:**
- "The spec mentions [X] but doesn't specify [Y]. How should that work?"
- "There are two approaches to [X]: [A] is simpler but [B] is more flexible. Which fits your needs?"
- "What happens if [edge case]?"
- "You mentioned [X] — is that v1 or can it wait?"

**Avoid:**
- Questions already answered in the spec
- Questions with obvious answers
- Leading questions that assume a particular approach
- Too many questions at once (batch 2-4 max)

---

## Output Format

The refined spec should include:

```markdown
# [PROJECT_NAME] Specification

> **Version:** [X.Y]
> **Last Updated:** [DATE]
> **Status:** Ready for Roadmap Review

---

## Overview
[What this project is and why]

## Success Criteria
[How we know v1 is done]

---

## Features

### Feature 1: [Name]
**Purpose:** [Why this exists]
**User Flow:** [Step by step]
**Technical Approach:** [How it's built]
**Edge Cases:** [What could go wrong]
**Out of Scope:** [What's NOT included]

[Repeat for each feature]

---

## Technical Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| [Area] | [What we chose] | [Why] |

---

## Open Questions

- [Question that can wait until later]

---

## Out of Scope (V1)

- [Feature] — deferred to v2
- [Feature] — not needed for success criteria
```

---

## Plugin Integration

After completing the spec:
- Use `/feature-dev` to validate the feature breakdown makes sense
- Proceed to **02-RoadmapReview.md** for multi-agent review

---

## Verification

Before marking this step complete:
- [ ] All major features have technical approach defined
- [ ] Edge cases and error states addressed
- [ ] Scope boundaries are explicit
- [ ] No obvious gaps or ambiguities remain
- [ ] Success criteria is clear and measurable

---

## Next Step

Proceed to: **[02-RoadmapReview.md](02-RoadmapReview.md)** to get diverse AI perspectives on the spec.

---

*Template version 1.0 | Part of the Workflow Documentation System*
