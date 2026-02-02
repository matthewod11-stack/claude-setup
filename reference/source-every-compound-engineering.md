# Compound Engineering — Every.to

> **Source:** [Every.to](https://every.to) / EveryInc
> **Article:** [Compound Engineering: How Every Codes With Agents](https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents)
> **Plugin:** [github.com/EveryInc/compound-engineering-plugin](https://github.com/EveryInc/compound-engineering-plugin)

---

## Core Insight

> "Each unit of engineering work should make subsequent units easier—not harder."

The compound engineering methodology inverts traditional software development. Instead of spending most time coding, it emphasizes:

- **40% Planning** — Thorough upfront design
- **20% Working** — Focused implementation
- **20% Reviewing** — Verification and quality
- **20% Compounding** — Documenting learnings

---

## The Compound Loop

```
Plan → Work → Review → Compound → (repeat)
```

The `/workflows:compound` command is the differentiator. After solving a problem, it:

1. Extracts the problem description
2. Documents the solution
3. Captures what didn't work
4. Tags with searchable keywords
5. Stores in `docs/solutions/` library

---

## Key Principles

1. **Knowledge compounds** — Each solved problem accelerates future work
2. **Document as you go** — Every command generates documentation
3. **Quality compounds** — High-quality code is easier to modify
4. **Context is king** — AI needs history to make good decisions

---

## What We Adopted

The `/compound` skill and solutions library in this workflow system are directly inspired by Every.to's compound engineering methodology.

**Integrated concepts:**
- Solutions library (`~/.claude/solutions/` and `project/solutions/`)
- Session-end compound prompt (after debugging work)
- Searchable learnings at session start
- Problem/solution document format

---

## About Every.to

Every.to (EveryInc) is a media/software company that runs five production products, each primarily built and maintained by a single person using compound engineering. These serve thousands of users daily.

---

*See also: `archive/design-docs/COMPOUND-ENGINEERING-RESEARCH.md` for full analysis*
