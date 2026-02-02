---
description: Capture session learnings as searchable solution documents
---

# Compound Knowledge Capture Protocol

> **Purpose:** Extract reusable learnings from debugging sessions and significant problem-solving work.
> **Principle:** First-time problem solving (30 min) becomes future lookup (minutes).

---

## When to Trigger

### Automatic Detection (in `/session-end`)

Prompt "Document what you learned?" when ANY of these apply:

1. **Bug fix commits detected**
   - Commit messages contain: "fix", "bug", "resolve", "patch", "hotfix"
   - Multiple commits touching the same file

2. **Significant investigation work**
   - Session lasted 30+ minutes on a single issue
   - Multiple approaches tried before success
   - Error messages encountered and resolved

3. **New pattern introduced**
   - First usage of a library/API in the project
   - Architectural decision made and implemented
   - Workaround for a limitation discovered

4. **User explicitly requests**
   - User says "let's document this"
   - User runs `/compound` directly

---

## Capture Process

### Step 1: Analyze Session

Review to identify:

```
Sources to examine:
- Recent commits (git log --oneline -10)
- PROGRESS.md last entry
- Conversation history in this session
- Modified files (git diff --stat)
```

Extract:
- What was the problem?
- What was tried?
- What worked?

### Step 2: Extract Problem

Identify and document:

```markdown
## Symptoms
- [Error message 1]
- [Unexpected behavior]
- [When/where it occurred]
```

Look for:
- Stack traces
- Error messages
- Unexpected behavior descriptions

### Step 3: Extract Investigation

Document the journey:

```markdown
## Investigation

### What I tried
1. [First attempt] — Result: [didn't work because...]
2. [Second attempt] — Result: [partially worked]
3. [Final approach] — Result: [success]

### Root Cause
[The actual underlying issue]
```

Include failures — they're valuable for future searchers.

### Step 4: Extract Solution

Capture the working fix:

```markdown
## Solution

\`\`\`[language]
// Working code
\`\`\`

**Steps:**
1. [Step 1]
2. [Step 2]
```

### Step 5: Categorize

Determine the best category:

| Category | Use When |
|----------|----------|
| `build-errors/` | TypeScript, compilation, bundler issues |
| `test-failures/` | Test suite problems |
| `runtime-errors/` | Runtime exceptions, crashes |
| `performance-issues/` | Speed, memory optimizations |
| `integration-issues/` | API, database, external services |
| `patterns/` | Reusable architectural patterns |

### Step 6: Scope Decision

Ask or determine:

**Project-local (`solutions/`):**
- Specific to this codebase
- Uses project conventions
- References project files

**Global (`~/.claude/solutions/[tech]/`):**
- Applies to any project with this tech
- General framework pattern
- Would help in other codebases

### Step 7: Generate Document

Create solution document with:

```markdown
# [Brief Problem Description]

> **Category:** [category]
> **Created:** [YYYY-MM-DD]
> **Project:** [project-name or "universal"]
> **Keywords:** [searchable, comma, separated]

## Symptoms
[From Step 2]

## Investigation
[From Step 3]

## Solution
[From Step 4]

## Prevention
- [ ] Add test case
- [ ] Update CLAUDE.md
- [ ] Create lint rule (if applicable)

## Related
- [Links to docs, issues, etc.]
```

### Step 8: Write File

Save to appropriate location:

```bash
# Project-local
solutions/[category]/[slug].md

# Global
~/.claude/solutions/[tech]/[slug].md
```

Filename format: `[topic]-[specific-issue].md`
- Use lowercase
- Use hyphens for spaces
- Keep descriptive but concise

---

## Example Flow

```
Session: Fixed TypeScript path alias issue that broke imports

Step 1: Analyze
- Commits: "fix: resolve path alias in tsconfig"
- Modified: tsconfig.json, vite.config.ts

Step 2: Extract Problem
- Error: "Cannot find module '@/components/Button'"
- Symptom: Imports worked in IDE but failed at build

Step 3: Extract Investigation
- Tried: Adding paths to tsconfig (didn't fix build)
- Tried: vite-tsconfig-paths plugin (worked!)
- Root cause: Vite doesn't read tsconfig paths by default

Step 4: Extract Solution
- Install vite-tsconfig-paths
- Add to vite.config.ts plugins

Step 5: Categorize
- Category: build-errors

Step 6: Scope
- Global (applies to any Vite + TypeScript project)

Step 7: Generate
- Create document with all sections

Step 8: Write
- Save to: ~/.claude/solutions/typescript/vite-path-aliases.md
```

---

## Integration Points

### With `/session-end`

After verification steps, check for compound triggers:

```
/session-end
    ├── Verify code state
    ├── Archive old sessions
    ├── Update PROGRESS.md
    ├── [Check compound triggers]
    │   └── If triggered → "Document what you learned? (y/n)"
    │       └── If yes → Run compound capture
    └── Create commit
```

### With `/session-start`

Search solutions library before beginning work:

```
/session-start
    ├── Check environment
    ├── [Search solutions for current task keywords]
    │   └── If matches found → "Relevant prior solutions: [list]"
    ├── Read recent progress
    └── Find current task
```

---

## AskUserQuestion Integration

When running interactively, use AskUserQuestion:

**Q1: "Capture this learning?"**
- A) Yes, save to project solutions
- B) Yes, save to global solutions
- C) No, skip

**Q2 (if yes): "Which category?"**
- A) Build error
- B) Test failure
- C) Runtime error
- D) Other (specify)

---

## Quality Checklist

Before saving, verify:

- [ ] **Searchable:** Keywords would help someone find this
- [ ] **Reproducible:** Solution steps are complete
- [ ] **Portable:** Could be understood without full context
- [ ] **Actionable:** Reader knows exactly what to do

---

*Protocol version: 1.0 | Created: 2026-02-01*
