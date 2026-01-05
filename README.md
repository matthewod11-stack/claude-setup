# Claude Code Workflow System

A structured workflow for taking ideas from concept to working code using Claude Code's autonomous capabilities.

## What Is This?

A templatized system for AI-assisted development that handles:

- **Planning** — Spec interviews, multi-AI review, feedback consolidation, scoping
- **Execution** — Session management, autonomous loops, parallel agent coordination

The workflow scales from quick prototypes (Lite tier) to production systems with API integrations (Full tier).

## Who Is This For?

Developers using [Claude Code](https://claude.ai/code) who want:
- Repeatable structure for new projects
- Session continuity across context windows
- Multi-agent parallel development
- Clear decision points before committing to execution

## Quick Start

```
01-PLAN-SpecInterview.md      → Turn PRD into detailed spec
02-PLAN-SpecReview.md         → Get AI perspectives on spec
03-PLAN-FeedbackConsolidation → Merge multi-AI feedback
04-PLAN-ScopingAndRoadmap.md  → Interactive scoping → ROADMAP.md
05-PLAN-RoadmapValidation.md  → Optional skeptical review
06-EXEC-Setup.md              → Scaffold session infrastructure
07-EXEC-RalphLoop.md          → Autonomous execution
```

Start at [00-WorkflowIndex.md](00-WorkflowIndex.md) for navigation.

## Key Concepts

**Tiers** — Lite for toys, Full for production. Don't over-engineer simple projects.

**Verification** — Every task needs a way to prove it works. Tests, commands, visual checks.

**Session Artifacts** — `ROADMAP.md` (task status), `docs/PROGRESS.md` (session history), `CLAUDE.md` (project context).

**Parallelization** — Decided at Step 04. If domains are independent, run multiple ralph loops.

## Credits & Sources

This workflow builds on ideas from:

- **[Thariq](https://thariq.io)** ([@trq212](https://x.com/trq212/status/2005315275026260309)) — The spec interview pattern using `AskUserQuestionTool` to deeply interview before building. This directly inspired Step 01.

- **[Boris Cherny](https://x.com/bcherny/status/2007179832300581177)** — Creator of Claude Code. His core principle "Give Claude a way to verify its work" is foundational here. See [reference/boris-workflow.md](reference/boris-workflow.md).

- **[Anthropic Engineering Blog](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)** — "Effective Harnesses for Long-Running Agents" informed the session management patterns.

- **Ralph Wiggum Plugin** — The autonomous execution loop (`/ralph-loop`) from the [claude-plugins-official](https://github.com/anthropics/claude-code) marketplace powers Step 07.

- **Multi-AI Review Pattern** — Running the same prompt through Claude, Grok, Gemini, GPT-4, and Codex, then consolidating with consensus tags. The [consolidated feedback](reference/consolidated_workflow_feedback.md) from reviewing *this workflow* demonstrates the pattern.

## License

MIT — use however you want. Attribution appreciated but not required.

---

*Built with Claude Code. Improved through multi-AI review.*
