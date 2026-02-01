# Session Start Protocol

> **Purpose:** Establish context at the beginning of a work session

Execute these steps in order:

---

## Step 1: Check Environment

If a `package.json` exists, verify node_modules are installed:
```bash
[ -f package.json ] && [ ! -d node_modules ] && npm install
```

If a `verify-env.sh` or similar script exists, run it.

Report any environment issues before proceeding.

---

## Step 2: Read Recent Progress

Check if `PROGRESS.md` exists at the project root.

If it exists:
- Read the last 50 lines to understand recent session context
- Note the last session date and what was accomplished
- Identify any "Next Session Should" guidance from the previous session

If it doesn't exist:
- Note: "No PROGRESS.md found - this may be a new project or first session"

---

## Step 2.5: Search Solutions Library

Check for relevant prior learnings that might help with the current task.

### Determine Search Keywords

From the previous session's notes or current task:
- Extract domain keywords (e.g., "auth", "database", "api")
- Extract technology keywords (e.g., "typescript", "prisma", "react")
- Extract problem types (e.g., "build", "test", "performance")

### Search Project Solutions

If `solutions/` directory exists:

```bash
grep -r -l "[keyword]" solutions/ 2>/dev/null | head -5
```

### Search Global Solutions

```bash
grep -r -l "[keyword]" ~/.claude/solutions/ 2>/dev/null | head -5
```

### If Matches Found

Include in the session start summary:

```
**Relevant Prior Solutions:**
- solutions/build-errors/typescript-path-aliases.md
- ~/.claude/solutions/react/useeffect-cleanup.md
```

Brief summary of what each contains (read first few lines).

### If No Matches

Skip this section silently — don't mention if nothing found.

---

## Step 3: Find Current Task

Check if `ROADMAP.md` exists.

If it exists:
- Scan for unchecked items: `[ ]` (not `[x]`)
- Find the first unchecked item as the likely "next task"
- Note the section/phase it belongs to
- Check for any items marked with `[WIP]` or similar in-progress indicators

If it doesn't exist:
- Note: "No ROADMAP.md found - consider creating one or using /roadmap skill"

---

## Step 4: Check Feature Status

Check if `features.json` exists.

If it exists:
- Identify any features with status "wip" (work in progress)
- Identify any features with status "blocked"
- Note features that were recently completed (status "pass")

If it doesn't exist:
- Skip this step silently (features.json is optional)

---

## Step 5: Check for Blockers

Look for:
- Uncommitted changes: `git status --porcelain`
- Failing tests (if test command exists in package.json)
- TypeScript errors (if tsconfig.json exists): `npx tsc --noEmit 2>&1 | head -20`

Report blockers that might affect the session.

---

## Output Format

Produce a summary like this:

```
## Session Start Summary

**Last Session:** [date] - [brief summary from PROGRESS.md]
**Previous Guidance:** [any "Next Session Should" notes]

**Current State:**
- Environment: [OK / issues found]
- Uncommitted changes: [yes/no]
- Tests: [passing / failing / not configured]

**Next Task:** [description from ROADMAP.md]
- Location: [section/phase in ROADMAP]
- Context: [relevant background]

**Ready to begin.** Say "let's start" or ask for clarification.
```

---

## Graceful Handling

If tracking files don't exist, don't error. Report what's missing and suggest:
- "Run `/roadmap` to create a task breakdown"
- "Create `PROGRESS.md` to track session history"

This protocol should work for both established projects and new setups.
