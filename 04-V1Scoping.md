# 04: V1 Scoping (Conditional)

> **Position:** Step 4 (conditional) | After: 03-FeedbackConsolidation | Before: 05-RoadmapCreation
> **Requires:** Original spec + consolidated feedback
> **Produces:** Focused v1_roadmap.md + v2_parking_lot.md
> **When to Use:** When scope is creeping beyond what's realistic for v1

---

## Variables

Replace these before using:
- `[PROJECT_NAME]` - Your project name
- `[PROJECT_DESCRIPTION]` - One-line description (e.g., "a meal planning app for large gatherings")
- `[V1_SUCCESS_CRITERIA]` - Concrete success criteria (e.g., "I can fully plan a 20-person gathering using at least 2 uploaded recipes")
- `[V1_QUALITY_BAR]` - Quality expectations (e.g., "beautiful, responsive, and actually useful")
- `[TARGET_USER]` - Who v1 is for (e.g., "Me (single user, no auth)")
- `[ARCHITECTURE_STANCE]` - Technical debt tolerance (e.g., "good enough for me, refactor in v2")
- `[BUILD_APPROACH]` - Build strategy (e.g., "foundation first, then feature-by-feature vertical slices")
- `[FEEDBACK_FILE]` - Path to consolidated feedback

---

## Role

**Role:** You are a product strategist helping define a focused v1 scope for `[PROJECT_DESCRIPTION]`. You will synthesize existing feedback, surface key decisions, and produce a revised roadmap.

**Context:**
- Project: `[PROJECT_NAME]`
- I'm building this for myself first. Multi-user features are v2.
- v1 success criteria: `[V1_SUCCESS_CRITERIA]`. The app should be `[V1_QUALITY_BAR]`.
- Architecture stance: `[ARCHITECTURE_STANCE]`
- Build approach: `[BUILD_APPROACH]`

**Inputs you have access to:**
- Original roadmap/spec document
- `[FEEDBACK_FILE]` with synthesized feedback from multiple AI tools

---

## Your Task

Help me cut scope to what's realistic for v1 while preserving the core value proposition.

---

## Phase 1: Question Synthesis

Before proposing a v1 scope, you need my input on key decisions.

**Your task:**
1. Review the consolidated feedback for all open questions, ambiguities, and decision points
2. Group them into 5-8 thematic clusters
3. For each theme, give me a single multiple-choice question that captures the core tradeoff

**Format for each theme:**

```markdown
### Theme: [Name]

**Context:** [1-2 sentences on why this matters and what's at stake]

**Question:** [Clear question]

- A) [Option] — [tradeoff/implication in a few words]
- B) [Option] — [tradeoff/implication]
- C) [Option] — [tradeoff/implication]
- D) Other (I'll specify)

**Feedback references:** [Which tools/points raised this]
```

**Guidelines:**
- Collapse related questions into one where possible. I don't want 20 questions.
- Frame options around the v1 constraint: what do I need to achieve `[V1_SUCCESS_CRITERIA]`?
- If a decision only matters for multi-user scenarios, skip it or note it's deferred to v2.
- Include a "quick take" option where there's an obvious default for a solo-user v1.

---

## Phase 2: Revised Roadmap

After I answer your questions, produce two documents:

### Document 1: `v1_roadmap.md`

```markdown
# V1 Roadmap: [PROJECT_NAME]

**V1 Goal:** [V1_SUCCESS_CRITERIA]. [V1_QUALITY_BAR].

**User:** [TARGET_USER]

**Architecture stance:** [ARCHITECTURE_STANCE]

---

## Foundation (Build First)

What needs to exist before any features work. Project structure, core data models, basic layout shell.

- [ ] [Item]
- [ ] [Item]

---

## Features (Build in Order)

### Feature 1: [Name]
**Why it's v1:** [One line tying it to the success criteria]
**Scope:** [What's in, what's explicitly out]
**Acceptance:** [How I know it's done]

### Feature 2: [Name]
...

(Continue for all v1 features, in recommended build sequence)

---

## Out of Scope for V1

Explicit list of things we're not building yet, so I don't scope creep.

- [Thing] — revisit in v2
- [Thing] — only matters with multiple users

---

## Open Risks / Watch Items

Anything that might bite me later. Technical debt I'm knowingly taking on.

- [Risk]
```

### Document 2: `v2_parking_lot.md`

```markdown
# V2 Parking Lot

Everything deferred from v1. Organized so I can pull from this when scoping v2.

---

## User & Scaling Features
- [Feature] — [why deferred]

## Enhanced Functionality
- [Feature] — [why deferred]

## Nice-to-Haves
- [Feature] — [why deferred]

## Open Questions for V2
- [Question that didn't need answering for v1]
```

---

## Scoping Guidelines

When deciding v1 vs v2:

1. **Does it help achieve `[V1_SUCCESS_CRITERIA]`?** If no, it's v2.
2. **Does it require multi-user infrastructure?** If yes, it's v2.
3. **Is it polish or function?** Function first, but `[V1_QUALITY_BAR]` is a v1 requirement — don't defer all UI work.
4. **What's the dependency chain?** If feature B requires feature A, and A is v1, consider whether B should be too.

When sequencing features:

1. Each feature should be a vertical slice I can complete and use.
2. Earlier features should unblock later ones where possible.
3. Flag if a feature is higher-risk or might require iteration.

---

## Verification

Before marking this step complete:
- [ ] All themes from feedback are addressed in questions
- [ ] v1_roadmap.md is focused and achievable
- [ ] v2_parking_lot.md captures everything deferred
- [ ] Success criteria is preserved
- [ ] Feature sequence makes sense

---

## Next Step

After scoping is complete, proceed to: **[05-RoadmapCreation.md](05-RoadmapCreation.md)** to flesh out the implementation details.

---

*Template version 1.0 | Part of the Workflow Documentation System*
