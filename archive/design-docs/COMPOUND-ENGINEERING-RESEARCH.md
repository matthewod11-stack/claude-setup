# Compound Engineering Research

> **Purpose:** Analyze the Compound Engineering Plugin and evaluate how its concepts could enhance the claude-setup workflow system.
> **Sources:**
> - https://github.com/EveryInc/compound-engineering-plugin (official)
> - https://github.com/kieranklaassen/compound-engineering-plugin (fork/mirror)
> - https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents (methodology)

---

## Executive Summary

The Compound Engineering Plugin introduces a **knowledge compounding loop** that captures learnings from each development cycle and feeds them back into future work. The core insight: "Each unit of engineering work should make subsequent units easier—not harder."

**Key takeaways for claude-setup:**
1. Add a **`/compound`** step to capture learnings after execution
2. Introduce **multi-agent review** patterns for the `/spec-review` step
3. Create a **solutions library** for documented problem resolutions
4. Consider **parallel agent execution** for research phases

---

## Origin & Real-World Validation

### Every.to — The Source

The Compound Engineering Plugin originates from **Every.to** (EveryInc), a media/software company that runs five production products, each primarily built and maintained by a single person using this methodology. These aren't demos — they serve thousands of users daily.

**Repository relationship:**
- `EveryInc/compound-engineering-plugin` — Official source
- `kieranklaassen/compound-engineering-plugin` — Fork/mirror (Kieran Klaassen appears to be a contributor)

### Production-Proven Scale

| Metric | Value |
|--------|-------|
| **Products in production** | 5 |
| **Team size per product** | ~1 person |
| **Daily active users** | Thousands |
| **Specialized agents** | 27 |
| **Slash commands** | 20 |
| **Skills** | 14 |

The single-person-per-product model only works because:
1. Knowledge compounds — each solved problem accelerates future work
2. AI agents handle the cognitive load that would require teams
3. Systematic processes replace heroic individual effort

---

## The Compound Engineering Model

### Core Philosophy

> "80% planning and review, 20% execution"

This inverts traditional software development where most time is spent coding. The compound model argues that thorough planning and post-execution capture yields exponentially better outcomes over time.

### The Four-Step Loop

```
Plan → Work → Review → Compound → (repeat)
```

Alternative framing from CLAUDE.md: **Plan → Delegate → Assess → Codify**

| Step | Command | Purpose | Time Allocation |
|------|---------|---------|-----------------|
| Plan | `/workflows:plan` | Convert ideas into detailed implementation plans | 40% |
| Work | `/workflows:work` | Execute plans using structured task loops | 20% |
| Review | `/workflows:review` | Multi-agent code review before merge | 20% |
| Compound | `/workflows:compound` | Document learnings for future reference | 20% |

### Core Principles (from Every.to)

1. **Prefer duplication over wrong abstraction** — Simple, clear code beats complex abstractions
2. **Document as you go** — Every command generates documentation
3. **Quality compounds** — High-quality code is easier to modify
4. **Systematic beats heroic** — Consistent processes beat individual heroics
5. **Knowledge should be codified** — Learnings must be captured and reused

### What Makes It "Compound"

The `/workflows:compound` command is the differentiator. After solving a problem, it:
1. Extracts the problem symptoms and error messages
2. Documents investigation steps (including failed approaches)
3. Captures the root cause and working solution
4. Generates prevention strategies
5. Stores everything in a searchable `docs/solutions/` library

**Result:** First-time problem resolution (30 min) → Documentation (5 min) → Future similar issues (minutes).

---

## Detailed Feature Analysis

### 1. `/workflows:plan` — Research-First Planning

**How it works:**
- Runs 3 parallel research agents simultaneously:
  - `repo-research-analyst` — examines codebase patterns
  - `best-practices-researcher` — identifies industry standards
  - `framework-docs-researcher` — gathers framework-specific guidance
- Results must include specific file paths (e.g., `app/services/example_service.rb:42`)
- Produces plans with 3 detail levels: MINIMAL, MORE, A LOT

**Key instruction:** "NEVER CODE! Just research and write the plan."

**Comparison to claude-setup:**
| claude-setup | Compound Engineering |
|--------------|---------------------|
| `/spec-interview` focuses on user Q&A | Adds automated codebase research |
| Single-threaded planning | Parallel agent research |
| Output is refined spec | Output is actionable plan with file references |

### 2. `/workflows:work` — Structured Execution

**Four-phase model:**
1. **Quick Start:** Read plan, clarify ambiguities, set up environment
2. **Execute:** Task loop with continuous testing
3. **Quality Check:** Full test suite, optional reviewer agents
4. **Ship It:** Conventional commits, PR creation with screenshots

**Key practices:**
- Reference similar code patterns before implementing
- Test continuously (not at end)
- Mark checkboxes in plan file as tasks complete

**Comparison to claude-setup:**
| claude-setup | Compound Engineering |
|--------------|---------------------|
| `07-EXEC-RalphLoop.md` autonomous execution | Similar task loop structure |
| ROADMAP.md tracking | Plan file checkbox marking |
| Session management (`/checkpoint`) | Worktree-based isolation |

### 3. `/workflows:review` — Multi-Agent Assessment

**Parallel reviewer agents:**
- Domain experts (Rails, Python, TypeScript specialists)
- Cross-cutting concerns (security, performance, architecture)
- Data-specific (migration expert, data integrity guardian)

**Severity classification:**
- **P1 (Critical):** Security, data corruption, breaking changes
- **P2 (Important):** Performance, architecture, reliability
- **P3 (Nice-to-Have):** Code cleanup, documentation

**Ultra-thinking analysis:**
- Multiple stakeholder perspectives (developer, ops, end-user, security, business)
- Edge case and boundary condition exploration

**Comparison to claude-setup:**
| claude-setup | Compound Engineering |
|--------------|---------------------|
| `02-PLAN-SpecReview.md` multi-AI | Multi-agent with specialized personas |
| Generic review prompts | Domain-specific reviewer expertise |
| Manual severity assessment | Structured P1/P2/P3 classification |

### 4. `/workflows:compound` — Knowledge Capture

**Seven parallel subagents:**
1. Context Analyzer — extracts problem type, symptoms
2. Solution Extractor — identifies root cause, working code
3. Related Docs Finder — searches existing solutions
4. Prevention Strategist — generates best practices, test cases
5. Category Classifier — determines documentation category
6. Documentation Writer — creates markdown file
7. Specialized Agent — triggers domain expert post-documentation

**Output structure:**
```
docs/solutions/
├── build-errors/
├── test-failures/
├── runtime-errors/
├── performance-issues/
├── database-issues/
├── security-issues/
├── ui-bugs/
├── integration-issues/
└── logic-errors/
```

**This is the missing piece in claude-setup.** Currently, learnings are lost between sessions.

---

## Gap Analysis: claude-setup vs Compound Engineering

### What claude-setup Does Well

| Strength | Evidence |
|----------|----------|
| **Clear workflow tiers** | Lite vs Full decision tree |
| **Session continuity** | `/session-start`, `/checkpoint`, `/session-end` |
| **Spec-first approach** | Steps 01-03 focus on refinement before execution |
| **Parallel execution support** | `parallel-build.md` reference doc |

### What's Missing

| Gap | Impact | Compound Solution |
|-----|--------|-------------------|
| **No knowledge capture** | Learnings lost between sessions | `/workflows:compound` |
| **No specialized reviewers** | Generic AI review | Domain-specific agents |
| **No automated research** | Manual codebase exploration | Parallel research agents |
| **No solution library** | Repeat problem-solving | `docs/solutions/` structure |
| **No severity classification** | All feedback treated equally | P1/P2/P3 system |

---

## Proposed Enhancements

### Enhancement 1: Add `/compound` Skill

**Purpose:** Capture learnings after completing work.

**Triggers:**
- After fixing a non-trivial bug
- After implementing a feature with unexpected complexity
- After discovering a useful pattern
- When `/session-end` detects significant work completed

**Output:** Creates `solutions/[category]/[slug].md` with:
- Problem symptoms
- Investigation steps (including failures)
- Root cause
- Working solution with code
- Prevention strategies

**Implementation:**
```yaml
---
name: compound
description: Document what you just learned to speed up future work
arguments:
  - name: category
    required: false
    description: Category (auto-detected if not provided)
---
Follow the workflow defined in @reference/compound-protocol.md

Analyze the current session to extract:
1. What problem was solved?
2. What approaches failed?
3. What was the root cause?
4. What is the working solution?
5. How can this be prevented?

Output to: solutions/$ARGUMENTS.category/[descriptive-slug].md
```

### Enhancement 2: Upgrade `/spec-review` with Specialized Agents

**Current:** Generic multi-AI review
**Proposed:** Add persona-based reviewers

**Example reviewers:**
- `security-reviewer` — OWASP top 10, auth patterns
- `performance-reviewer` — N+1 queries, caching, async
- `architecture-reviewer` — separation of concerns, SOLID
- `dx-reviewer` — developer experience, API ergonomics

**Implementation:** Modify `02-PLAN-SpecReview.md` to spawn parallel Task agents with specific personas.

### Enhancement 3: Add Research Phase to Planning

**Current:** `/spec-interview` relies on user answers
**Proposed:** Add automated codebase research before/during interview

**Research agents:**
- Scan for existing patterns (How do we handle X elsewhere?)
- Check for similar previous implementations
- Identify relevant framework conventions

**Implementation:** Add research step to `01-PLAN-SpecInterview.md`:
```
Before asking questions, research:
1. Similar features in codebase (Grep for related terms)
2. Existing patterns for the domain (auth, API, database)
3. Framework conventions from CLAUDE.md
```

### Enhancement 4: Create Solutions Library Structure

**Add to repository:**
```
solutions/
├── README.md (index, search tips)
├── build-errors/
├── test-failures/
├── runtime-errors/
├── performance-issues/
├── database-issues/
├── integration-issues/
└── patterns/
    ├── auth-patterns.md
    ├── error-handling.md
    └── api-design.md
```

**Update `/session-start`:** Search solutions library for relevant prior learnings.

### Enhancement 5: Severity Classification in Reviews

**Add to review outputs:**

| Severity | Criteria | Action |
|----------|----------|--------|
| **P1** | Security, data loss, breaking | Block merge |
| **P2** | Performance, architecture | Should fix |
| **P3** | Style, minor improvements | Nice to have |

---

## Implementation Roadmap

### Phase 1: Solutions Library (Low effort, high value)
1. Create `solutions/` directory structure
2. Add `solutions/README.md` with templates
3. Document 2-3 existing learnings as examples
4. Update `/session-start` to search solutions

### Phase 2: Compound Skill (Medium effort)
1. Create `reference/compound-protocol.md`
2. Create `.claude/commands/compound.md` thin wrapper
3. Test with real bug fix session
4. Integrate with `/session-end` as optional step

### Phase 3: Research-Enhanced Planning (Medium effort)
1. Add research phase to `01-PLAN-SpecInterview.md`
2. Create research prompts for common domains
3. Test parallel research with Task tool
4. Document research patterns

### Phase 4: Specialized Reviewers (Higher effort)
1. Define reviewer personas in `reference/reviewer-personas/`
2. Update `02-PLAN-SpecReview.md` to use personas
3. Add severity classification output
4. Test with real spec review

---

## Key Differences in Philosophy

| Aspect | claude-setup | Compound Engineering |
|--------|--------------|---------------------|
| **Focus** | Workflow structure | Knowledge accumulation |
| **Session model** | Start/checkpoint/end | Plan/work/review/compound |
| **Learning capture** | PROGRESS.md notes | Structured solution library |
| **Review approach** | Multi-AI generic | Multi-agent specialized |
| **Research** | Manual exploration | Automated parallel agents |
| **Documentation** | What happened | Why it happened + prevention |

---

## Recommendation

**Adopt the compound loop concept while preserving claude-setup's workflow structure.**

The strongest addition from Compound Engineering is the **explicit knowledge capture step**. Currently, claude-setup has excellent session management but learnings evaporate. Adding a `/compound` skill that runs after significant work would:

1. Build a searchable solution library
2. Reduce time to solve recurring problems
3. Create project-specific documentation automatically
4. Enable `/session-start` to surface relevant prior learnings

**Start with Phase 1** (solutions library) — it's the highest ROI change with lowest implementation cost. This creates the infrastructure for the compound skill before building it.

---

## Questions to Consider

1. **Where should solutions live?**
   - Project-local (`solutions/`) vs global (`~/.claude/solutions/`)
   - Recommendation: Start project-local, consider global for universal patterns

2. **How to trigger compound capture?**
   - Manual (`/compound`)
   - Prompted at `/session-end`
   - Automatic on certain conditions (e.g., bug fix commits)

3. **What granularity for solutions?**
   - Per-issue (detailed, searchable)
   - Per-pattern (higher-level, reusable)
   - Recommendation: Both, in different directories

4. **Integration with existing session management?**
   - `/session-end` could prompt: "Document what you learned?"
   - `/session-start` could surface relevant solutions

5. **Should we adopt the plugin directly?**
   - Install via `/plugin marketplace add https://github.com/EveryInc/compound-engineering-plugin`
   - Or extract concepts into claude-setup's existing structure
   - Recommendation: Extract concepts first, evaluate plugin later

---

## Technical Details: The Plugin

### Installation

```bash
# Add marketplace
/plugin marketplace add https://github.com/EveryInc/compound-engineering-plugin

# Install plugin
/plugin install compound-engineering
```

### MCP Server Integration

The plugin includes two MCP servers requiring manual configuration in `.claude/settings.json`:

```json
{
  "mcpServers": {
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp"
    },
    "playwright": {
      "command": "npx",
      "args": ["@anthropic/mcp-playwright"]
    }
  }
}
```

**Context7** provides framework documentation lookup across 100+ frameworks (Rails, React, Next.js, Vue, Django, Laravel, etc.).

### Component Inventory

| Category | Count | Examples |
|----------|-------|----------|
| **Agents** | 27 | Rails/Python/TS reviewers, security sentinel, architecture strategist |
| **Commands** | 20 | workflows:plan/work/review/compound, test-browser, release-docs |
| **Skills** | 14 | Architecture design, Rails/DSPy.rb patterns, S3/R2 file transfer |
| **MCP Servers** | 2 | Context7 (docs), Playwright (browser automation) |

### Agent Categories

- **Review (14):** Domain experts + cross-cutting concerns
- **Research (4):** Framework docs, git history, best practices
- **Design (3):** UI implementation, design iteration
- **Workflow (5):** Bug validation, PR resolution, spec analysis
- **Documentation (1):** README generation

---

## Further Reading

- [Compound Engineering: How Every Codes With Agents](https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents) — Original methodology article
- [EveryInc/compound-engineering-plugin](https://github.com/EveryInc/compound-engineering-plugin) — Official repository
- [Plugin Documentation](https://github.com/EveryInc/compound-engineering-plugin/tree/main/docs) — Detailed component reference

---

*Research completed: January 2026*
*Sources: github.com/EveryInc/compound-engineering-plugin, every.to*
