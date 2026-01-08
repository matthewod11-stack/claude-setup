# Dynamic Context Discovery: Research Report

**Date:** January 7, 2026
**Source:** [Cursor Blog - Dynamic Context Discovery](https://cursor.com/blog/dynamic-context-discovery)
**Purpose:** Analyze dynamic context discovery techniques and their application to the Claude Code Workflow System

---

## Executive Summary

Dynamic context discovery is a paradigm shift in how AI coding assistants manage context. Rather than loading all available tools, documentation, and context upfront (which bloats the context window), the agent discovers context dynamically as needed during task execution.

Cursor's implementation achieved a **46.9% reduction in total agent tokens** in MCP tool calls. Related approaches from Speakeasy demonstrate up to **160x token reduction** through dynamic toolsets.

This report analyzes these techniques and proposes specific optimizations for this workflow system.

---

## Part 1: Core Concepts from Cursor

### The Problem: Context Window Bloat

Traditional approaches front-load context:
- All MCP tool descriptions in system prompt
- Full codebase documentation
- Complete terminal history
- Every available skill and command

This creates several issues:
1. **Token waste** — Most loaded context goes unused
2. **Context limit pressure** — Less room for actual work
3. **Slower responses** — More tokens to process
4. **Compounding costs** — Multiplies with each MCP server added

### The Solution: Dynamic Discovery

Instead of static injection, provide:
- **Minimal static context** — Names and brief descriptions only
- **Discovery tools** — Methods to look up full details when needed
- **File-based outputs** — Write long outputs to files, read on demand

### Key Techniques

#### 1. MCP Tool Optimization

**Before:** Full tool schemas in every prompt
```
Tool: create_issue
Description: Creates a new GitHub issue with the specified title, body,
labels, assignees, and milestone. Supports markdown formatting in the
body. Returns the issue number and URL on success...
[500+ tokens per tool × 40 tools = 20,000+ tokens]
```

**After:** Minimal static context + dynamic lookup
```
Available tools: create_issue, update_issue, list_issues, ...
[Agent uses search_tools("create github issue") to get full schema when needed]
```

**Result:** 46.9% token reduction in runs that called MCP tools

#### 2. File-Based Output Handling

**Before:** Truncate long command outputs, lose context
**After:** Write output to file, agent reads what it needs

```
# Long output → written to .cursor/outputs/cmd-123.txt
# Agent reads with: tail -100 .cursor/outputs/cmd-123.txt
# Reads more if needed: head -200 .cursor/outputs/cmd-123.txt
```

**Benefit:** Fewer forced summarizations when hitting context limits

#### 3. Skills System

Skills are self-contained capability bundles with:
- Name and brief description (static context)
- Full prompt/instructions (discovered dynamically)
- Associated scripts or executables
- Stored as files, searchable by agent

The agent sees:
```
Available skills: session-start-hook, pdf-reader, code-analyzer...
```

And uses grep/semantic search to pull in relevant skill details only when needed.

#### 4. Terminal Output Syncing

Terminal outputs sync to filesystem → agent can read prior command results without them being injected into every prompt.

---

## Part 2: Related Approaches

### Speakeasy Dynamic Toolsets

[Speakeasy's approach](https://www.speakeasy.com/blog/how-we-reduced-token-usage-by-100x-dynamic-toolsets-v2) achieves even greater reductions:

| Approach | Token Reduction | Trade-off |
|----------|-----------------|-----------|
| Static toolsets | 0% (baseline) | All schemas loaded upfront |
| Progressive search | 96-99% | Hierarchical navigation |
| Semantic search | 96-99% | Natural language discovery |
| Hybrid | Best of both | Combines navigation + NL |

**Three-step protocol:**
1. `search_tools` — Find relevant tools via natural language
2. `describe_tools` — Get full schemas for chosen tools only
3. `execute_tool` — Run with complete parameter info

### Multi-Pronged Context Retrieval

From [Sourcegraph's research](https://sourcegraph.com/blog/lessons-from-building-ai-coding-assistants-context-retrieval-and-evaluation):

| Retrieval Method | Best For |
|------------------|----------|
| **Embedding-based** | Semantic similarity, concept matching |
| **Graph-based** | Dependency tracing, call hierarchies |
| **Local context** | Current file, recent history, cursor position |
| **Hybrid (BM25 + vectors)** | Balanced precision and recall |

### AST-Based Code Chunking

Modern tools parse code into logical units:
- Functions and classes as atomic chunks
- Never cut mid-function
- Preserves semantic meaning
- Enables precise retrieval

---

## Part 3: Application to This Workflow

### Current State Analysis

This workflow system uses **static context injection**:

| Component | Current Approach | Discovery Opportunity |
|-----------|------------------|----------------------|
| Workflow steps (01-07) | User manually navigates | Agent could discover relevant step |
| Session prompts | Scaffolded as full files | Could be discovered when needed |
| Reference docs | User must know to read | Semantic search potential |
| ROADMAP.md | Fully loaded each session | Could load current phase only |
| PROGRESS.md | Full history loaded | Could load recent entries only |

### Optimization Opportunities

#### 1. Workflow Step Discovery

**Current:** User manually selects which workflow step to use
**Proposed:** Agent discovers relevant step based on task

```markdown
# Minimal static context (in CLAUDE.md or system prompt)
Workflow steps available: SpecInterview, SpecReview, FeedbackConsolidation,
ScopingAndRoadmap, RoadmapValidation, Setup, RalphLoop

Use `grep` or read 00-WorkflowIndex.md to find the right step for your task.
```

Agent dynamically reads the appropriate step file when needed.

#### 2. Session Artifact Optimization

**PROGRESS.md:** Instead of loading full history:
```bash
# Load only recent entries
head -50 docs/PROGRESS.md

# Search for specific context
grep -A10 "Next Session Should" docs/PROGRESS.md
```

**ROADMAP.md:** Instead of full roadmap:
```bash
# Find current phase
grep -B2 -A20 "in_progress\|not-started" ROADMAP.md | head -30
```

#### 3. Reference Doc Discovery

Create an index file (`reference/INDEX.md`):
```markdown
# Reference Documentation Index

| Topic | File | Use When |
|-------|------|----------|
| Session continuity | session-management.md | Context running out |
| Multi-agent work | parallel-build.md | >1 agent needed |
| Project setup | setup.md | Starting new project |
| Workflow analysis | the-system-analysis.md | Learning from other systems |
```

Agent searches index, reads only relevant reference doc.

#### 4. Skills-Based Workflow Commands

Convert workflow steps to Cursor-style skills:

```
.claude/skills/
├── spec-interview/
│   ├── skill.md          # Name + description (static)
│   └── full-prompt.md    # Complete instructions (dynamic)
├── ralph-loop/
│   ├── skill.md
│   └── full-prompt.md
└── parallel-build/
    ├── skill.md
    └── full-prompt.md
```

Agent loads full prompt only when invoking that skill.

#### 5. Progressive ROADMAP Loading

For large projects with many tasks:

```markdown
<!-- ROADMAP.md with progressive structure -->

## Phase Summary (always load)
- Phase 0: Foundation [3/3 complete]
- Phase 1: Core Features [2/8 in progress]  ← CURRENT
- Phase 2: Integration [0/5 pending]

## Phase 1 Details (load when working on Phase 1)
[Full task list for current phase only]
```

---

## Part 4: Implementation Recommendations

### Quick Wins (Immediate)

| Change | Effort | Impact |
|--------|--------|--------|
| Add `head`/`tail` patterns to session protocol | Low | Medium |
| Create reference/INDEX.md | Low | Medium |
| Document grep patterns for common lookups | Low | Medium |

### Medium-Term Improvements

| Change | Effort | Impact |
|--------|--------|--------|
| Restructure PROGRESS.md with sections | Medium | High |
| Create skills-based workflow structure | Medium | High |
| Add phase-summary section to ROADMAP template | Medium | Medium |

### Advanced Optimizations

| Change | Effort | Impact |
|--------|--------|--------|
| Build semantic search index over workflow docs | High | High |
| Implement MCP server for workflow navigation | High | High |
| Create dynamic skill loader | High | Medium |

---

## Part 5: Proposed Pattern for This Workflow

### Session Start with Dynamic Discovery

**Current protocol:**
```
1. Run ./scripts/dev-init.sh
2. Read docs/PROGRESS.md (full file)
3. Read ROADMAP.md (full file)
4. Read features.json
5. Pick next task
```

**Optimized protocol:**
```
1. Run ./scripts/dev-init.sh (shows summary)
2. Read recent progress: head -50 docs/PROGRESS.md
3. Find current work: grep -A20 "in_progress" ROADMAP.md
4. Check feature status: grep "in-progress\|fail" features.json
5. Load full context ONLY for current task
```

### Ralph Loop with Progressive Context

**Current:** Agent has full workflow context loaded
**Optimized:** Agent discovers context as needed

```markdown
# Minimal Ralph Loop Context (static)

You are in autonomous execution mode.

Available resources (discover when needed):
- ROADMAP.md — Task list (grep for current phase)
- docs/PROGRESS.md — History (read recent only)
- PLANS/ — Task plans (read current task's plan)
- reference/ — Deep documentation (search INDEX.md first)

Protocol:
1. Find current task: grep "not-started" ROADMAP.md | head -1
2. Read task plan if exists: cat PLANS/task-[id]-plan.md
3. Execute task
4. Update progress: append to PROGRESS.md
5. Repeat
```

### Parallel Build with Discovery

Each agent gets minimal static boundaries:
```markdown
Agent A owns: /app/domain-a/, /lib/services/domain-a/
Agent A reads: /types/, /components/ui/

If you need context about parallel coordination:
grep -A30 "Coordination" reference/parallel-build.md
```

Full coordination protocols discovered only when needed.

---

## Part 6: Metrics to Track

If implementing these changes, measure:

| Metric | How to Measure | Target |
|--------|----------------|--------|
| Tokens per session | Log API usage | 30-50% reduction |
| Context compactions | Count per session | Fewer than before |
| Time to first task | Session start → work begins | Faster |
| Successful task completion | Tasks done vs blocked | Same or better |

---

## Conclusion

Dynamic context discovery represents a fundamental improvement in how AI agents manage context. The key principles are:

1. **Static = Minimal** — Only load names/summaries upfront
2. **Dynamic = Details** — Full context discovered when needed
3. **Files = Memory** — Use filesystem as extended context
4. **Search = Navigation** — Grep/semantic search over read-all

For this workflow system, the biggest opportunities are:
- Progressive loading of ROADMAP.md and PROGRESS.md
- Skills-based workflow step discovery
- Reference doc indexing
- Grep-first patterns in session protocols

These changes would reduce token usage while maintaining (or improving) task completion quality.

---

## Sources

- [Cursor: Dynamic Context Discovery](https://cursor.com/blog/dynamic-context-discovery)
- [Speakeasy: Comparing Progressive Discovery and Semantic Search](https://www.speakeasy.com/blog/100x-token-reduction-dynamic-toolsets)
- [Speakeasy: Reducing MCP Token Usage by 100x](https://www.speakeasy.com/blog/how-we-reduced-token-usage-by-100x-dynamic-toolsets-v2)
- [Speakeasy: Dynamic Tool Discovery in MCP](https://www.speakeasy.com/mcp/tool-design/dynamic-tool-discovery)
- [Sourcegraph: Lessons from Building AI Coding Assistants](https://sourcegraph.com/blog/lessons-from-building-ai-coding-assistants-context-retrieval-and-evaluation)
- [Cursor: Model Context Protocol Documentation](https://docs.cursor.com/context/model-context-protocol)
- [Milvus: Building Open-Source Alternative to Cursor with Code Context](https://milvus.io/blog/build-open-source-alternative-to-cursor-with-code-context.md)

---

*Research conducted for the Claude Code Workflow System optimization project.*
