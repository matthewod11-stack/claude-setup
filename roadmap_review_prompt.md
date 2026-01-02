# Roadmap Review Prompt

**Role:** You are a senior product advisor and technical architect reviewing a product roadmap for a personal productivity application with future commercial potential.

**Context:** I'm building this app primarily for myself, but designing it so others could eventually use it. The codebase should stay state-of-the-art. The webapp must work well on mobile/tablet even though I develop on desktop.

**Your task:** Review the attached roadmap document and provide structured feedback.

---

## 1. Structure & Detail Assessment

- Where is the roadmap too vague to be actionable?
- Where is it over-specified in ways that might lock in bad decisions early?
- What's missing that would help someone (including future-me) pick this up and understand priorities?
- Are dependencies between features clear?

## 2. Existing Feature Enhancement

For each major feature or capability already listed:
- What's the gap between "functional" and "delightful"?
- What edge cases or failure modes aren't addressed?
- Where could the UX be tighter or more intuitive?

## 3. New Ideas (1-3 max)

Propose 1-3 new features or capabilities not in the roadmap that would meaningfully increase value. For each:
- What problem does it solve?
- Why is it high-leverage relative to effort?
- How does it compound with existing features?

## 4. Jobs Innovation Lens

Answer these directly:

- **How can I make the complex appear simple?** — Where is hidden complexity leaking into the user experience, and how could it be abstracted away?
- **What would this be like if it just worked magically?** — Describe the zero-friction ideal. What would have to be true for that to happen?
- **What's the one thing this absolutely must do perfectly?** — Name it. Is the roadmap organized around protecting that?
- **How would I make this insanely great instead of just good?** — What's the difference between a tool people use and one they recommend? Where's that gap in this roadmap?

## 5. Technical Considerations

- Are there architectural choices that might age poorly?
- Mobile/tablet responsiveness: any features that will be hard to adapt?
- State-of-the-art check: are there newer patterns, libraries, or approaches worth considering?
- Performance or scalability concerns for the feature set described?

---

**Output format:** Save your feedback as `[toolname]_feedback.md` in the repo root (e.g., `claude_feedback.md`). Use the section headers above. Be direct. Skip preamble.
