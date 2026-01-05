# 03: Feedback Consolidation

> **Position:** Step 3 | After: 02-PLAN-SpecReview (multiple runs) | Before: 04-PLAN-ScopingAndRoadmap
> **Requires:** 2+ feedback files from different AI tools
> **Produces:** Single consolidated feedback document with consensus highlighted

---

## Variables

Replace these before using:
- `[PROJECT_NAME]` - Your project name
- `[FEEDBACK_FILES]` - List of feedback files (e.g., "claude_feedback.md, grok_feedback.md, gemini_feedback.md")
- `[OUTPUT_FILE]` - Where to save consolidated feedback (default: `consolidated_feedback.md`)

---

## Role

**Role:** You are a product strategist consolidating feedback from multiple AI tools that reviewed the same product roadmap.

**Context:** I ran the spec review prompt (02-PLAN-SpecReview.md) through several different AI tools and saved their outputs. I need these consolidated into a single, comprehensive document that preserves all insights while highlighting where tools agreed.

**Feedback files:** `[FEEDBACK_FILES]`

---

## Your Task

Review all feedback and produce a consolidated `[OUTPUT_FILE]` that I can use to update the original spec.

---

## Ground Rules

1. **Triage-first.** Lead with prioritized, actionable items. Put raw tool-by-tool notes in an appendix so nothing is lost, but the main document should be decision-ready.
2. **Preserve structure.** Use the same 5 sections from the feedback files.
3. **Attribute sources.** Tag each point with which tool(s) raised it (e.g., `[Claude]`, `[Grok]`, `[Claude, Grok]`).
4. **Flag consensus.** When 2+ tools raised the same issue or idea (even if worded differently), mark it with a `🔺 CONSENSUS` tag. These are high-signal items.
5. **Keep it actionable.** Each point should be something I can act on or decide about. If a tool was vague, note that rather than dropping it.

---

## Output Format

```markdown
# Consolidated Roadmap Feedback

**Project:** [PROJECT_NAME]
**Sources reviewed:** [list each feedback file]
**Date consolidated:** [date]

---

## Consensus Summary

Before diving into sections, list all items that received the 🔺 CONSENSUS tag. Group by section. This is the "if you read nothing else" list.

---

## 1. Structure & Detail Assessment

### Gaps / Too Vague
- [Point] — [Tool(s)]
- [Point] — [Tool(s)] 🔺 CONSENSUS

### Over-Specified / Premature Decisions
- [Point] — [Tool(s)]

### Missing Context or Clarity
- [Point] — [Tool(s)]

### Dependency Issues
- [Point] — [Tool(s)]

---

## 2. Existing Feature Enhancement

For each feature mentioned across the feedback files:

### [Feature Name]
- [Enhancement point] — [Tool(s)]
- [Edge case or failure mode] — [Tool(s)]
- [UX improvement] — [Tool(s)]

(Repeat for each feature. If tools discussed the same feature, combine under one heading.)

---

## 3. New Ideas

List every new feature/idea proposed. Group duplicates.

### [Idea Name] — [Tool(s)] (🔺 CONSENSUS if applicable)
- **Problem it solves:**
- **Why high-leverage:**
- **Compounds with:**

(Repeat for each unique idea.)

---

## 4. Jobs Innovation Lens

### How can I make the complex appear simple?
- [Insight] — [Tool(s)]

### What would this be like if it just worked magically?
- [Insight] — [Tool(s)]

### What's the one thing this absolutely must do perfectly?
- [Insight] — [Tool(s)]

### How would I make this insanely great instead of just good?
- [Insight] — [Tool(s)]

---

## 5. Technical Considerations

### Architectural Concerns
- [Point] — [Tool(s)]

### Mobile/Tablet Responsiveness
- [Point] — [Tool(s)]

### State-of-the-Art Recommendations
- [Point] — [Tool(s)]

### Performance / Scalability
- [Point] — [Tool(s)]

---

## Appendix: Tool-by-Tool Raw Notes

Full unedited feedback from each tool. Nothing is lost — this is the reference when questions arise about specific tool perspectives.

### [Tool Name]
(Paste or summarize full feedback here)

### [Tool Name 2]
(Paste or summarize full feedback here)
```

---

## Process Notes

- When identifying consensus, look for **semantic overlap**, not just identical wording. "Needs better error handling" and "Failure states are undefined" are the same concern.
- If tools contradict each other, include both positions and tag as `⚠️ DIVERGENT` — you'll make the call.
- Prioritize clarity over brevity. You'll be using this to update the spec.

---

## Verification

Before marking this step complete:
- [ ] Consensus Summary leads with prioritized action items
- [ ] Consensus items are tagged with 🔺
- [ ] Divergent opinions are tagged with ⚠️
- [ ] Appendix contains raw notes from each tool (nothing lost)
- [ ] Main sections are decision-ready, not exhaustive

---

## Next Step

Proceed to: **[04-PLAN-ScopingAndRoadmap.md](04-PLAN-ScopingAndRoadmap.md)** for interactive scoping and roadmap creation.

This step uses `AskUserQuestion` to help you make key decisions about v1 scope, then produces an actionable roadmap.

---

*Template version 1.0 | Part of the Workflow Documentation System*
