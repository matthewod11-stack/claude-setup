---
description: End a work session - verify code, update tracking, commit changes
---

# Session End Protocol

> **Purpose:** Properly close a work session with documentation and clean handoff

Execute these steps in order:

---

## Step 1: Verify Code State

Run appropriate verification for the project:

**If TypeScript project (tsconfig.json exists):**
```bash
npx tsc --noEmit
```

**If tests exist (test script in package.json):**
```bash
npm test
```

**If neither applies:**
- Check for syntax errors in modified files
- Ensure no obvious broken imports

Report the verification status. If verification fails:
- Note the failures
- Ask if user wants to fix before ending session or document as "incomplete"

---

## Step 2: Update PROGRESS.md

Append a new session entry to `PROGRESS.md` (create file if it doesn't exist).

Entry format:
```markdown
---

## Session: [YYYY-MM-DD HH:MM]

### Completed
- [List of tasks/features completed this session]

### In Progress
- [Anything started but not finished]

### Issues Encountered
- [Blockers, bugs, or challenges discovered]

### Next Session Should
- [Clear guidance for the next session]
- [Specific tasks to pick up]
- [Any context that would be helpful]
```

---

## Step 3: Update features.json (if exists)

If `features.json` exists:
- Mark completed features as `"status": "pass"`
- Mark partially complete features as `"status": "wip"`
- Add notes for any blocked features

If `features.json` doesn't exist, skip this step.

---

## Step 4: Update ROADMAP.md (if exists)

If `ROADMAP.md` exists:
- Check off completed items: `[ ]` → `[x]`
- Add `[WIP]` notation to in-progress items if helpful
- Do NOT add new items (that's a separate decision)

---

## Step 5: Knowledge Compound Check

Before committing, check if this session involved significant problem-solving that should be captured.

### Detection Triggers

Prompt "Document what you learned?" if ANY of these apply:

1. **Bug fix commits:** Recent commits contain "fix", "bug", "resolve", "patch"
   ```bash
   git log --oneline -5 | grep -iE "fix|bug|resolve|patch"
   ```

2. **Significant debugging:** Multiple commits touching the same file, or session involved substantial investigation

3. **New pattern introduced:** First usage of a library/API, architectural decision made

### If Triggered

Use AskUserQuestion:

**Question:** "This session involved significant problem-solving. Document for future reference?"

**Options:**
1. **Yes, add to project solutions** — Save to `solutions/`
2. **Yes, add to global solutions** — Save to `~/.claude/solutions/`
3. **No, proceed** — Skip capture

### If User Says Yes

Run the compound capture process from `reference/compound-protocol.md`:

1. **Extract problem:** What symptoms, errors, unexpected behavior?
2. **Extract investigation:** What approaches were tried? What worked?
3. **Determine category:** build-error, test-failure, runtime-error, etc.
4. **Generate document:** Create solution markdown file
5. **Save to location:** Based on scope selection

### Example Compound Output

```markdown
# TypeScript Path Alias Resolution

> **Category:** build-error
> **Created:** 2026-02-01
> **Keywords:** typescript, path, alias, vite, imports

## Symptoms
- "Cannot find module '@/components/Button'"
- Worked in IDE, failed at build

## Solution
Install vite-tsconfig-paths plugin...
```

---

## Step 6: Stage and Review Changes

```bash
git status
git diff --stat
```

Review what will be committed. Ask user to confirm the scope is correct.

---

## Step 7: Create Commit

Create a commit with a descriptive message:

```bash
git add -A
git commit -m "Session: [brief summary of work done]

- [bullet point of key changes]
- [another key change]

Progress: Updated PROGRESS.md with session notes"
```

If there are no changes to commit, skip this step and note "No changes to commit."

---

## Step 8: Final Summary

Output a handoff summary:

```
## Session End Summary

**Duration:** [start time] - [end time] (if known)
**Verification:** [passed / failed with X issues]

### Completed This Session
- [Task 1]
- [Task 2]

### Committed
- [commit hash]: [commit message]

### Next Session Should
1. [Most important next step]
2. [Second priority]
3. [Third priority]

**Session ended cleanly.** Safe to close.
```

---

## Error Handling

**If verification fails:**
- Document the failures in PROGRESS.md
- Ask: "Fix now, or document and end session?"
- If ending anyway, note "Ended with failing tests/types" in commit

**If git commit fails:**
- Check for pre-commit hooks
- Report the failure
- Offer to commit with `--no-verify` if appropriate (and user confirms)

**If PROGRESS.md write fails:**
- Output the session notes to the conversation
- Ask user to manually save them
