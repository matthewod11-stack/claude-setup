# Multi-Model Review Setup

The `/spec-review-multi` skill can use **real external AI CLIs** (Codex, Gemini, Cursor-Agent) alongside Claude for genuine multi-perspective feedback.

---

## Why Real Multi-Model?

Without external CLIs, the skill runs Claude 4 times with different prompts ("act as GPT-4"). This provides some value but no true diversity of thought.

With external CLIs installed, you get **4 genuinely different AI models** reviewing your spec in parallel:

| Model | Provider | Focus Areas |
|-------|----------|-------------|
| **Claude** | Anthropic | Edge cases, security, architectural coherence |
| **Codex** | OpenAI | Implementation feasibility, API design, DX |
| **Gemini** | Google | Industry patterns, breadth, documentation |
| **Cursor** | Anysphere | File structure, module design, IDE navigation |

---

## CLI Installation

### Codex (OpenAI)

```bash
npm install -g @openai/codex

# Authenticate
codex login
```

**Verify:** `codex --version`

### Gemini (Google)

```bash
npm install -g @google/gemini-cli

# Authenticate
gemini login
```

**Verify:** `gemini --version`

### Cursor Agent

Download from [cursor.sh](https://cursor.sh) or install via:

```bash
# macOS
curl -fsSL https://cursor.sh/install-agent.sh | bash
```

**Verify:** `cursor-agent --version`

---

## Configuration

Each CLI uses its default model. To use specific models:

### Codex

```bash
# Set in ~/.codex/config.toml
[model]
name = "o3"  # or gpt-4, etc.
```

### Gemini

```bash
# Set in ~/.gemini/settings.json
{
  "model": "gemini-2.5-pro"
}
```

### Cursor

```bash
# Set in ~/.cursor/cli-config.json
{
  "model": {
    "modelId": "claude-4.5-opus"
  }
}
```

---

## Verify Setup

Run the orchestrator with `--models` to check configuration:

```bash
~/.claude/scripts/multi-model-review.sh --models
```

Output:
```
=== Current Model Configuration ===
Codex: (using default)
Gemini: (using default)
Cursor: "modelId": "claude-4.5-opus-high-thinking"
===================================
```

---

## Dry Run

Test without actually running reviews:

```bash
~/.claude/scripts/multi-model-review.sh --dry-run path/to/spec.md
```

---

## How It Works

1. **Launch Phase**: Orchestrator spawns 3 CLI processes in parallel (background jobs)
2. **Claude Phase**: While CLIs work, Claude performs its own in-session review
3. **Monitor Phase**: Poll for completion every 30 seconds
4. **Consolidate Phase**: Merge all 4 reviews with consensus/divergence detection

```
/spec-review-multi specs/my-feature.md
    │
    ├── [Background] codex exec  → codex_feedback.md
    ├── [Background] gemini      → gemini_feedback.md
    ├── [Background] cursor      → cursor_feedback.md
    │
    └── [In-session] Claude      → claude_feedback.md

    → consolidated_feedback.md
```

---

## Timeouts

| Setting | Value |
|---------|-------|
| Per-model timeout | 15 minutes |
| Total timeout | 20 minutes |
| Poll interval | 30 seconds |
| Minimum for consensus | 2 reviews |

---

## Fallback Behavior

If CLIs aren't installed, the skill gracefully degrades:

- **3 CLIs available** → 4 real perspectives (3 CLIs + Claude)
- **2 CLIs available** → 3 real perspectives
- **1 CLI available** → 2 real perspectives
- **0 CLIs available** → Claude-only review (still useful, but no external diversity)

---

## Troubleshooting

### CLI not found

```
✗ codex CLI not found
```

**Solution:** Install the CLI or update your PATH.

### Authentication failed

```
✗ gemini authentication failed
```

**Solution:** Run `gemini login` to re-authenticate.

### Timeout with no output

**Possible causes:**
- Network issues
- Prompt too large (try smaller spec)
- API rate limiting

**Solutions:**
- Check CLI works standalone: `codex exec "Hello"`
- Check network connectivity
- Try with smaller spec file

---

## Manual Execution

If the orchestrator isn't working, you can run CLIs manually:

```bash
# Terminal 1 - Codex
codex exec --full-auto -o codex_feedback.md "$(cat prompt.txt)"

# Terminal 2 - Gemini
gemini --yolo "$(cat prompt.txt)" > gemini_feedback.md

# Terminal 3 - Cursor
cursor-agent --print --output-format text "$(cat prompt.txt)" > cursor_feedback.md
```

---

## Cost Considerations

Each CLI may have its own billing:

- **Codex**: Uses your OpenAI API credits
- **Gemini**: Uses your Google AI credits
- **Cursor**: Uses your Cursor subscription

For cost-sensitive reviews, consider using only 1-2 external CLIs.

---

*Multi-model review is optional but recommended for production specs.*
