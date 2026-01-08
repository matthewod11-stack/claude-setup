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

## Step 5: Stage and Review Changes

```bash
git status
git diff --stat
```

Review what will be committed. Ask user to confirm the scope is correct.

---

## Step 6: Create Commit

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

## Step 7: Final Summary

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
