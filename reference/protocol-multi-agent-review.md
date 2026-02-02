# Multi-Agent Review Protocol

> **Purpose:** Define the orchestration logic for parallel multi-model reviews using real external CLIs
> **Used By:** `/spec-review-multi`, `/multi-model-launch`, `/roadmap-with-validation`

---

## Overview

Multi-agent review launches **real external AI CLIs** (Codex, Gemini, Cursor-Agent) in parallel with an in-session Claude review. Each model reviews from its strength perspective, then results are consolidated with consensus/divergence detection.

**Key Change (v2.0):** Replaced fake "Claude-pretending-to-be-other-models" with actual CLI invocations.

---

## Model Configuration

### Active Models

| Model | CLI Command | Focus Areas |
|-------|-------------|-------------|
| **Claude** | In-session | Edge cases, security, architectural coherence |
| **Codex** | `codex exec` | Implementation feasibility, API design, DX |
| **Gemini** | `gemini --yolo` | Industry patterns, breadth, documentation |
| **Cursor** | `cursor-agent --print` | Code architecture, file structure, modules |

### CLI Locations

```bash
CODEX_BIN="$(which codex)"          # Usually ~/.nvm/.../bin/codex
GEMINI_BIN="$(which gemini)"        # Usually ~/.nvm/.../bin/gemini
CURSOR_BIN="$(which cursor-agent)"  # Usually ~/.local/bin/cursor-agent
```

### Model-Specific Focus Areas

**Claude (In-Session):**
```
Focus especially on:
- Edge cases and failure modes
- Security implications
- Architectural coherence
- Long-term maintainability
- Subtle logical errors
```

**Codex (GPT/OpenAI):**
```
Focus especially on:
- Implementation feasibility
- API design patterns
- Code structure recommendations
- Developer experience
- Practical tradeoffs
```

**Gemini (Google):**
```
Focus especially on:
- Industry patterns and alternatives
- Documentation completeness
- Breadth of considerations
- Research-backed recommendations
- Cross-domain insights
```

**Cursor-Agent:**
```
Focus especially on:
- File and folder structure recommendations
- Module boundaries and organization
- How this would be navigated in an IDE
- Import/export patterns
- Where code should actually live
```

---

## Architecture

### File Structure

```
~/.claude/
├── scripts/
│   ├── multi-model-review.sh        # Main orchestrator
│   ├── lib/
│   │   └── cli-wrappers.sh          # Per-model launch functions
│   └── templates/
│       ├── codex-review-prompt.txt
│       ├── gemini-review-prompt.txt
│       └── cursor-review-prompt.txt
├── commands/
│   ├── multi-model-launch.md        # Launcher skill
│   └── spec-review-multi.md         # Full review skill
├── reference/
│   └── multi-agent-review-protocol.md  # This file
└── reviews/
    └── reviews-YYYY-MM-DD-HHMM/     # Output directories
        ├── manifest.json
        ├── claude_feedback.md
        ├── codex_feedback.md
        ├── gemini_feedback.md
        ├── cursor_feedback.md
        └── consolidated_feedback.md
```

### Execution Flow

```
User: /spec-review-multi specs/my-feature.md

1. Create: ~/.claude/reviews/reviews-2026-02-01-1630/
2. Launch in parallel:
   │
   ├── [Background] codex exec  → codex_feedback.md
   ├── [Background] gemini      → gemini_feedback.md
   ├── [Background] cursor      → cursor_feedback.md
   │
   └── [In-session] Claude reviews → claude_feedback.md
       (edge cases, security, architecture)

3. Monitor: Poll every 30s, show progress
4. Consolidate: Apply consensus/divergence logic (4 sources)
5. Output: consolidated_feedback.md
```

---

## Spawning Pattern

### External CLIs (Background Processes)

The orchestrator script launches all CLIs with appropriate flags:

```bash
# Codex - uses exec mode with full-auto
codex exec --full-auto -o "$OUTPUT_FILE" "$PROMPT"

# Gemini - uses yolo mode for auto-approval
gemini --yolo "$PROMPT" > "$OUTPUT_FILE"

# Cursor - uses print mode for non-interactive
cursor-agent --print --output-format text "$PROMPT" > "$OUTPUT_FILE"
```

### Claude (In-Session)

Claude performs its review while external CLIs work, maximizing parallelism:

1. Read spec file content
2. Apply Claude-specific review prompt
3. Write output to `claude_feedback.md`
4. Continue monitoring external progress

---

## Monitoring Strategy

### Sentinel Files

Each CLI wrapper creates a `.done` sentinel file on completion:

```bash
# Success
echo "success" > "${OUTPUT_FILE}.done"

# Failure
echo "error:$EXIT_CODE" > "${OUTPUT_FILE}.done"
```

### Progress Polling

Check every 30 seconds:

```bash
# Count completed
ls -la ~/.claude/reviews/reviews-*/*.done 2>/dev/null | wc -l

# Check status
cat ~/.claude/reviews/reviews-*/*.done
```

### Progress Report Format

```
Review Progress:
- Claude:  ✓ Complete (in-session)
- Codex:   ⏳ Working (5 min)
- Gemini:  ✓ Complete
- Cursor:  ✗ Failed (error:1)

Files found: 2/4
```

### Timeout Configuration

| Setting | Value |
|---------|-------|
| Per-model timeout | 15 minutes |
| Total timeout | 20 minutes |
| Poll interval | 30 seconds |
| Minimum for consensus | 2 reviews |

---

## Completion Handling

### Full Completion (4/4)

Proceed immediately to consolidation.

### Partial Completion (2-3/4)

After timeout, offer options:
```
3/4 reviews complete. Codex timed out.

Options:
A) Proceed with 3 reviews (sufficient for consensus detection)
B) Wait 5 more minutes
C) Retry failed CLI
```

### Minimal Completion (1/4)

```
Only 1/4 reviews complete.

Options:
A) Proceed with single review (no consensus possible)
B) Wait longer
C) Abort and try manual review
```

### No Completion (0/4)

```
No reviews completed within timeout.

Possible causes:
- CLI authentication issues
- Network problems
- Prompt too large

Options:
A) Retry with fresh processes
B) Generate prompt pack for manual execution
C) Fall back to Claude-only review
```

---

## Consolidation Logic

### Source Attribution

Every point must be tagged with source model(s):

```markdown
- [Point] — [Claude]
- [Point] — [Codex, Gemini]
- [Point] — [Claude, Codex, Gemini, Cursor]
```

### Consensus Detection (🔺)

**Definition:** Item raised by 2+ models (even if worded differently)

**Detection Method:**
1. Parse all feedback files
2. Extract individual points
3. Semantic matching (not exact wording)
4. Tag matches with 🔺 CONSENSUS

**Semantic Matching Examples:**
- "Needs error handling" ≈ "Failure states undefined"
- "Missing dependency" ≈ "Order unclear"
- "Too complex" ≈ "Should simplify"

### Divergence Detection (⚠️)

**Definition:** Models explicitly disagree on approach

**Format:**
```markdown
⚠️ DIVERGENT: [Topic]
- [Position A] — Claude, Codex
- [Position B] — Gemini, Cursor
- **Resolution needed:** [What decision is required]
```

---

## Output Format

### Consolidated Feedback

```markdown
# Consolidated Spec Feedback — [PROJECT_NAME]

**Sources:** claude_feedback.md, codex_feedback.md, gemini_feedback.md, cursor_feedback.md
**Date:** [DATE]
**Review Duration:** [X minutes]

---

## Consensus Summary

🔺 Items flagged by 2+ reviewers:

1. [Issue] — Claude, Codex, Gemini
2. [Issue] — Claude, Cursor
3. [Issue] — All 4 models

---

## By Category

### Implementation Feasibility (Codex Lead)
[Points with validation from others]

### Architecture & Structure (Cursor Lead)
[Points with validation from others]

### Security & Edge Cases (Claude Lead)
[Points]

### Patterns & Breadth (Gemini Lead)
[Points with validation from others]

---

## Divergent Opinions

[Any ⚠️ DIVERGENT items]

---

## Appendix: Full Reviews

### Claude (In-Session)
[Full content]

### Codex (CLI)
[Full content]

### Gemini (CLI)
[Full content]

### Cursor (CLI)
[Full content]
```

### Manifest File (JSON)

```json
{
  "timestamp": "2026-02-01T16:30:00-08:00",
  "spec_file": "/path/to/spec.md",
  "output_dir": "~/.claude/reviews/reviews-2026-02-01-1630",
  "duration_seconds": 423,
  "reviewers": [
    {"name": "claude", "output": "claude_feedback.md", "status": "success"},
    {"name": "codex", "output": "codex_feedback.md", "status": "success"},
    {"name": "gemini", "output": "gemini_feedback.md", "status": "success"},
    {"name": "cursor", "output": "cursor_feedback.md", "status": "error:1"}
  ]
}
```

---

## Quality Validation

### Pre-Consolidation Checks

For each feedback file, verify:
- [ ] File exists and has content (> 100 bytes)
- [ ] Contains expected section headers
- [ ] Has substantive content (not just headers)
- [ ] Follows expected output format

### Post-Consolidation Checks

- [ ] All source files referenced
- [ ] Consensus items tagged with 🔺
- [ ] Divergent items tagged with ⚠️
- [ ] Appendix contains full reviews
- [ ] No points lost in consolidation

---

## Error Handling

### CLI Not Found

```
✗ codex CLI not found

Options:
A) Install: npm install -g @openai/codex
B) Proceed without Codex (3 reviewers)
C) Generate prompt for manual execution
```

### CLI Authentication Failure

```
✗ gemini authentication failed

The CLI may need re-authentication:
  gemini login

Options:
A) Skip Gemini for now
B) Wait while you authenticate
```

### Output File Corruption

```
[Model] output file appears corrupted or incomplete.

Options:
A) Exclude from consolidation
B) Request retry
C) Include partial content with warning
```

---

## Fallback: Prompt Pack

If CLIs aren't working, generate copy-paste commands:

```bash
# Save prompts to files
cat > /tmp/codex_prompt.txt << 'EOF'
[Full prompt here]
EOF

# Terminal 1 - Codex:
codex exec --full-auto -o codex_feedback.md "$(cat /tmp/codex_prompt.txt)"

# Terminal 2 - Gemini:
gemini --yolo "$(cat /tmp/gemini_prompt.txt)" > gemini_feedback.md

# Terminal 3 - Cursor:
cursor-agent --print --output-format text "$(cat /tmp/cursor_prompt.txt)" > cursor_feedback.md
```

---

*Protocol version: 2.0 | Updated: 2026-02-01*
*v1.0: Fake Claude subagents pretending to be other models*
*v2.0: Real CLI invocations with actual model diversity*
