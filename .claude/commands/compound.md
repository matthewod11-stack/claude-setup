---
description: Capture session learnings as searchable solution documents
---

# Knowledge Compound Capture

Capture what you learned this session for future reference.

Follow the protocol in @reference/compound-protocol.md

---

## Step 1: Analyze Session

Gather context about what was accomplished:

```bash
git log --oneline -10
git diff --stat HEAD~3
```

Read `PROGRESS.md` last entry if it exists.

Review the conversation history to identify:
- Problems encountered
- Approaches tried
- Final solution

---

## Step 2: Identify the Learning

Use AskUserQuestion to confirm:

**Question:** "What did you learn this session?"

**Options:**
1. **Bug fix** — Resolved an error or unexpected behavior
2. **Pattern** — Discovered a reusable approach
3. **Integration** — Connected to external service/API
4. **Performance** — Optimized speed or resources
5. **Other** — Describe in chat

---

## Step 3: Extract Components

From the session, extract:

### Symptoms
- What error messages appeared?
- What behavior was unexpected?
- When/where did this occur?

### Investigation
- What approaches were tried?
- What didn't work and why?
- What was the root cause?

### Solution
- What fixed the issue?
- What code/config changes were made?
- What are the exact steps to reproduce the fix?

---

## Step 4: Determine Scope

Use AskUserQuestion:

**Question:** "Where should this solution live?"

**Options:**
1. **Project** — Specific to this codebase (`solutions/`)
2. **Global** — Applies to any project with this tech (`~/.claude/solutions/`)

---

## Step 5: Determine Category

Use AskUserQuestion:

**Question:** "Which category fits best?"

**Options:**
1. **build-errors** — TypeScript, compilation, bundling
2. **test-failures** — Test configuration, mocking
3. **runtime-errors** — Crashes, exceptions
4. **performance-issues** — Speed, memory
5. **integration-issues** — APIs, databases
6. **patterns** — Reusable approaches

---

## Step 6: Generate Document

Create the solution document:

```markdown
# [Brief Problem Description]

> **Category:** [selected-category]
> **Created:** [today's date]
> **Project:** [project-name or "universal"]
> **Keywords:** [searchable, terms, here]

## Symptoms

- [Error message or behavior]
- [When/where it occurred]

## Investigation

### What I tried
1. [Approach 1] — Result: [outcome]
2. [Approach 2] — Result: [outcome]

### Root Cause
[The underlying issue]

## Solution

\`\`\`[language]
// Working code or configuration
\`\`\`

**Steps:**
1. [Step 1]
2. [Step 2]

## Prevention

- [ ] Add test case for this scenario
- [ ] Update CLAUDE.md with guideline

## Related

- [Links to relevant documentation]
```

---

## Step 7: Save Document

Generate a slug from the problem description:
- Lowercase
- Hyphens for spaces
- Descriptive but concise (e.g., `vite-path-aliases.md`)

Save to the appropriate location:

**If project scope:**
```
solutions/[category]/[slug].md
```

**If global scope:**
```
~/.claude/solutions/[tech]/[slug].md
```

Where `[tech]` is: `universal`, `typescript`, `react`, `node`, or `python`

---

## Step 8: Confirm

Output confirmation:

```
## Solution Captured

**File:** [path to saved file]
**Category:** [category]
**Keywords:** [keywords]

This learning is now searchable in future sessions.
```

---

## Skip Conditions

It's okay to skip capture if:
- The fix was trivial (typo, missing import)
- No debugging was required
- The solution is already documented elsewhere
- User declines to capture

---

## Notes

- Focus on **searchability** — good keywords help future sessions find this
- Include **failed approaches** — they're valuable context
- Keep solutions **portable** — could be understood without full project context
- Link to **related docs** — external documentation, Stack Overflow, etc.
