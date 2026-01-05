# 07: Ralph Loop (Autonomous Execution)

> **Position:** Step 7 (execution) | After: 06-ExecutionSetup | Works with: 08-ParallelBuild
> **Requires:** ROADMAP.md + docs/PROGRESS.md + PLANS/ directory
> **Produces:** Completed code, feature by feature
> **Best For:** Both sequential and parallel execution — ralph loops run inside each agent

---

## Variables

Replace these before using:
- `[PROJECT_NAME]` - Your project name
- `[PHASE_NAME]` - Current phase (e.g., "Phase 1: Core Features")
- `[PHASE_FOCUS]` - One-line description of phase goal
- `[COMPLETION_PROMISE]` - Promise to output when done (default: `PHASE_COMPLETE`)
- `[MAX_ITERATIONS]` - Maximum loop iterations (default: 50)

---

## Overview

You are operating in an autonomous development loop. Follow this protocol exactly.

**Current phase:** `[PHASE_NAME]`
**Focus:** `[PHASE_FOCUS]`

**Core principle:** Ralph Loop is the execution engine. The question isn't "Ralph Loop OR Parallel Build" — it's whether you run 1 ralph loop (sequential) or 2+ ralph loops (parallel).

---

## Session Start Protocol

1. Read `docs/PROGRESS.md` for current progress and context
2. Read `ROADMAP.md` for task list and completion status
3. Identify the next incomplete task
4. If resuming a partial task, review the "Last Attempt" notes in docs/PROGRESS.md

---

## Plan Mode

Before writing any code for a new task:

1. **Create a plan** in `PLANS/task-[id]-plan.md`:
   - Task objective (one sentence)
   - Files that will be modified/created
   - Dependencies or prerequisites
   - Implementation steps (numbered, specific)
   - How you'll verify success
   - Potential failure points

2. **Review the plan against:**
   - Does this align with the task requirements?
   - Am I touching only what's necessary?
   - Are my verification steps concrete?

3. **Only proceed to Execute Mode after plan is written**

---

## Execute Mode

1. Follow your plan step by step
2. Commit after each meaningful change with message referencing plan step
3. If you deviate from plan, update the plan file first with rationale
4. Run verification steps from your plan
5. If verification fails after 3 attempts, mark task BLOCKED with notes

---

## External Dependencies

When a task requires API keys, auth tokens, third-party credentials, or other external configuration:

1. **Do NOT mark as blocked**
2. Implement the feature with the integration point stubbed
3. Add a "Coming Soon" or "Configuration Required" message in the UI where the feature would appear
4. Add an entry to `PENDING_INTEGRATIONS.md`:
   - Feature name
   - What's needed (e.g., "STRIPE_API_KEY in .env")
   - Files to update once available
   - Any setup instructions
5. Add placeholder in `.env.example` with descriptive comment
6. Continue to next task

---

## Session End Protocol

Before outputting your completion promise, update docs/PROGRESS.md:
- Timestamp
- Current task and status (complete/in-progress/blocked)
- What was accomplished this iteration
- Plan adherence: did you follow it or deviate? why?
- Any blockers or notes for next iteration
- Next action

---

## Completion Criteria

- Output `<promise>[COMPLETION_PROMISE]</promise>` when all tasks in current phase are complete or blocked
- Output `<promise>BLOCKED</promise>` if stuck on a critical-path task with no workaround

---

## Rules

1. **Never skip Plan Mode** for new tasks
2. **Never write code** before the plan file exists
3. **External dependencies are not blockers** — stub and document
4. **Commit frequently** with descriptive messages
5. **Don't refactor unrelated code**
6. If a task is ambiguous, document your interpretation in the plan before proceeding

---

## Soft Warning Conditions

These are signals that you may want to pause and reconsider. Use your judgment — these are warnings, not hard stops.

### Consider Stopping If:

| Condition | Why It Matters | Suggested Action |
|-----------|----------------|------------------|
| Same error 3+ consecutive attempts | You may be missing context or taking wrong approach | Step back, re-read plan, try different angle |
| Task scope has grown beyond original acceptance criteria | Scope creep can derail the phase | Note in plan, ask if this is still the right task |
| You need to modify files outside your boundary (parallel) | Boundary violations cause merge conflicts | Document the need, flag for orchestrator |
| Tests pass but behavior feels wrong | Passing tests ≠ correct behavior | Add more specific tests, verify against requirements |
| You're unsure which of 2+ valid approaches to take | Arbitrary choice now may cause rework later | Pick simplest, document alternatives in plan |
| Task is taking significantly longer than similar tasks | May indicate hidden complexity or wrong approach | Checkpoint progress, reassess plan |

### When to Actually Stop

Output `<promise>BLOCKED</promise>` or flag for human if:
- You've tried 3+ different approaches and all failed
- The task fundamentally conflicts with another requirement
- You discover the roadmap/spec is incorrect
- External dependency is actually blocking (not stubbable)

**Philosophy:** It's better to pause and ask than to iterate 20 times heading the wrong direction.

---

## Plugin Integration

### Known Issue: Skill Command Workaround

The `/ralph-loop` skill command may fail with a newline security error. Use the direct script instead:

**Starting the loop:**
```bash
/Users/mattod/.claude/plugins/marketplaces/claude-plugins-official/plugins/ralph-wiggum/scripts/setup-ralph-loop.sh "[PHASE_FOCUS]" --completion-promise "[COMPLETION_PROMISE]" --max-iterations [MAX_ITERATIONS]
```

**During execution:**
- `/commit` — Commit completed work
- `/code-review` — Review before moving to next task (optional)

**Canceling:**
```
/cancel-ralph
```
Or manually delete the state file:
```bash
rm .claude/ralph-loop.local.md
```

### Monitoring the Loop

```bash
# Check loop state
head -10 .claude/ralph-loop.local.md

# Check current iteration
grep '^iteration:' .claude/ralph-loop.local.md

# View git progress
git log --oneline -10
```

---

## Running Parallel Ralph Loops

When your roadmap indicates parallelizable work, run multiple ralph loops simultaneously. Each agent gets its own terminal/session.

### Agent Prompt Template

```
You are Agent [A/B] for [PROJECT_NAME].

PHASE: [PHASE_NAME]
FOCUS: [AGENT_SPECIFIC_FOCUS]

YOUR BOUNDARY (you own these):
├── /app/[domain]/           # Routes
├── /lib/services/[domain]/  # Service implementation
├── /components/[domain]/    # Domain components
└── /lib/[domain-utils]/     # Domain utilities

SHARED (read-only - do NOT modify):
├── /types/                  # Type definitions
├── /contracts/              # Service interfaces
├── /components/ui/          # Base components
└── /lib/[database]/         # Database client

YOUR TASKS:
[list from ROADMAP.md for this agent]

Read docs/PROGRESS.md and ROADMAP.md, then begin. Create a plan in PLANS/ before
implementing each task. Update docs/PROGRESS.md after completing each task.
Commit frequently with [Agent A/B] suffix.

Start the Ralph loop by running:
/Users/mattod/.claude/plugins/marketplaces/claude-plugins-official/plugins/ralph-wiggum/scripts/setup-ralph-loop.sh "[FOCUS]" --completion-promise "AGENT_[A/B]_COMPLETE" --max-iterations 50
```

### Parallel Agent Coordination

**State file conflict:** Both agents share `.claude/ralph-loop.local.md`. Options:
- Start agents ~30 seconds apart
- Use git worktrees for true isolation
- In practice, each agent manages their own loop state file

**Commit convention:**
- Agent A: `feat(domain-a): description [Agent A]`
- Agent B: `feat(domain-b): description [Agent B]`

**Context management:**
- Enable auto-compact for long-running loops
- Agents update docs/PROGRESS.md frequently
- If context runs out, restart and resume from docs

---

## Verification Principles

From Boris (archive/boris-workflow.md):

> "Give Claude a way to verify its work. A feedback loop 2-3x the quality of results."

Every task needs a verification method:

| Domain | Verification Method |
|--------|---------------------|
| Backend | Run test suite |
| CLI | Execute bash commands |
| Frontend | Browser testing via Chrome extension |
| API | curl/httpie requests |
| Build | `npm run build` / `cargo build` |

---

## Session Management

This prompt is used with [reference/session-management.md](reference/session-management.md) for session management.

**Session start:**
```bash
./scripts/dev-init.sh
```

**Mid-session checkpoint:**
"Update docs/PROGRESS.md and features.json with current state"

---

## Next Step

When phase is complete:
- Review completed work
- Add any API keys / external configs
- Update features.json status
- Start next phase with fresh Ralph Loop

---

## After Phase 0: Create CLAUDE.md

Once your foundation scaffolding is in place and patterns are emerging, create `CLAUDE.md` in the project root. This file persists across all sessions and gives Claude Code project-specific context.

**Why after Phase 0:** You can't write good project instructions until you know what patterns actually emerged. The scaffolding shapes the conventions.

### Template

```markdown
# CLAUDE.md

## Project
[PROJECT_NAME] — [one-line description]

## Tech Stack
[List technologies, frameworks, versions]

## Key Patterns
- [Pattern]: [Why we use it and how]
- [Convention]: [What to follow]

## Gotchas
- [Thing that's easy to get wrong]
- [Non-obvious behavior]

## Commands
- Test: `[command]`
- Build: `[command]`
- Dev server: `[command]`
- Type check: `[command]`

## Project-Specific Rules
- [Any rules specific to this codebase]
```

**Update it as you go:** When you discover a new pattern or gotcha during development, add it to CLAUDE.md immediately.

---

*Template version 1.0 | Part of the Workflow Documentation System*
