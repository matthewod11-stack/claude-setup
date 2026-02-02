# Philosophy

> "Give Claude a way to verify its work." — Boris Cherny, creator of Claude Code

This workflow system is built on a few core principles.

---

## 1. Verification is Everything

The single most important thing you can do is give Claude a way to verify its work. A feedback loop doubles or triples the quality of results.

**Verification by domain:**

| Domain | Verification Method |
|--------|---------------------|
| Backend | Run test suite |
| CLI | Execute commands |
| Frontend | Browser testing |
| API | curl/httpie |
| Build | `npm run build` |

---

## 2. A Good Plan is Everything

Start in plan mode. Iterate until the plan is solid. Then Claude typically 1-shots the implementation.

**The planning workflow exists because:**
- Ambiguity causes hallucination
- Iteration on ideas is cheap; iteration on code is expensive
- Multiple perspectives catch blind spots
- Clear scope prevents drift

---

## 3. Capture What You Learn

First-time problem solving takes 30 minutes. Future lookup should take seconds.

The `/compound` skill and solutions library exist because:
- You'll hit the same problems across projects
- Debugging is valuable knowledge worth preserving
- Claude can search your learnings at session start

---

## 4. Parallel Work When Possible

Independent domains can run in separate terminals. The `/orchestrate` skill coordinates this.

**Requirements for parallel work:**
- Features belong to distinct domains
- Each domain has own routes/services/components
- Domains share contracts but don't modify each other
- Integration points are well-defined interfaces

---

## 5. Checkpoints Over Perfection

Every major step pauses for review. You can:
- Proceed to next step
- Revise current step
- Skip ahead
- End and save state

This prevents runaway execution and keeps humans in control.

---

## 6. Progressive Disclosure

**Lite tier** (side projects): Spec → Roadmap → Build

**Full tier** (production): Spec → Multi-Agent Review → Consolidate → Roadmap → Validate → Build

Use the minimal process that matches your stakes.

---

## 7. Session Hygiene

Start each session with context. End each session with documentation.

- `/session-start` — Find where you left off
- `/session-end` — Document what you did, commit, capture learnings

This creates a continuous narrative across work sessions.

---

## Sources

- **Boris Cherny** — Claude Code creator, verification philosophy
- **Every.to** — Compound engineering methodology, solutions library concept
- **Steve Jobs** — Design questions integrated into multi-agent reviews
- **Thariq** — Spec interview pattern using `AskUserQuestion`

---

*The goal is not to replace human judgment, but to give Claude the structure it needs to do its best work.*
