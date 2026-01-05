# 05: Roadmap Review (Optional)

> **Position:** Step 5 (optional) | After: 04-PLAN-ScopingAndRoadmap | Before: 06-EXEC-Setup
> **Requires:** `ROADMAP.md` from step 04
> **Produces:** Validated roadmap with identified gaps, risks, or refinements
> **When to Use:** When you want a second opinion before committing to execution

---

## Variables

Replace these before using:
- `[PROJECT_NAME]` - Your project name
- `[V1_SUCCESS_CRITERIA]` - Your success criteria from the roadmap
- `[ROADMAP_FILE]` - Path to ROADMAP.md

---

## Role

**Role:** You are a skeptical technical reviewer. Your job is to stress-test the roadmap and find gaps before execution begins.

**Stance:** Assume something is wrong. Look for:
- Missing dependencies
- Underestimated complexity
- Scope creep hiding in "small" tasks
- Sequencing mistakes
- Unclear acceptance criteria

---

## Review Checklist

### 1. Success Criteria Alignment

**Question:** Does every V1 feature directly contribute to `[V1_SUCCESS_CRITERIA]`?

For each feature, answer:
- [ ] How does this help achieve the success criteria?
- [ ] What happens if we cut this? Can we still hit the goal?
- [ ] Is this actually V1, or did it sneak in from V2?

**Red flags:**
- Features justified as "nice to have" or "while we're at it"
- Features that enable future features but don't serve v1
- Polish items disguised as core functionality

---

### 2. Dependency Validation

**Question:** Is the sequencing actually correct?

- [ ] Can Phase 0 deliverables actually support Phase 1 work?
- [ ] Are there hidden dependencies between "parallel" features?
- [ ] Does any task assume something that isn't explicitly built earlier?

**Test:** For each task, trace backwards:
```
Task X requires → [list everything] → verify each exists in earlier phase
```

**Red flags:**
- Tasks that "just need" something from another domain
- Shared state or data that multiple features modify
- Integration points that aren't explicitly defined

---

### 3. Complexity Audit

**Question:** Are any tasks hiding significant complexity?

For each task, ask:
- [ ] Is this actually one task, or 3-5 tasks bundled together?
- [ ] Does "implement X" hide research, design, and iteration?
- [ ] Are there edge cases not mentioned in acceptance criteria?

**Red flags:**
- Tasks with vague scope ("handle edge cases")
- Tasks that touch multiple files/domains
- Tasks involving external APIs or services
- Anything described as "simple" or "just"

---

### 4. Acceptance Criteria Quality

**Question:** Could someone verify each task is complete without asking you?

For each acceptance criterion:
- [ ] Is it specific and measurable?
- [ ] Does it cover the happy path AND error cases?
- [ ] Is the verification method actually doable?

**Red flags:**
- "Works correctly" (what does correct mean?)
- "Handles errors gracefully" (which errors? how?)
- "User can do X" (under what conditions?)

**Fix pattern:**
```
Before: "User can import recipes"
After: "User can paste a URL, system extracts title/ingredients/instructions,
       displays preview, user confirms, recipe appears in list within 3 seconds.
       Error shown if URL is invalid or parsing fails."
```

---

### 5. Risk Assessment

**Question:** What could go wrong that isn't mentioned?

Categories to check:
- [ ] **Technical risk:** Unproven tech, complex integrations, performance concerns
- [ ] **Scope risk:** Features likely to expand once started
- [ ] **Dependency risk:** External services, APIs, or libraries
- [ ] **Knowledge risk:** Areas where you're learning as you build

For each risk found, propose:
- Mitigation strategy
- Fallback if it doesn't work
- Phase where it should be addressed

---

### 6. Parallelization Reality Check

If roadmap is marked `PARALLEL-READY`:

- [ ] Are agent boundaries truly independent?
- [ ] What happens when both agents need to modify shared files?
- [ ] Is the "shared (read-only)" list actually read-only?
- [ ] How do agents communicate completion/integration?

**Common issues:**
- Both domains need to modify the same component
- Shared types evolve differently in parallel
- Integration testing requires both domains complete

---

### 7. Out of Scope Validation

**Question:** Is the "Out of Scope" list complete and honest?

- [ ] Are there features mentioned in the spec that aren't in V1 or Out of Scope?
- [ ] Are any "out of scope" items actually needed for success criteria?
- [ ] Will you actually be able to resist adding these during execution?

---

## Output Format

After review, produce:

### Summary

```markdown
## Roadmap Review — [PROJECT_NAME]

**Reviewed:** [DATE]
**Verdict:** [APPROVED / APPROVED WITH CHANGES / NEEDS REVISION]

### Key Findings

1. [Finding]: [Recommendation]
2. [Finding]: [Recommendation]
3. [Finding]: [Recommendation]

### Required Changes (if any)

- [ ] [Specific change to roadmap]
- [ ] [Specific change to roadmap]

### Risks Identified

| Risk | Severity | Mitigation | Phase |
|------|----------|------------|-------|
| | | | |

### Approval Conditions

[What must be true before proceeding to execution]
```

---

## Alternative Review Methods

### Option A: External AI Review

Feed the roadmap to a different AI tool (Claude web, ChatGPT, Gemini) with this prompt:

```
Review this implementation roadmap for a software project.
Look for: missing dependencies, underestimated tasks, scope creep,
unclear acceptance criteria, and sequencing mistakes.

Be skeptical. Assume something is wrong.

[paste roadmap]
```

### Option B: Rubber Duck Review

Read the roadmap out loud. For each task, explain:
1. Why this task exists
2. What it requires
3. How you'll know it's done

If you can't explain clearly, the task needs refinement.

### Option C: Inversion Review

Ask: "What would make this project fail?"

Then check if the roadmap addresses each failure mode.

---

## When to Skip This Step

Skip if:
- Project is small (< 2 weeks of work)
- You've built similar projects before
- Roadmap came from extensive prior planning

Don't skip if:
- This is a new domain for you
- The spec was large or complex
- Multiple features interact in non-obvious ways
- You're planning parallel execution

---

## Verification

Before proceeding:
- [ ] All review sections completed
- [ ] Required changes incorporated into roadmap
- [ ] Risks documented with mitigations
- [ ] Verdict is APPROVED or APPROVED WITH CHANGES

---

## Next Step

Proceed to: **[06-EXEC-Setup.md](06-EXEC-Setup.md)** to set up the execution environment.

---

*Template version 1.0 | Part of the Workflow Documentation System*
