---
title: "Official Claude Code Tips from the Creator - Boris Cherny's Team Playbook"
author: "@bcherny (Boris Cherny)"
date_bookmarked: 2026-02-01
original_date: 2026-01-31
category: Tools & Automation / Claude Code
tweet_url: https://x.com/bcherny/status/2017742741636321619
engagement: 36633 likes, 644 replies, 3968 retweets
---

## Key Insight
The biggest productivity unlock is running 3-5 parallel Claude sessions via git worktrees. Combine this with investing in your CLAUDE.md (have Claude write its own rules), plan mode for complex tasks, and custom slash commands for repeated workflows.

## Full Thread (12 parts)

**1/** I'm Boris and I created Claude Code. I wanted to quickly share a few tips for using Claude Code, sourced directly from the Claude Code team. The way the team uses Claude is different than how I use it. Remember: there is no one right way to use Claude Code -- everyones' setup is different. You should experiment to see what works for you!

**2/** **Do more in parallel**

Spin up 3–5 git worktrees at once, each running its own Claude session in parallel. It's the single biggest productivity unlock, and the top tip from the team. Personally, I use multiple git checkouts, but most of the Claude Code team prefers worktrees -- it's the reason @amorriscode built native support for them into the Claude Desktop app!

Some people also name their worktrees and set up shell aliases (za, zb, zc) so they can hop between them in one keystroke. Others have a dedicated "analysis" worktree that's only for reading logs and running BigQuery.

**3/** **Start every complex task in plan mode**

Pour your energy into the plan so Claude can 1-shot the implementation.

One person has one Claude write the plan, then they spin up a second Claude to review it as a staff engineer.

Another says the moment something goes sideways, they switch back to plan mode and re-plan. Don't keep pushing. They also explicitly tell Claude to enter plan mode for verification steps, not just for the build.

**4/** **Invest in your CLAUDE.md**

After every correction, end with: "Update your CLAUDE.md so you don't make that mistake again." Claude is eerily good at writing rules for itself.

Ruthlessly edit your CLAUDE.md over time. Keep iterating until Claude's mistake rate measurably drops.

One engineer tells Claude to maintain a notes directory for every task/project, updated after every PR. They then point CLAUDE.md at it.

**5/** **Create your own skills and commit them to git**

Reuse across every project. Tips from the team:
- If you do something more than once a day, turn it into a skill or command
- Build a /techdebt slash command and run it at the end of every session to find and kill duplicated code
- Set up a slash command that syncs 7 days of Slack, GDrive, Asana, and GitHub into one context dump
- Build analytics-engineer-style agents that write dbt models, review code, and test changes in dev

**6/** **Claude fixes most bugs by itself**

Here's how we do it:
- Enable the Slack MCP, then paste a Slack bug thread into Claude and just say "fix." Zero context switching required.
- Or, just say "Go fix the failing CI tests." Don't micromanage how.
- Point Claude at docker logs to troubleshoot distributed systems -- it's surprisingly capable at this.

**7/** **Level up your prompting**

a. Challenge Claude. Say "Grill me on these changes and don't make a PR until I pass your test." Make Claude be your reviewer. Or, say "Prove to me this works" and have Claude diff behavior between main and your feature branch.

b. After a mediocre fix, say: "Knowing everything you know now, scrap this and implement the elegant solution"

c. Write detailed specs and reduce ambiguity before handing work off. The more specific you are, the better the output.

**8/** **Terminal & Environment Setup**

The team loves Ghostty! Multiple people like its synchronized rendering, 24-bit color, and proper unicode support.

For easier Claude-juggling, use /statusline to customize your status bar to always show context usage and current git branch. Many of us also color-code and name our terminal tabs, sometimes using tmux — one tab per task/worktree.

Use voice dictation. You speak 3x faster than you type, and your prompts get way more detailed as a result. (hit fn x2 on macOS)

**9/** **Use subagents**

a. Append "use subagents" to any request where you want Claude to throw more compute at the problem

b. Offload individual tasks to subagents to keep your main agent's context window clean and focused

c. Route permission requests to Opus 4.5 via a hook — let it scan for attacks and auto-approve the safe ones

**10/** **Use Claude for data & analytics**

Ask Claude Code to use the "bq" CLI to pull and analyze metrics on the fly. We have a BigQuery skill checked into the codebase, and everyone on the team uses it for analytics queries directly in Claude Code. Personally, I haven't written a line of SQL in 6+ months.

This works for any database that has a CLI, MCP, or API.

**11/** **Learning with Claude**

a. Enable the "Explanatory" or "Learning" output style in /config to have Claude explain the *why* behind its changes

b. Have Claude generate a visual HTML presentation explaining unfamiliar code. It makes surprisingly good slides!

c. Ask Claude to draw ASCII diagrams of new protocols and codebases to help you understand them

d. Build a spaced-repetition learning skill: you explain your understanding, Claude asks follow-ups to fill gaps, stores the result

**12/** Hope these tips are helpful! What do you want to hear about next?

## Bonus Tips from Thread (Community + Boris Replies)

### Permission Management
> "Any tips on how to stop Claude asking for permission constantly?"

**Boris:** Run `/permissions` to pre-allow permissions. Actively working on improving this.

### Chrome MCP for Validation
**@ibekidkirsch:** Having Claude Code use `/chrome` to validate changes on the web has been a huge unlock for our team. Feature dev slash commands and a good git hook like lefthook makes all the difference.

**Boris:** Agree, Chrome MCP is a game changer.

### Code Duplication in Large Codebases
> "Claude re-implementing similar code in more than one place as a codebase gets big..."

**Boris:** Make sure that Claude explores the codebase to find reusable functions as part of its plan. Also check for duplication in code review (we do this using `claude -p` in CI).

### Session Scoring
**@bobsheth:** Auto evaluate each Claude session with a score based criteria. Can pull out some great learnings over time.

### On "Creating" Claude Code
> "I always wonder what your team thinks when they read 'I created Claude Code'"

**Boris:** I created it, and now it is very much a team effort. Name a feature, and I can point to the person that dreamed it up & built it.

### Most Surprising Workflow
**Boris:** Probably @The_Whole_Daisy's swarms.

## Author Context
- **Boris Cherny** - Creator of Claude Code, engineer at Anthropic
- Author of "Programming TypeScript" (O'Reilly)
- Based in United States
- Active in sharing Claude Code best practices and responding to user questions

## Why This Matters

**Immediate Workflow Improvements:**
1. **Parallel worktrees** - This is the #1 tip and I'm not doing it. Set up za/zb/zc aliases.
2. **CLAUDE.md self-improvement** - "Update your CLAUDE.md" after corrections is brilliant
3. **Voice dictation** - fn+fn for 3x faster, more detailed prompts
4. **/permissions** - Fix the constant permission prompts

**For Skills Development:**
- `/techdebt` slash command idea is great - run at end of sessions
- Context dump skill (Slack + GDrive + Asana + GitHub) sounds powerful
- Already have `/research-bookmarks` - what else do I do daily?

**For FoundryHR/HRCommand:**
- `claude -p` in CI for code review/duplication detection
- BigQuery skill pattern could apply to any analytics
- Plan mode → implementation is the correct flow

**Meta-Learning:**
- "Explanatory" output style exists in /config (currently using it!)
- HTML presentations for unfamiliar code
- Spaced-repetition learning skill concept

## Related Resources
- Git worktrees: https://git-scm.com/docs/git-worktree
- Ghostty terminal: https://ghostty.org/
- Claude Code skills docs: https://docs.anthropic.com/claude-code/skills

## Action Items
- [ ] Set up git worktree aliases (za, zb, zc) for parallel Claude sessions
- [ ] Add "Update CLAUDE.md" to end of correction workflows
- [ ] Try voice dictation (fn+fn) for longer prompts
- [ ] Run `/permissions` to pre-allow common operations
- [ ] Build `/techdebt` slash command for end-of-session cleanup
- [ ] Explore @The_Whole_Daisy's swarms approach
- [ ] Try `claude -p` in CI for code review
