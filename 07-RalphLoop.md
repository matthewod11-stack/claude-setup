# 07: Ralph Loop (Autonomous Execution)

> **Position:** Step 7 (execution) | After: 06-ExecutionSetup | Parallel to: 08-ParallelBuild
> **Requires:** ROADMAP.md + SESSION_STATE.md + PLANS/ directory
> **Produces:** Completed code, feature by feature
> **Best For:** Sequential features, test-driven workflows, hands-off execution

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

---

## Session Start Protocol

1. Read `SESSION_STATE.md` for current progress and context
2. Read `ROADMAP.md` for task list and completion status
3. Identify the next incomplete task
4. If resuming a partial task, review the "Last Attempt" notes in SESSION_STATE.md

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

Before outputting your completion promise, update SESSION_STATE.md:
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

## Plugin Integration

**Starting the loop:**
```
/ralph-loop "[PHASE_FOCUS]" --completion-promise "[COMPLETION_PROMISE]" --max-iterations [MAX_ITERATIONS]
```

**During execution:**
- `/commit` — Commit completed work
- `/code-review` — Review before moving to next task (optional)

**Canceling:**
```
/cancel-ralph
```

---

## Verification Principles

From Boris (BorisWorkflow.md):

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

This prompt is used with [09-LongRunningWorkflow.md](09-LongRunningWorkflow.md) for session management.

**Session start:**
```bash
./scripts/dev-init.sh
```

**Mid-session checkpoint:**
"Update SESSION_STATE.md and features.json with current state"

---

## Next Step

When phase is complete:
- Review completed work
- Add any API keys / external configs
- Update features.json status
- Start next phase with fresh Ralph Loop

---

*Template version 1.0 | Part of the Workflow Documentation System*
