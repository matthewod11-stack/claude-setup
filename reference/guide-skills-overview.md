# Claude Code: Session Management Skills Pattern

> **Purpose:** Reusable pattern for consistent session management in any Claude Code project

---

## The Problem

Multi-session projects need consistent startup/shutdown protocols:
- Verify environment before starting
- Review previous work and find next task
- Update tracking files and commit before stopping

Without automation, this requires copy-pasting prompts or remembering steps — friction that leads to skipped steps.

---

## The Solution: Custom Skills

Claude Code supports custom **skills** in `.claude/commands/`. When invoked, the skill expands into instructions Claude follows.

### Benefits
- **Zero friction:** Say "run session start" or `/session-start`
- **Consistent execution:** Same protocol every time
- **Project-portable:** Skills live in the repo
- **Explicit:** Only runs when you invoke it

---

## What We Built

Three complementary skills:

| Skill | Command | Purpose |
|-------|---------|---------|
| Session Start | `/session-start` | Verify env, review progress, find next task |
| Session End | `/session-end` | Verify code, update tracking, commit |
| Checkpoint | `/checkpoint` | Mid-session save without full shutdown |

---

## File Structure

```
your-project/
├── .claude/
│   └── commands/
│       ├── session-start.md
│       ├── session-end.md
│       └── checkpoint.md
├── CLAUDE.md              # References the skills
├── docs/
│   └── PROGRESS.md        # Session work log
├── features.json          # Feature tracking
└── ROADMAP.md             # Task list
```

---

## Skill File Format

```markdown
---
description: Brief description for skill discovery
---

# Skill Title

Step-by-step instructions...

## Step 1: Do Something
Details...

## Output Format
Expected output structure...
```

---

## The Three Skills

### `/session-start`

1. Run environment verification script
2. Read PROGRESS.md for previous session context
3. Read ROADMAP.md to find next unchecked task
4. Check features.json for status
5. Check for blockers
6. Report summary with next task

### `/session-end`

1. Run type check / tests
2. Add session entry to PROGRESS.md
3. Update features.json (mark completed as "pass")
4. Check off tasks in ROADMAP.md
5. Log any new issues
6. Commit changes
7. Report "Next Session Should" guidance

### `/checkpoint`

1. Assess current state
2. Update features.json for completed items
3. Add checkpoint note to PROGRESS.md
4. Optional WIP commit
5. Report resume instructions

---

## CLAUDE.md Integration

Add this to your project's CLAUDE.md:

```markdown
## Session Management

| Command | When to Use |
|---------|-------------|
| `/session-start` | Beginning of any work session |
| `/session-end` | Before stopping work |
| `/checkpoint` | Mid-session state save |
```

---

## How to Add to Any Project

1. **Create structure:** `mkdir -p .claude/commands docs`

2. **Create skill files** in `.claude/commands/`:
   - `session-start.md`
   - `session-end.md`
   - `checkpoint.md`

3. **Create tracking files:**
   - `docs/PROGRESS.md` — Session log
   - `features.json` — Status tracking
   - `ROADMAP.md` — Task breakdown

4. **Add to CLAUDE.md** — Reference the skills

5. **Customize** paths and project-specific checks

---

## Why Skills vs Alternatives

| Approach | Tradeoff |
|----------|----------|
| Copy-paste prompts | High friction, easy to forget |
| Bake into CLAUDE.md | Bloats every conversation |
| Hooks (auto-trigger) | Not explicit, can surprise |
| **Skills (commands)** | Explicit + zero friction once set up |

---

## Usage

Just say it naturally:
- "run session start"
- "session end"
- "checkpoint"

Claude recognizes the intent and executes the skill.
