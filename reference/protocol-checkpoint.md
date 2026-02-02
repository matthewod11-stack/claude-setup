# Checkpoint Protocol

> **Purpose:** Mid-session save without full shutdown - preserve state for potential interruption

Execute these steps in order:

---

## Step 1: Assess Current State

Quickly evaluate:
- What task were we working on?
- What's complete vs in-progress?
- Are there any uncommitted changes?

```bash
git status --porcelain | head -10
```

---

## Step 2: Update features.json (if exists)

If `features.json` exists and features were completed:
- Mark completed features as `"status": "pass"`
- Mark in-progress features as `"status": "wip"`

If no features.json, skip this step.

---

## Step 3: Add Checkpoint Note to PROGRESS.md

Append a checkpoint entry to `PROGRESS.md`:

```markdown
---

### Checkpoint: [YYYY-MM-DD HH:MM]

**Currently Working On:** [task description]

**Status:**
- [x] [Completed sub-task]
- [x] [Another completed sub-task]
- [ ] [Remaining sub-task]

**If Resuming:**
1. [Immediate next step]
2. [Key context to remember]

**Files Modified:**
- [file1.ts] - [what changed]
- [file2.ts] - [what changed]
```

---

## Step 4: Optional WIP Commit

Ask the user:
> "Create a WIP commit? (Useful if you might switch branches or want a restore point)"

If yes:
```bash
git add -A
git commit -m "WIP: [current task] - checkpoint

Checkpoint at [time]. Work in progress, may not be complete.
Resume instructions in PROGRESS.md"
```

If no, skip the commit.

---

## Step 5: Output Resume Instructions

```
## Checkpoint Saved

**Current Task:** [description]
**Status:** [X of Y sub-tasks complete]

### To Resume
1. [Immediate next action]
2. [Key context]
3. [Any warnings or gotchas]

**Files touched this session:**
- [list of modified files]

**WIP Commit:** [yes - hash / no - changes uncommitted]

---
Checkpoint complete. Continue working or safely pause.
```

---

## When to Use Checkpoint

Checkpoints are useful for:
- Taking a break but not ending the session
- Before context switches (checking Slack, meetings)
- When you might lose context due to long response times
- Before risky operations (want a restore point)

Checkpoints are lighter than session-end:
- No full verification (quick status only)
- WIP commit is optional
- Designed for quick execution

---

## Differences from Session End

| Aspect | Checkpoint | Session End |
|--------|------------|-------------|
| Verification | Quick status | Full tests/types |
| Commit | Optional WIP | Required (if changes) |
| ROADMAP update | No | Yes |
| Intended for | Pause | Full stop |
| Time to run | ~30 seconds | ~2-5 minutes |
