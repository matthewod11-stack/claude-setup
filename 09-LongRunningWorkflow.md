# 09: Long-Running Workflow Reference

> **Position:** Reference Document | Used with: 06-ExecutionSetup, 07-RalphLoop, 08-ParallelBuild
> **Purpose:** Reference for session management during multi-session projects
> **Based on:** [Anthropic: Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
> **Note:** Session infrastructure is scaffolded in [06-ExecutionSetup.md](06-ExecutionSetup.md). This doc is for ongoing reference.

---

## When to Reference This Doc

Use this as a reference when:
- Starting a new session (session start prompt)
- Ending a session (session end prompt)
- Resuming after a break
- Troubleshooting session management issues

**Setup is in [06-ExecutionSetup.md](06-ExecutionSetup.md)** — this doc assumes infrastructure already exists.

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

**Note:** File templates are scaffolded during [06-ExecutionSetup.md](06-ExecutionSetup.md). See that doc for the full templates. Below is a summary of what each file does:

| File | Purpose |
|------|---------|
| `docs/PROGRESS.md` | Session-by-session log of completed work (newest at top) |
| `features.json` | Machine-readable pass/fail status for each feature |
| `docs/KNOWN_ISSUES.md` | Parking lot for blockers and deferred decisions |
| `scripts/dev-init.sh` | Consistent session startup script |
| `PLANS/` | Directory for task plans before implementation |

---

## Session Prompts

### Session Start Prompt

```
I'm continuing work on [PROJECT NAME].

This is a multi-session implementation. Please follow the session protocol:

1. Run ./scripts/dev-init.sh to verify environment
2. Read docs/PROGRESS.md for previous session work
3. Read docs/ROADMAP.md to find the NEXT unchecked task
4. Check features.json for pass/fail status
5. Check docs/KNOWN_ISSUES.md for any blockers

Work on ONE task only (single-feature-per-session rule). Tell me what's next.
```

### Session End Prompt

```
Before ending: Please follow session end protocol:

1. Run verification (tests, type-check)
2. Add session entry to TOP of docs/PROGRESS.md
3. Update features.json with pass/fail status
4. Check off completed task in docs/ROADMAP.md
5. Commit with descriptive message

What's the "Next Session Should" note for PROGRESS.md?
```

### Checkpoint Prompt (Mid-Session)

```
Let's checkpoint. Update docs/PROGRESS.md and features.json
with current state, then we can continue.
```

### After Long Break Prompt

```
Resuming [PROJECT] after a break. Full context reload:

1. Run ./scripts/dev-init.sh
2. Read docs/SESSION_PROTOCOL.md (workflow rules)
3. Read docs/PROGRESS.md (all session history)
4. Check features.json and KNOWN_ISSUES.md

Summarize: where are we, what's next, any blockers?
```

---

## Setup Checklist

**Setup is handled by [06-ExecutionSetup.md](06-ExecutionSetup.md).** After completing Step 06, you will have:

- `docs/PROGRESS.md` — Session tracking
- `docs/KNOWN_ISSUES.md` — Parking lot
- `features.json` — Feature status
- `scripts/dev-init.sh` — Session init script
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

- [07-RalphLoop.md](07-RalphLoop.md) — Autonomous execution within sessions
- [08-ParallelBuild.md](08-ParallelBuild.md) — Multi-agent parallel development
- [00-WorkflowIndex.md](00-WorkflowIndex.md) — Master workflow navigation

---

*Template version 1.0 | Part of the Workflow Documentation System*
