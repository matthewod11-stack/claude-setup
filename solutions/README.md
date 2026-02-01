# Solutions Library

> **Purpose:** Capture problem resolutions and patterns for future reference.
> First-time problem solving (30 min) becomes future lookup (minutes).

---

## Directory Structure

```
solutions/
├── README.md              # This file
├── build-errors/          # TypeScript, compilation, bundling issues
├── test-failures/         # Test suite problems and fixes
├── runtime-errors/        # Runtime exceptions, crashes
├── performance-issues/    # Optimization solutions
├── integration-issues/    # API, database, external service problems
└── patterns/              # Reusable architectural patterns
```

---

## Quick Search

Find relevant solutions:

```bash
# Search by keyword
grep -r "module resolution" solutions/

# Search by error message (partial)
grep -r "Cannot find module" solutions/

# List recent solutions
ls -lt solutions/*/*.md | head -10
```

---

## Solution Document Template

When creating a new solution, use this structure:

```markdown
# [Brief Problem Description]

> **Category:** [build-error | test-failure | runtime-error | performance | integration | pattern]
> **Created:** YYYY-MM-DD
> **Project:** [project-name] (or "universal")
> **Keywords:** [searchable terms]

## Symptoms

- What error messages appeared?
- What behavior was observed?
- When/where did this occur?

## Investigation

### What I tried (including failures)
1. [Approach 1] — Result: [didn't work because...]
2. [Approach 2] — Result: [partially worked but...]

### Root Cause
[The actual underlying issue]

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
- [ ] Create lint rule if applicable

## Related

- [Link to similar solutions]
- [Relevant documentation]
```

---

## Categories

### `build-errors/`
TypeScript compilation errors, module resolution, bundler issues, dependency conflicts.

**Example filenames:**
- `typescript-module-resolution.md`
- `nextjs-build-memory.md`
- `circular-dependency-fix.md`

### `test-failures/`
Test configuration, mocking issues, flaky tests, assertion problems.

**Example filenames:**
- `jest-esm-configuration.md`
- `react-testing-library-act.md`
- `vitest-mock-reset.md`

### `runtime-errors/`
Crashes, exceptions, unexpected behavior in running application.

**Example filenames:**
- `react-hydration-mismatch.md`
- `prisma-connection-pool.md`
- `memory-leak-useeffect.md`

### `performance-issues/`
Speed optimizations, memory usage, bundle size reduction.

**Example filenames:**
- `nextjs-image-optimization.md`
- `reduce-bundle-size.md`
- `database-query-n-plus-one.md`

### `integration-issues/`
External API connections, database setup, third-party services.

**Example filenames:**
- `stripe-webhook-verification.md`
- `supabase-rls-policies.md`
- `openai-rate-limiting.md`

### `patterns/`
Reusable architectural patterns, design decisions, best practices.

**Example filenames:**
- `auth-session-pattern.md`
- `error-boundary-setup.md`
- `optimistic-updates.md`

---

## Naming Convention

Use slugified descriptive names:
```
[topic]-[specific-issue].md
```

Examples:
- `typescript-path-aliases.md`
- `nextjs-dynamic-import.md`
- `prisma-many-to-many.md`

---

## Project vs Global

**Project-local (`solutions/`):**
- Specific to this codebase's architecture
- Uses project-specific patterns or conventions
- References project files or structure

**Global (`~/.claude/solutions/`):**
- Applies to any project using that technology
- General patterns that transfer across codebases
- Framework/library-level solutions

---

## Integration with Workflow

**`/session-start`** searches this library for keywords related to current task.

**`/session-end`** prompts to capture solutions after significant debugging work.

**`/compound`** extracts problem/solution from session and writes to appropriate category.

---

*Library created: 2026-02-01*
