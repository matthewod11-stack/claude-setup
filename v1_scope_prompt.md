# V1 Scope Definition Prompt

**Role:** You are a product strategist helping define a focused v1 scope for a meal planning application. You will synthesize existing feedback, surface key decisions, and produce a revised roadmap.

**Context:** 
- This is a meal planning app for organizing large home-cooked gatherings
- I'm building this for myself first. User/multi-tenant features are v2.
- v1 success criteria: I can fully plan a 20-person gathering using at least 2 uploaded recipes. The app should be beautiful, responsive, and actually useful for coordinating a large meal.
- Architecture stance: "good enough for me" is fine for v1. We'll revisit when scaling for users.
- Build approach: establish project foundation first, then feature-by-feature vertical slices.

**Inputs you have access to:**
- Original roadmap document
- `consolidated_feedback.md` with synthesized feedback from multiple AI tools

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
- Frame options around the v1 constraint: what do I need to plan a 20-person meal with 2+ recipes?
- If a decision only matters for multi-user scenarios, skip it or note it's deferred to v2.
- Include a "quick take" option where there's an obvious default for a solo-user v1.

---

## Phase 2: Revised Roadmap

After I answer your questions, produce two documents:

### Document 1: `v1_roadmap.md`

```markdown
# V1 Roadmap: [App Name]

**V1 Goal:** Plan a 20-person gathering with 2+ uploaded recipes. Beautiful, responsive, functional.

**User:** Me (single user, no auth/multi-tenant)

**Architecture stance:** Good enough for now. Refactor in v2.

---

## Foundation (Build First)

What needs to exist before any features work. Project structure, core data models, basic layout shell.

- [ ] [Item]
- [ ] [Item]

---

## Features (Build in Order)

### Feature 1: [Name]
**Why it's v1:** [One line tying it to the 20-person meal goal]
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

## Guidelines for Scoping

When deciding v1 vs v2:

1. **Does it help me plan a 20-person meal with uploaded recipes?** If no, it's v2.
2. **Does it require multi-user infrastructure?** If yes, it's v2.
3. **Is it polish or is it function?** Function first, but "beautiful and responsive" is a v1 requirement — don't defer all UI work.
4. **What's the dependency chain?** If feature B requires feature A, and A is v1, consider whether B should be too.

When sequencing features:

1. Each feature should be a vertical slice I can complete and use.
2. Earlier features should unblock later ones where possible.
3. Flag if a feature is higher-risk or might require iteration.

---

**Output:** 
- First, deliver the themed questions and wait for my answers.
- After I respond, generate `v1_roadmap.md` and `v2_parking_lot.md`.
