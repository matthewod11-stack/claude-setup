# Session Management — Deep Dive Reference

> **Type:** Reference Document (not a workflow step)
> **Primary Source:** Session prompts are scaffolded in your project via [../06-EXEC-Setup.md](../06-EXEC-Setup.md)
> **This Doc:** Theory, diagrams, and tips for why session management works
> **Based on:** [Anthropic: Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)

---

## When to Reference This Doc

**Your project already has:**
- `SESSION_PROMPTS.md` — The actual check-in/check-out prompts (scaffolded in step 06)
- `scripts/dev-init.sh` — Session start script
- `scripts/session-end.sh` — Session end script

**Come here when you want to understand:**
- Why this approach works
- How sessions relate to context windows
- Tips for avoiding common mistakes
- Diagrams of the session flow

---

## Core Concepts

### The Problem

> "Each new session begins with no memory of what came before."

Context compaction alone is insufficient. Claude loses details, forgets decisions, and may repeat work or contradict earlier choices.

### The Solution

**Structured artifacts** that survive context loss:

| Artifact | Purpose |
|----------|---------|
| `PROGRESS.md` | Session-by-session log of completed work |
| `ROADMAP.md` | Checkbox tracking of all tasks |
| `features.json` | Machine-readable pass/fail status |
| `KNOWN_ISSUES.md` | Parking lot for blockers |
| `dev-init.sh` | Consistent session startup |
| Git commits | Recovery points with context |

### Key Principles

1. **Single-Feature-Per-Session** — Work on ONE task at a time to prevent scope creep
2. **Update Docs After Every Task** — Not just at session end
3. **JSON Over Markdown for Tracking** — Resists inappropriate model edits
4. **Explicit Handoff Notes** — "Next Session Should..." in PROGRESS.md
5. **Verification Before Marking Complete** — Tests must pass

---

## Quick Reference Card

```
╔═══════════════════════════════════════════════════════════════════════╗
║  LONG-RUNNING PROJECT SESSION MANAGEMENT                              ║
╠═══════════════════════════════════════════════════════════════════════╣
║                                                                       ║
║  SESSION START:                                                       ║
║    ./scripts/dev-init.sh                                              ║
║                                                                       ║
║  DURING SESSION:                                                      ║
║    • Work on ONE task at a time                                       ║
║    • Update docs after each completed task                            ║
║    • Commit frequently with descriptive messages                      ║
║                                                                       ║
║  CHECKPOINT (anytime, especially if context getting long):            ║
║    "Update PROGRESS.md and features.json with current state"          ║
║                                                                       ║
║  SESSION END (before compaction or stopping work):                    ║
║    "Before ending: Please follow session end protocol:                ║
║     1. Run verification                                               ║
║     2. Add session entry to TOP of PROGRESS.md                        ║
║     3. Update features.json with pass/fail status                     ║
║     4. Check off completed task in ROADMAP.md                         ║
║     5. Commit with descriptive message                                ║
║     What's the 'Next Session Should' note for PROGRESS.md?"           ║
║                                                                       ║
║  IF BLOCKED:                                                          ║
║    Add to KNOWN_ISSUES.md → Move to next independent task             ║
║                                                                       ║
╚═══════════════════════════════════════════════════════════════════════╝
```

---

## Session Workflow Diagram

```
SESSION START                    DURING SESSION                    SESSION END
─────────────                    ──────────────                    ───────────

./scripts/dev-init.sh            Work on ONE task                  Context getting long?
       │                                │                                 │
       ▼                                ▼                                 ▼
Read PROGRESS.md ──────────────► Complete task ◄─────────────── Paste end prompt
       │                                │                                 │
       ▼                                ▼                                 ▼
Read features.json                Update docs                      Update all docs
       │                                │                                 │
       ▼                                ▼                                 ▼
Check KNOWN_ISSUES                  Commit                            Commit
       │                                │                                 │
       ▼                                ▼                                 ▼
Pick next task ─────────────────► Next task? ────────────────────► Session ends
                                   (if context
                                    allows)
```

---

## File Templates

**Note:** File templates are scaffolded during [../06-EXEC-Setup.md](../06-EXEC-Setup.md). See that doc for the full templates. Below is a summary of what each file does:

| File | Purpose |
|------|---------|
| `docs/PROGRESS.md` | Session-by-session log of completed work (newest at top) |
| `features.json` | Machine-readable pass/fail status for each feature |
| `docs/KNOWN_ISSUES.md` | Parking lot for blockers and deferred decisions |
| `scripts/dev-init.sh` | Consistent session startup script |
| `PLANS/` | Directory for task plans before implementation |

---

## Session Prompts

**Note:** The actual prompts are scaffolded into your project as `SESSION_PROMPTS.md` during step 06. This reference doc doesn't duplicate them.

Your project will have:
- `SESSION_PROMPTS.md` — Copy-paste prompts for check-in, check-out, checkpoint, resuming
- `scripts/dev-init.sh` — Run at session start
- `scripts/session-end.sh` — Run at session end

---

## Setup Checklist

**Setup is handled by [../06-EXEC-Setup.md](../06-EXEC-Setup.md).** After completing Step 06, you will have:

- `SESSION_PROMPTS.md` — Check-in/check-out prompts (in project root)
- `docs/PROGRESS.md` — Session tracking
- `docs/KNOWN_ISSUES.md` — Parking lot
- `features.json` — Feature status
- `scripts/dev-init.sh` — Session start script
- `scripts/session-end.sh` — Session end script
- `PLANS/` — Task plan directory

---

## Understanding Sessions vs Tasks

**Session = Context Window** (not calendar day, not task)

```
┌─────────────────────────────────────────────────────────────┐
│  Context Window                                             │
│                                                             │
│  Task A ──► Task B ──► Task C ──► [Context limit]           │
│    ↓          ↓                         ↓                   │
│  Update    Update              SESSION ENDS                 │
│   docs      docs               (update docs)                │
└─────────────────────────────────────────────────────────────┘
                              ↓
              ┌───────────────────────────────┐
              │  NEW SESSION                  │
              │  Run init, read progress      │
              │  Continue Task C or next      │
              └───────────────────────────────┘
```

- **Update docs** → After every completed task
- **New session** → After compaction or fresh start
- **Day boundary** → Doesn't matter much
- **Can complete multiple tasks** in one context window
- **Large tasks can span** multiple sessions

---

## Tips for Success

1. **Start sessions the same way** — Always run dev-init.sh
2. **Checkpoint often** — Don't wait for context limit
3. **PROGRESS.md entries at TOP** — Most recent first
4. **Descriptive commits** — They serve as documentation
5. **Park blockers immediately** — Don't let them derail progress
6. **JSON for tracking** — Resists inappropriate edits
7. **Verify before marking complete** — Tests must pass

---

## Related Documents

- [../07-EXEC-RalphLoop.md](../07-EXEC-RalphLoop.md) — Autonomous execution within sessions
- [parallel-build.md](parallel-build.md) — Multi-agent parallel development
- [../00-WorkflowIndex.md](../00-WorkflowIndex.md) — Master workflow navigation

---

*Template version 1.0 | Part of the Workflow Documentation System*
