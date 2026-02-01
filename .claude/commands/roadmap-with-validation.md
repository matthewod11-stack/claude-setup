---
description: Interactive scoping → roadmap generation → multi-agent validation → consolidated updates
---

# Roadmap with Validation Orchestrator

Automates Steps 04-05: Interactive scoping with AskUserQuestion, roadmap generation, parallel validation agents, and auto-updates.

---

## Step 1: Validate Inputs

Check that required files exist:

```bash
ls -la SPEC.md consolidated_feedback.md 2>/dev/null
```

If files missing, use AskUserQuestion:

**Question:** "Which files should I use?"

**Options:**
1. **SPEC.md + consolidated_feedback.md** — Standard locations
2. **docs/SPEC.md + consolidated_feedback.md** — Docs folder
3. **Other** — I'll specify paths

---

## Step 2: Extract Project Variables

Read spec file and extract:
- `[PROJECT_NAME]` — From title or first heading
- `[PROJECT_DESCRIPTION]` — From overview section
- `[V1_SUCCESS_CRITERIA]` — From goals/success criteria section
- `[TECH_STACK]` — From technical requirements
- `[TARGET_USER]` — From user/audience section

If any variables are unclear, ask user to confirm.

---

## Phase 1: Interactive Scoping

Use AskUserQuestion to establish strategic constraints. Questions should be derived from the actual spec and feedback.

### Question Batch 1: Success Criteria & Scope

**Question 1:** "Based on the spec, your v1 goal is: `[V1_SUCCESS_CRITERIA]`. Is this still correct?"

**Options:**
1. **Yes, as stated** — Proceed with current criteria
2. **Modified** — Feedback suggests adjustments (describe in chat)
3. **Need to refine** — Let's discuss before continuing

**Question 2:** "What quality bar for v1?"

**Options:**
1. **Functional only** — Works, but rough edges acceptable
2. **Polished (Recommended)** — Good UX, handles edge cases
3. **Production-ready** — Full error handling, logging, monitoring

**Question 3:** "Any timeline constraints?"

**Options:**
1. **No rush** — Quality over speed
2. **2-4 weeks target** — Reasonable pace
3. **ASAP** — Minimize scope, ship fast

### Question Batch 2: Feature Prioritization

Based on consolidated feedback consensus items, ask:

**Question:** "The feedback flagged these items. Which are non-negotiable for v1?"

**Options:** (Generated from actual feedback 🔺 items)
1. **[Consensus item 1]** — Include in v1
2. **[Consensus item 2]** — Include in v1
3. **Defer all to v2** — Keep v1 minimal
4. **Discuss each** — Let's review one by one

### Save Scoping Decisions

Store decisions in `.claude/roadmap-scoping-state.json`:

```json
{
  "project_name": "[PROJECT_NAME]",
  "success_criteria": "[V1_SUCCESS_CRITERIA]",
  "quality_bar": "polished",
  "timeline": "2-4 weeks",
  "prioritized_features": ["feature1", "feature2"],
  "deferred_features": ["feature3"],
  "scoping_date": "2026-02-01"
}
```

---

## Phase 2: Domain Triage

Walk through each major domain in the spec.

### For Each Domain:

1. **Summarize:** What does the spec propose?
2. **Surface conflicts:** What did feedback say?
3. **Clarify (if needed):** Ask conversationally for ambiguous items
4. **Categorize:** V1 Core, V1 Polish, or V2

### Generate Feature Categorization Table

```markdown
| Feature | Domain | Category | Rationale |
|---------|--------|----------|-----------|
| [Feature 1] | [Domain] | V1 Core | [Why essential] |
| [Feature 2] | [Domain] | V1 Polish | [Why nice-to-have] |
| [Feature 3] | [Domain] | V2 | [Why deferred] |
```

---

## Phase 3: Generate ROADMAP.md

Using scoping decisions and feature categorization:

### 3.1 Dependency Mapping

For each V1 feature:
- **Requires:** What must exist first?
- **Enables:** What does this unblock?
- **Parallel:** Can this be built alongside others?

### 3.2 Parallelizability Analysis

Check criteria:
- [ ] Features belong to distinct domains
- [ ] Each domain has own routes/services/components
- [ ] Domains share contracts but don't modify each other
- [ ] Integration points are well-defined interfaces

**Result:** Mark roadmap as `PARALLEL-READY` or `SEQUENTIAL`

### 3.3 Phase Definition

Group features into phases:
- **Phase 0:** Foundation (scaffolding, types, database)
- **Phase 1-N:** Feature phases (3-7 tasks each)

### 3.4 Task Breakdown

For each V1 feature:
- Scope (what's in/out)
- Acceptance criteria (specific, measurable)
- Verification method (test/manual/visual)

### 3.5 Write ROADMAP.md

Generate complete roadmap file with:
- Strategic constraints section
- Phase overview table
- Detailed phase breakdowns
- Pause points for review
- Out of scope list
- Risks and mitigations

### 3.6 Write v2_parking_lot.md

Generate V2 features file with:
- Features by theme
- Impact/Lift ratings
- Quick reference matrix
- Dependencies on V1

---

## Phase 4: Multi-Agent Validation (Optional)

Use AskUserQuestion:

**Question:** "Run multi-agent validation on the roadmap?"

**Options:**
1. **Yes, full validation (Recommended)** — 4 agents review
2. **Yes, quick validation** — 2 agents review
3. **No, skip validation** — Proceed to setup

### If Validation Selected:

#### 4.1 Generate Validation Prompts

Using template from `05-PLAN-RoadmapValidation.md`:

**For each model, include:**
- Full ROADMAP.md content
- Success criteria
- Review checklist from template
- Model-specific focus

**Filenames:**
- Claude → `claude_validation.md`
- GPT-4 → `gpt4_validation.md`
- Grok → `grok_validation.md`
- Gemini → `gemini_validation.md`

#### 4.2 Spawn Validation Agents

Use Task tool to spawn parallel agents (same pattern as /spec-review-multi).

**Spawn all agents in SINGLE message with multiple Task calls.**

#### 4.3 Monitor Completion

Poll for validation files:
```bash
ls -la *_validation.md 2>/dev/null | wc -l
```

Report progress to user.

#### 4.4 Timeout Handling

- Per-agent: 15 minutes
- Total: 20 minutes
- Proceed with ≥2 reviews if timeout

---

## Phase 5: Consolidate Validation

Once validations complete:

### 5.1 Read All Validation Files

Parse each file for:
- Required changes
- Risks identified
- Key findings

### 5.2 Identify Consensus

Items flagged by 2+ validators:
- Tag with 🔺 CONSENSUS
- High priority for action

### 5.3 Identify Divergence

Items where validators disagree:
- Tag with ⚠️ DIVERGENT
- Note both positions

### 5.4 Generate consolidated_validation.md

```markdown
# Roadmap Validation — [PROJECT_NAME]

**Reviewed:** [DATE]
**Sources:** claude_validation.md, gpt4_validation.md, grok_validation.md, gemini_validation.md
**Verdict:** [APPROVED / APPROVED WITH CHANGES / NEEDS REVISION]

---

## Consensus Summary

🔺 Items flagged by 2+ validators:

1. [Issue] — [Models that flagged it]
2. [Issue] — [Models that flagged it]

---

## Required Changes

### Critical (Must Fix)
- [ ] [Change 1]
- [ ] [Change 2]

### Important (Should Fix)
- [ ] [Change 3]

---

## Risks Identified

| Risk | Severity | Flagged By | Mitigation |
|------|----------|------------|------------|
| | | | |

---

## Divergent Opinions

⚠️ [Topic where validators disagreed]
- [Position A] — [Models]
- [Position B] — [Models]
- **Resolution:** [How to handle]
```

---

## Phase 6: Update Roadmap

Use AskUserQuestion:

**Question:** "Validation found [N] required changes. Apply automatically?"

**Options:**
1. **Yes, apply all** — Update ROADMAP.md automatically
2. **Review first** — Show changes before applying
3. **Apply critical only** — Skip suggestions
4. **No, manual review** — I'll update manually

### If Auto-Update Selected:

#### 6.1 Parse Required Changes

Categorize:
- **Dependency fixes:** Add missing dependencies
- **Task splits:** Break complex tasks
- **Acceptance criteria:** Clarify vague criteria
- **Sequencing:** Reorder phases

#### 6.2 Apply Changes

Update ROADMAP.md with:
- Changes applied
- Validation header added

```markdown
> **Validated:** [DATE]
> **Validation Sources:** claude, gpt4, grok, gemini
> **Status:** APPROVED WITH CHANGES
```

#### 6.3 Generate Changelog

```markdown
## Validation Changes Applied

1. Added Auth dependency to Phase 0
2. Split "Build Dashboard" into 3 subtasks
3. Clarified acceptance criteria for Recipe Import
```

---

## Step 7: Output Summary

```
## Roadmap Generation Complete

**Project:** [PROJECT_NAME]
**Execution Mode:** [PARALLEL-READY | SEQUENTIAL]

### Generated Files
- ✓ ROADMAP.md
- ✓ v2_parking_lot.md
- ✓ consolidated_validation.md (if validation run)

### Scoping Decisions
- Quality Bar: [selection]
- Timeline: [selection]
- V1 Features: [count]
- V2 Features: [count]

### Validation Results
- Consensus Issues: [N]
- Required Changes: [N] applied
- Verdict: [APPROVED / APPROVED WITH CHANGES]

→ Ready for: 06-EXEC-Setup.md or /orchestrate (if parallel)
```

---

## Step 8: Next Step Prompt

Use AskUserQuestion:

**Question:** "Roadmap complete. What next?"

**Options:**
1. **Proceed to execution setup** — Run 06-EXEC-Setup.md
2. **Review roadmap** — Read ROADMAP.md first
3. **Use /plan-master** — Continue with full workflow
4. **End workflow** — Save state and exit

---

## Error Handling

### If spec/feedback files not found:
- Ask user for correct paths
- Offer to create from scratch

### If scoping state lost:
- Re-ask strategic questions
- Or load from `.claude/roadmap-scoping-state.json`

### If validation agents fail:
- Proceed with available reviews (≥2)
- Report which agents timed out
- Offer manual validation option

### If roadmap update fails:
- Show proposed changes
- Allow manual application

---

## Notes

- This skill automates Steps 04-05 of the workflow
- AskUserQuestion ensures user control over strategic decisions
- Validation is optional but recommended for complex projects
- Use `/plan-master` for full workflow orchestration
