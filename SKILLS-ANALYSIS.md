Note:  I want a skill for session start and session end protocol.  Essentially I can say /sessionstart - and it runs the full protocol. 

# Skills Analysis: Workflow Capture Strategy

> **Created:** 2026-01-06
> **Purpose:** Evaluate whether Claude Code skills are the right abstraction for the workflow system
> **Status:** Analysis complete, awaiting decision

---

## Context

The workflow system consists of 7 sequential markdown files (01-07) that guide projects from ideation through implementation. The question: should these be converted to Claude Code skills for easier invocation?

---

## What Are Skills?

Skills are markdown files with YAML frontmatter that live in `.claude/skills/` and expand into prompts when invoked via `/skill-name`. They support:

- **Arguments:** Dynamic values passed at invocation
- **File references:** Can include `@file.md` references
- **Descriptions:** Help text shown in autocomplete

Example skill structure:
```yaml
---
name: my-skill
description: What this skill does
arguments:
  - name: input_file
    required: true
    description: The file to process
---
[Prompt content here, can use $ARGUMENTS.input_file]
```

---

## Workflow-to-Skill Mapping

| Workflow File | Recommended | Skill Name | Rationale |
|---------------|-------------|------------|-----------|
| `00-WorkflowIndex.md` | No | — | Reference doc, not actionable |
| `01-PLAN-SpecInterview.md` | Yes | `/spec-interview` | Clear entry point, uses AskUserQuestion |
| `02-PLAN-SpecReview.md` | Yes | `/spec-review` | Standalone action, triggers multi-AI review |
| `03-PLAN-FeedbackConsolidation.md` | Yes | `/consolidate-feedback` | Clear input (reviews) → output (consolidated) |
| `04-PLAN-ScopingAndRoadmap.md` | Yes | `/roadmap` | Core workflow step, produces ROADMAP.md |
| `05-PLAN-RoadmapValidation.md` | Maybe | `/validate-roadmap` | Optional step; could be `--validate` flag on `/roadmap` |
| `06-EXEC-Setup.md` | Yes | `/exec-setup` | Transitions from planning to execution |
| `07-EXEC-RalphLoop.md` | No | — | Already exists as `/ralph-loop` plugin |

---

## Pros of Converting to Skills

### 1. Quick Invocation
```
# Instead of:
"Follow the workflow in 01-PLAN-SpecInterview.md with SPEC_FILE=@docs/SPEC.md"

# You get:
/spec-interview @docs/SPEC.md
```

### 2. Argument Handling
Variables like `[SPEC_FILE]`, `[PROJECT_NAME]`, `[OUTPUT_FILE]` become typed arguments with descriptions and validation.

### 3. Discoverability
Skills appear in `/` autocomplete with descriptions, making the workflow self-documenting.

### 4. Portability
Skills in `~/.claude/skills/` work across all projects. Project-specific skills in `.claude/skills/` travel with the repo.

### 5. Composability
Skills can reference other skills or be chained in custom workflows.

---

## Cons of Converting to Skills

### 1. Prompt Length
These workflows are substantial (4-10KB each). Skills work best for focused, single-purpose tasks. Long skills may:
- Consume more context window
- Be harder to maintain inline
- Lose the benefits of being editable markdown files

### 2. Sequential Dependencies
The workflow is inherently sequential (01 → 02 → 03 → ...). Skills don't encode this dependency—users must know the order.

### 3. Loss of Navigation
The `00-WorkflowIndex.md` provides a nice decision tree for "what step am I on?" This context is lost when workflows become individual skills.

### 4. Maintenance Overhead
Two places to update: the source markdown AND the skill. Changes to the workflow require skill updates.

### 5. Reference Material
Some content (like the Variables table, Verification checklists) is reference material, not prompt content. Skills blur this distinction.

---

## Recommended Approach: Hybrid Strategy

Keep the markdown files as the **source of truth** and create **thin wrapper skills** that reference them.

### Structure
```
claude-setup/
├── .claude/
│   └── skills/
│       ├── spec-interview.md      # Thin wrapper
│       ├── spec-review.md
│       ├── consolidate-feedback.md
│       ├── roadmap.md
│       └── exec-setup.md
├── 00-WorkflowIndex.md            # Keep as reference
├── 01-PLAN-SpecInterview.md       # Keep as source of truth
├── ...
```

### Thin Wrapper Example
```yaml
---
name: spec-interview
description: Interview to refine a spec into buildable detail (Step 01)
arguments:
  - name: spec_file
    required: true
    description: Path to your spec document
  - name: project_name
    required: false
    description: Project name (will ask if not provided)
---
Follow the workflow defined in @01-PLAN-SpecInterview.md

Variables:
- [SPEC_FILE] = $ARGUMENTS.spec_file
- [PROJECT_NAME] = $ARGUMENTS.project_name (or ask if not provided)
- [OUTPUT_FILE] = same as SPEC_FILE unless I specify otherwise
```

### Benefits of Hybrid
- Quick invocation via `/spec-interview @SPEC.md`
- Source of truth remains editable markdown
- Skills stay small and maintainable
- Workflow index still works for orientation
- Can update workflow docs without touching skills (mostly)

---

## Next Steps

### Phase 1: Proof of Concept (1 skill)
1. Create `.claude/skills/` directory in this repo
2. Implement `spec-interview.md` as a thin wrapper skill
3. Test invocation: `/spec-interview @test-spec.md`
4. Verify the workflow executes correctly

### Phase 2: Validate Approach
1. Run through a real project using the skill
2. Compare experience to copy-paste workflow
3. Document friction points
4. Decide: proceed with remaining skills or adjust approach

### Phase 3: Full Implementation (if validated)
1. Create remaining 4 skills (spec-review, consolidate-feedback, roadmap, exec-setup)
2. Consider a `/workflow-status` skill that reads project state and suggests next step
3. Update README with skill-based quick start

### Phase 4: Polish
1. Add argument validation where helpful
2. Consider project-local vs global skill placement
3. Document the skill-based workflow in 00-WorkflowIndex.md

---

## Testing Checklist

### Functional Tests
- [ ] Skill loads without syntax errors
- [ ] Arguments are passed correctly to the workflow
- [ ] File references (`@file.md`) resolve properly
- [ ] AskUserQuestion tool is used appropriately
- [ ] Output is written to correct location

### UX Tests
- [ ] Skill appears in `/` autocomplete
- [ ] Description is helpful and accurate
- [ ] Error messages are clear when arguments missing
- [ ] Workflow feels natural, not forced

### Integration Tests
- [ ] Skills work from any directory (path handling)
- [ ] Skills work with different spec file locations
- [ ] Handoff between skills is smooth (01 output works as 02 input)

### Edge Cases
- [ ] What happens if spec file doesn't exist?
- [ ] What if user cancels mid-interview?
- [ ] How do partial completions get resumed?

---

## Open Questions

1. **Global vs Project Skills?**
   Should these live in `~/.claude/skills/` (available everywhere) or `.claude/skills/` (per-project)?
   *Recommendation:* Start with project-local, promote to global if proven.

2. **Skill Chaining?**
   Should there be a `/full-workflow` skill that runs 01→02→03→04→06?
   *Recommendation:* Not initially. Keep steps explicit until patterns emerge.

3. **State Tracking?**
   How do we know which step a project is on?
   *Recommendation:* Could add a `/workflow-status` skill that checks for ROADMAP.md, etc.

4. **Version Sync?**
   How to keep wrapper skills in sync with source workflows?
   *Recommendation:* Wrappers are thin enough that drift is minimal. Document this risk.

---

## Decision Matrix

| If you want... | Then... |
|----------------|---------|
| Maximum flexibility, don't mind copy-paste | Keep current markdown-only approach |
| Quick invocation, okay with some maintenance | Hybrid approach (thin wrapper skills) |
| Simplest possible, single source | Convert workflows entirely to skills (not recommended for long prompts) |

---

## Recommendation

**Proceed with the hybrid approach**, starting with a single skill (`/spec-interview`) as proof of concept. This balances:
- Developer experience (quick invocation)
- Maintainability (source of truth in readable markdown)
- Risk (small investment to validate)

If the PoC feels good, roll out the remaining skills incrementally.

---

*Analysis by Claude | January 2026*
