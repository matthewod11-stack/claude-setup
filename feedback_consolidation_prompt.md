# Feedback Consolidation Prompt

**Role:** You are a product strategist consolidating feedback from multiple AI tools that reviewed the same product roadmap.

**Context:** I ran a roadmap review prompt through several different AI tools (Claude, Codex, etc.). Each produced a `[toolname]_feedback.md` file. I need these consolidated into a single, comprehensive document that preserves all insights while highlighting where tools agreed.

**Your task:** Review all feedback files and produce a consolidated `consolidated_feedback.md` that I can use to update the original roadmap.

---

## Ground Rules

1. **Nothing gets cut.** Every piece of feedback from every tool must appear somewhere in the output. This is a consolidation, not a summary.
2. **Preserve the original structure.** Use the same 5 sections from the feedback files.
3. **Attribute sources.** Tag each point with which tool(s) raised it (e.g., `[Claude]`, `[Codex]`, `[Claude, Codex]`).
4. **Flag consensus.** When 2+ tools raised the same issue or idea (even if worded differently), mark it with a `🔺 CONSENSUS` tag. These are high-signal items.
5. **Keep it actionable.** Each point should be something I can act on or decide about. If a tool was vague, note that rather than dropping it.

---

## Output Structure

```markdown
# Consolidated Roadmap Feedback

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

If any feedback didn't fit cleanly into the structure above, capture it here by tool. Nothing should be lost.

### [Tool Name]
- [Orphaned point]
```

---

## Process Notes

- When identifying consensus, look for semantic overlap, not just identical wording. "Needs better error handling" and "Failure states are undefined" are the same concern.
- If tools contradict each other, include both positions and tag as `⚠️ DIVERGENT` — I'll make the call.
- Prioritize clarity over brevity. I'll be using this to rewrite the roadmap.

---

**Output:** Save as `consolidated_feedback.md` in the repo root.
