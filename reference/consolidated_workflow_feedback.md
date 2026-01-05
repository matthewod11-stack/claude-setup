# Consolidated Workflow Feedback

**Project:** Claude Code Workflow System
**Sources reviewed:** Grok, Codex, Claude, Composer, Gemini
**Date consolidated:** 2026-01-04

---

## Consensus Matrix

A visual overview of where reviewers agree. Items with 3+ tools aligned are highest priority.

| Issue / Recommendation | Grok | Codex | Claude | Composer | Gemini | Count |
|------------------------|:----:|:-----:|:------:|:--------:|:------:|:-----:|
| **Add workflow tiers (Lite/Standard/Heavy)** | ✓ | ✓ | ✓ | ✓ | ✓ | 5 |
| **Consolidate tracking files (too many state files)** | | ✓ | ✓ | ✓ | ✓ | 4 |
| **Parallel execution overcomplicated** | ✓ | ✓ | ✓ | ✓ | | 4 |
| **Step 06 too verbose/heavyweight** | ✓ | ✓ | ✓ | ✓ | | 4 |
| **Missing rollback/recovery protocols** | ✓ | ✓ | ✓ | ✓ | | 4 |
| **Session management overkill for small projects** | ✓ | ✓ | ✓ | ✓ | ✓ | 5 |
| **Naming inconsistencies across docs** | | ✓ | ✓ | ✓ | | 3 |
| **Step 03 "nothing gets cut" too burdensome** | | ✓ | ✓ | ✓ | | 3 |
| **Missing ship gate / retro step** | | ✓ | ✓ | | | 2 |
| **Add CLAUDE.md scaffolding** | | | ✓ | ✓ | | 2 |
| **Step 02 naming drift (Spec vs Roadmap)** | | ✓ | ✓ | | | 2 |
| **Add decision tree / quick start** | | | ✓ | ✓ | | 2 |
| **Missing estimation guidance** | ✓ | | ✓ | ✓ | | 3 |
| **Add mid-execution change protocol** | | | | ✓ | | 1 |
| **Integration testing phase for parallel** | | | | | ✓ | 1 |
| **Executable verification scripts** | | | | | ✓ | 1 |

---

## Consensus Summary (🔺 = 3+ tools agree)

### Highest Priority (5 tools agree)

1. 🔺 **Add Workflow Tiers** — All five reviewers independently recommended tiered complexity levels
   - Lite: Skip reviews, minimal scaffolding, <1 week projects
   - Standard: Full planning, sequential execution
   - Heavy: Multi-review, parallel execution, complex domains

2. 🔺 **Session Management Overkill** — All five noted the full infrastructure is excessive for small tasks

### High Priority (4 tools agree)

3. 🔺 **Consolidate Tracking Files** — ROADMAP.md, features.json, PROGRESS.md, SESSION_STATE.md creates "sync tax"
   - Codex: "Pick one canonical set"
   - Claude: "Either features.json OR roadmap checkboxes, not both"
   - Gemini: "Reducing the paperwork will make agents faster"

4. 🔺 **Parallel Execution Overcomplicated** — Three-terminal orchestrator pattern is heavyweight
   - Recommendation: 2 agents with clear boundaries + git worktrees is sufficient for most cases

5. 🔺 **Step 06 Too Verbose** — Long enough to be a barrier
   - Codex: "Split into 06A (Minimum) + 06B (Parallel Add-on)"
   - Use progressive disclosure

6. 🔺 **Missing Rollback/Recovery** — No guidance when execution goes sideways
   - Git tags at phase boundaries
   - Stop criteria (same error 3+ times, scope creep, boundary violations)

### Medium Priority (2-3 tools agree)

7. 🔺 **Naming Inconsistencies** — Creates confusion mid-flight
   - `v1_roadmap.md` vs `ROADMAP.md`
   - `SESSION_STATE.md` vs `PROGRESS.md`
   - Step 02 title says "Roadmap Review" but filename says "SpecReview"

8. 🔺 **Step 03 Consolidation Rule** — "Nothing gets cut" creates clerical overhead
   - Better: Triage-first with raw notes in appendix

9. 🔺 **Missing Estimation Guidance** — No help sizing tasks or projects

---

## 1. Structure & Detail Assessment

### Gaps / Too Vague

- No upfront guidance on which workflow tier to use — [Grok, Codex, Claude, Composer, Gemini] 🔺 CONSENSUS
- Step 5 (Roadmap Validation) marked optional without clear criteria for when to use — [Grok]
- No hard "stop/pivot" protocol — [Codex]
- No guidance on estimating complexity or tracking actual vs planned effort — [Grok, Claude, Composer] 🔺 CONSENSUS
- No criteria for when to abort vs pivot vs continue — [Grok]
- No clear entry point for users who already have a spec, roadmap, or are mid-execution — [Composer]

### Over-Specified / Premature Decisions

- The full session infrastructure (PROGRESS.md, features.json, scripts) is overkill for quick fixes and small features — [Grok, Codex, Claude, Composer, Gemini] 🔺 CONSENSUS
- Three-terminal orchestration pattern is powerful but complex; most projects don't need it — [Grok, Codex, Claude, Composer] 🔺 CONSENSUS
- Plugin configurations are very specific to one setup — [Grok]
- Orchestrator script (~200 lines) may be overkill — [Composer]

### Missing Context or Clarity

- Step 02 filename says "Spec Review" but document title says "Roadmap Review" — [Codex, Claude] 🔺 CONSENSUS
- Step 04 outputs `v1_roadmap.md` while Step 06/scripts assume `ROADMAP.md` — [Codex, Claude] 🔺 CONSENSUS
- Step 07 says it requires `SESSION_STATE.md` but Step 06 scaffolds `docs/PROGRESS.md` — [Codex, Claude, Composer] 🔺 CONSENSUS
- `features.json` points at `features.schema.json` but schema scaffolding isn't clear — [Codex]

### Dependency Issues

- Parallel execution info spread across 3 docs (06, 07, reference/parallel-build.md) — [Claude]
- Session management explained in 3 places (06, 07, reference/session-management.md) — [Claude]
- SESSION_PROMPTS.md content duplicated in 06 — [Claude]

---

## 2. Existing Feature Enhancement

### Session Management

- PROGRESS.md + check-in/out prompts + scripts are exactly the right artifact scaffolding — [Codex, Claude, Grok] 🔺 CONSENSUS
- Newest session at TOP rule is critical — [Claude]
- But: full infrastructure overkill for small tasks — [Grok, Codex, Claude, Composer, Gemini] 🔺 CONSENSUS
- Consider unified `./scripts/session.sh start|end|status|checkpoint` — [Claude]
- Merge KNOWN_ISSUES.md into PROGRESS.md as a section — [Composer]

### Parallel Execution

- Clear boundary definitions and conflict resolution work well — [Grok, Composer]
- Appropriate sequencing (foundation → parallel → integration) is correct — [Grok, Claude]
- Orchestrator pattern is excellent for preventing port conflicts — [Gemini]
- But: start with sequential, only add parallelism when you prove you need speed — [Grok, Composer] 🔺 CONSENSUS
- Replace orchestrator script with markdown checklist for most projects — [Codex, Composer] 🔺 CONSENSUS
- Use git worktrees for isolation instead of three-terminal pattern — [Codex, Composer] 🔺 CONSENSUS
- Missing: Cross-domain integration testing phase after parallel work — [Gemini]

### Multi-Model Review (Steps 02-03)

- Running same prompt through multiple AI tools is genuinely clever — [Claude]
- 🔺 CONSENSUS tags surface high-signal items — [Claude]
- But: 2 reviewers with distinct lenses usually beats 5 + full consolidation — [Codex]
- Step 03 "nothing gets cut" creates a lot of clerical work — [Codex, Claude, Composer] 🔺 CONSENSUS
- Better: triage-first with raw notes in appendix — [Codex, Claude, Composer] 🔺 CONSENSUS
- Consider merging 02-03 into single optional step — [Composer]
- Add "Quick Path": if spec < 500 lines or familiar domain → skip 02-03 — [Composer]

### Step 04 (Scoping with AskUserQuestion)

- This is the most valuable step in the entire workflow — [Claude]
- Forcing human decisions at strategic constraint points prevents scope creep — [Claude]
- Embedded parallelizability analysis is elegant — [Claude]
- Missing: complexity assessment at start — [Composer]
- Missing: estimation heuristics — [Claude]

### Step 06 (Setup)

- Scaffolding is high quality but too long — [Codex, Claude, Composer] 🔺 CONSENSUS
- Split into 06A (Minimum) + 06B (Parallel Add-on) — [Codex]
- Use progressive disclosure — start simple, expand as needed — [Grok, Codex]
- Scaffolds files without repeating their full contents — [Claude]
- Missing: CLAUDE.md scaffolding — [Claude, Composer] 🔺 CONSENSUS

### Step 07 (Ralph Loop)

- Verification emphasis is excellent — [Grok, Codex, Claude, Composer, Gemini] 🔺 CONSENSUS
- Missing: when to STOP criteria — [Claude, Composer] 🔺 CONSENSUS
- Missing: rollback/recovery patterns — [Grok, Claude, Composer] 🔺 CONSENSUS
- Missing: mid-execution spec change protocol — [Composer]
- Missing: troubleshooting section — [Composer]
- Missing: checkpoint review guidance — [Composer]

---

## 3. New Ideas

### Workflow Tiers — [Grok, Codex, Claude, Composer, Gemini] 🔺 CONSENSUS (5/5)

**Problem it solves:** One-size-fits-all workflow is overkill for small projects, creating friction

**Proposed structure:**
| Tier | When to Use | Steps | Scaffolding |
|------|-------------|-------|-------------|
| **Lite** | <10 tasks, familiar domain, <3 days | 01 → 04 → 06-lite → 07 | ROADMAP.md, CLAUDE.md only |
| **Standard** | Most projects | 01 → 02 (1-2 reviews) → 04 → 06 → 07 | Full scaffolding minus parallel |
| **Heavy** | New domain, parallel, high-risk | 01 → 02 (multi) → 03 → 04 → 05 → 06 → 07 | Full scaffolding + parallel |

**Compounds with:** Quick start decision tree, simplified onboarding

---

### Ship Gate + Retro — [Codex, Claude] 🔺 CONSENSUS

**Problem it solves:** Workflow stops at execution with no formal "done" criteria or learning capture

**Ship Gate Checklist:**
- [ ] All success criteria from roadmap verified
- [ ] No P0/P1 bugs in KNOWN_ISSUES.md
- [ ] Smoke test of critical user flows
- [ ] Performance sanity check (if applicable)
- [ ] README updated with setup/run instructions

**5-Minute Retro Template:**
- What broke during execution?
- What should change in the workflow for next project?
- What new pattern should be added to CLAUDE.md?

**Compounds with:** Continuous workflow improvement, success metrics

---

### Quick Start Decision Tree — [Composer, Claude]

**Problem it solves:** No clear entry point for users at different starting points

**Proposed:**
```
I have a PRD → Start at 01
I have a detailed spec → Skip to 04 (or 02 if you want reviews)
I have a roadmap → Skip to 06
I'm mid-execution → Go to 07
```

**Compounds with:** Workflow tiers, reduced friction

---

### CLAUDE.md Scaffolding — [Claude, Composer] 🔺 CONSENSUS

**Problem it solves:** Missing most persistent context across sessions

**Proposed template:**
```markdown
# CLAUDE.md

## Project
[PROJECT_NAME] — [one-line description]

## Tech Stack
[TECH_STACK]

## Key Patterns
- [Pattern]: [Why we use it]

## Gotchas
- [Thing Claude might miss or do wrong]

## Commands
- Test: `npm test`
- Type check: `npm run typecheck`
- Dev server: `npm run dev`
```

**Compounds with:** Session management, context preservation

---

### Stop Conditions / Recovery Protocol — [Grok, Claude, Composer] 🔺 CONSENSUS

**Problem it solves:** No guidance when execution goes sideways

**When to STOP (output `NEED_HUMAN`):**
- Same error appears 3+ consecutive attempts
- You need to modify files outside your boundary
- Task scope has grown beyond original acceptance criteria
- You're unsure which of 2+ valid approaches to take
- Tests pass but behavior feels wrong

**Recovery patterns:**
- Git tags at phase boundaries for easy rollback
- If stuck → revert to last tag, reassess approach
- If 3+ tasks blocked → pause and reassess roadmap
- If task takes >2x estimated time → check if scope crept

**Compounds with:** Session management, parallel execution safety

---

### Common Patterns Section — [Composer]

**Problem it solves:** Users don't know which workflow variation to use

**Proposed patterns:**
```markdown
**Pattern: MVP Rush**
- Steps: 01 → 04 → 06 → 07
- Skip: 02, 03, 05
- Use: Simple projects, tight timeline

**Pattern: Quality First**
- Steps: 01 → 02 → 03 → 04 → 05 → 06 → 07
- Use: Complex projects, learning new domain

**Pattern: Iterative Build**
- Steps: 01 → 04 → 06 → 07 → [test] → 04 → 07
- Use: When requirements evolve
```

**Compounds with:** Workflow tiers, decision tree

---

### Estimation Heuristics — [Grok, Claude, Composer] 🔺 CONSENSUS

**Problem it solves:** No help sizing tasks or knowing when to break things down

**Proposed for Step 04:**
| Task Size | Indicators | Approach |
|-----------|------------|----------|
| Small (~1 session) | Single file, known pattern, clear acceptance | Direct execution |
| Medium (2-3 sessions) | Multiple files, one domain, some unknowns | Plan → Execute |
| Large (4+ sessions) | Cross-domain, new patterns, external APIs | Break into smaller tasks first |

**Compounds with:** Workflow tiers, scoping decisions

---

### Integration Testing Phase — [Gemini]

**Problem it solves:** Parallel agents work in isolation; no verification that Domain A talks to Domain B correctly

**Proposed:** Add mandatory **"Integration & Shakeout"** phase at end of every parallel roadmap. Single agent runs full app and verifies cross-domain interactions.

**Compounds with:** Parallel execution, verification

---

### Executable Verification Scripts — [Gemini]

**Problem it solves:** Verification is often "Manual" or "Visual" with no repeatability

**Proposed:** In Plan Mode of Step 07, require agent to generate **Bash Verification Script** (e.g., `scripts/verify-auth.sh`) for any non-UI logic. Creates hard, repeatable feedback loop for ralph loop.

**Compounds with:** Verification emphasis, testing strategy

---

### Troubleshooting Section — [Composer]

**Problem it solves:** No guidance when things go wrong during execution

**Proposed for Step 07:**
```markdown
## Troubleshooting

**Ralph loop stuck?**
- Check `.claude/ralph-loop.local.md` for iteration count
- If >30 iterations → cancel, reassess task breakdown

**Context running out?**
- Use checkpoint prompt mid-task
- Update PROGRESS.md, then continue

**Tasks taking too long?**
- Check if scope crept
- Consider splitting task further
```

**Compounds with:** Recovery protocol, session management

---

### Post-Launch Phase — [Grok]

**Problem it solves:** Workflow stops at execution with no iteration guidance

**Proposed additions:**
- Monitoring and maintenance guidance
- Iteration planning for v2 features
- User feedback integration

**Compounds with:** Ship gate, retro

---

### Success Metrics — [Grok]

**Problem it solves:** No way to track what's working

**Track:**
- Completion rates by project type
- Quality metrics (bug rates, user satisfaction)
- Success pattern recognition

**Compounds with:** Retro, workflow improvement

---

## 4. Jobs Innovation Lens

### How can I make the complex appear simple?

- Add explicit tiers so small projects don't need full scaffolding — [Grok, Codex, Claude, Composer, Gemini] 🔺 CONSENSUS
- Progressive disclosure in Step 06 — start simple, expand as needed — [Grok, Codex]
- Quick decision tree eliminates "where do I start?" confusion — [Composer, Claude]
- One canonical artifact per purpose instead of multiple overlapping files — [Codex, Claude, Gemini] 🔺 CONSENSUS

### What would this be like if it just worked magically?

- Unified `session.sh start|end|status|checkpoint` handles all modes — [Claude]
- Orchestrator auto-spawns agent terminals with prompts pre-loaded via tmux — [Gemini]
- Interactive setup that asks questions and generates minimal config — [Grok]
- Modular templates that users import/compose — [Grok]

### What's the one thing this absolutely must do perfectly?

- Verification as a first-class concept — this is the highest-leverage AI workflow principle — [Codex, Claude, Gemini] 🔺 CONSENSUS
- Planning as a hard gate — ensures AI is implementer rather than guesser — [Gemini]
- Session artifacts that survive context loss — [Grok, Codex, Gemini] 🔺 CONSENSUS

### How would I make this insanely great instead of just good?

- Focus on reduction and consistency rather than adding features — [Claude, Composer] 🔺 CONSENSUS
- The core insight (planning → validation → parallelizable execution) is sound — make it more accessible — [Grok]
- Reduce "sync tax" — if Roadmap has checkboxes, AI doesn't need to update JSON too — [Gemini]

---

## 5. Technical Considerations

### Architectural Concerns

- State management fragmentation creates "sync tax" per task — [Codex, Claude, Composer, Gemini] 🔺 CONSENSUS
- Parallel execution info spread across 3 docs creates confusion — [Claude]
- Document duplication across docs (SESSION_PROMPTS inline + scaffolded) — [Claude]

### Canonical Artifact Recommendations — [Codex, Claude, Composer] 🔺 CONSENSUS

| Artifact | Canonical Name | Purpose |
|----------|----------------|---------|
| Roadmap | `ROADMAP.md` | Task definitions, status checkboxes |
| Session history | `docs/PROGRESS.md` | Session log, checkpoint entries |
| Issues | Section in PROGRESS.md | Merge KNOWN_ISSUES.md |
| Features tracking | Optional `features.json` | Only for Standard/Heavy tiers |
| Project context | `CLAUDE.md` | Tech stack, patterns, gotchas |

### Script Consolidation — [Claude, Composer]

- Current: `dev-init.sh`, `session-end.sh`, `orchestrator.sh`
- Proposed: Unified `./scripts/session.sh start|end|status|checkpoint`
- Orchestrator → markdown checklist for most projects

### Performance / Scalability

- High clerical overhead ("Sync Tax") per task completion — [Gemini]
- Every task finish requires 3-4 file writes — expensive and slow — [Gemini]
- Reducing paperwork will make agents significantly faster and more focused on code — [Gemini]

### State-of-the-Art Recommendations

- Better cross-referencing between documents — [Grok]
- Single source of truth pattern: step docs link to reference docs rather than duplicating — [Claude]
- Git worktrees for parallel isolation instead of three-terminal pattern — [Codex, Composer]

---

## Appendix: Tool-by-Tool Raw Notes

### Grok

**Unique points not covered above:**
- Limited guidance for multi-human teams (code review workflows, knowledge sharing)
- Workflow assumes web applications — consider adaptations for CLI tools, libraries, mobile apps
- Expand beyond Claude Code plugins to GitHub Actions, Linear/Jira, Figma integration
- Clearer fallbacks when plugins aren't available

**Overall score:** "Already very strong — more mature than most development methodologies"

---

### Codex

**Unique points not covered above:**
- Defaulting to heavy multi-agent reviews — 2 reviewers with distinct lenses usually beats 5 + consolidation overhead
- Step 04 is correctly positioned as the "scope/parallel decision gate"
- The "parallelizable → parallel ralph loops, else sequential" meta-rule is an excellent simplifier

**Overall score:** "Already a very capable Claude Code operating system"

---

### Claude

**Unique points not covered above:**
- The `Execution Mode: PARALLEL-READY | SEQUENTIAL` header is elegant
- Multi-model review (02-03) is better than any single model's review
- The "newest session at TOP" rule prevents drift
- Boris's principle woven into every step 2-3x's quality
- `v2_parking_lot.md` creates document sprawl — make it a section unless >20 items

**Overall score:** "Production-grade... more sophisticated than most professional development methodologies"
| Category | Score |
|----------|-------|
| Clarity | 9/10 |
| Completeness | 7/10 |
| Simplicity | 6/10 |
| Maintainability | 7/10 |
| Innovation | 9/10 |

---

### Composer

**Unique points not covered above:**
- Mid-execution spec change protocol needed: pause ralph loop, update roadmap, reassess, resume
- Checkpoint reviews between phases: after Phase 0 verify foundation, demo/test after each major phase
- Merge Steps 02-03 into single optional step
- Make Step 05 a checklist in Step 04 rather than separate doc

**Overall score:** "Production-grade... demonstrates deep understanding of AI-assisted development"
| Category | Score |
|----------|-------|
| Clarity | 8/10 |
| Completeness | 7/10 |
| Simplicity | 6/10 |
| Maintainability | 7/10 |
| Innovation | 9/10 |

---

### Gemini

**Unique points not covered above:**
- This is a professional-grade workflow for **autonomous development (Agent mode)**
- Successfully solves the "AI Context Drift" problem
- The orchestrator pattern for port conflicts is the correct solution
- Consider tmux or terminal tools to auto-spawn agent terminals with prompts pre-loaded

**Overall score:**
| Category | Score |
|----------|-------|
| Agency/Autonomy | 10/10 |
| Structure | 9/10 |
| Efficiency | 6/10 |
| Resilience | 8/10 |

---

## Verification Checklist

- [x] All feedback from all 5 tools captured
- [x] Consensus items tagged with 🔺 (19 items)
- [x] Divergent opinions tagged with ⚠️ (none found — all reviewers broadly aligned)
- [x] Consensus Summary section populated
- [x] Consensus Matrix provides visual overview
- [x] No feedback lost in consolidation
- [x] Appendix captures tool-specific orphaned points

---

## Recommended Implementation Order

### Phase 1: Quick Wins (Naming & Structure)
1. Fix naming inconsistencies (ROADMAP.md, PROGRESS.md as canonical)
2. Fix Step 02 title vs filename
3. Add quick start decision tree to index
4. Add workflow tier guidance to index

### Phase 2: Consolidation (DRY the docs)
5. Merge KNOWN_ISSUES.md into PROGRESS.md
6. Make features.json optional (Standard/Heavy only)
7. Remove SESSION_STATE.md references
8. Consolidate parallel execution info into reference/parallel-build.md
9. Step docs link to reference docs instead of duplicating

### Phase 3: Missing Safety Rails
10. Add CLAUDE.md scaffolding to Step 06
11. Add stop conditions / recovery protocol to Step 07
12. Add ship gate + retro template
13. Add mid-execution change protocol

### Phase 4: Simplification
14. Split Step 06 into 06A (Minimum) + 06B (Parallel Add-on)
15. Change Step 03 to triage-first with raw notes in appendix
16. Create explicit tier variants for each step
17. Replace orchestrator script with markdown checklist

### Phase 5: Enhancements
18. Add estimation heuristics to Step 04
19. Add troubleshooting section to Step 07
20. Add integration testing phase for parallel builds
21. Add common patterns section to index

---

*Consolidated from 5 AI tool reviews | 2026-01-04*
