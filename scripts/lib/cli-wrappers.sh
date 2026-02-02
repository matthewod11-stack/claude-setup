#!/usr/bin/env bash
# CLI Wrapper Functions for Multi-Model Review
# Each function launches a CLI tool with appropriate flags for non-interactive spec review

# Paths to CLIs
CODEX_BIN="${CODEX_BIN:-$(which codex 2>/dev/null || echo "$HOME/.nvm/versions/node/v24.13.0/bin/codex")}"
GEMINI_BIN="${GEMINI_BIN:-$(which gemini 2>/dev/null || echo "$HOME/.nvm/versions/node/v24.13.0/bin/gemini")}"
CURSOR_BIN="${CURSOR_BIN:-$(which cursor-agent 2>/dev/null || echo "$HOME/.local/bin/cursor-agent")}"

# Template directory
TEMPLATE_DIR="${TEMPLATE_DIR:-$HOME/.claude/scripts/templates}"

# Sentinel file suffix for completion detection
SENTINEL_SUFFIX=".done"

# ---------------------------------------------------------------------------
# Utility: Build prompt from template
# Args: $1 = template file, $2 = spec content file
# Output: Full prompt to stdout
# ---------------------------------------------------------------------------
build_prompt() {
    local template_file="$1"
    local spec_file="$2"

    if [[ ! -f "$template_file" ]]; then
        echo "ERROR: Template file not found: $template_file" >&2
        return 1
    fi

    if [[ ! -f "$spec_file" ]]; then
        echo "ERROR: Spec file not found: $spec_file" >&2
        return 1
    fi

    # Use perl for reliable multiline substitution
    # Falls back to a line-by-line approach if perl unavailable
    if command -v perl &>/dev/null; then
        perl -pe 'BEGIN {
            open(F, "'"$spec_file"'") or die;
            local $/; $content = <F>; close(F);
            $content =~ s/\\/\\\\/g;  # escape backslashes
            $content =~ s/\$/\\\$/g;  # escape dollar signs
        } s/\{\{SPEC_CONTENT\}\}/$content/g' "$template_file"
    else
        # Fallback: output template with placeholder replaced by file contents
        # Read template line by line
        while IFS= read -r line || [[ -n "$line" ]]; do
            if [[ "$line" == *"{{SPEC_CONTENT}}"* ]]; then
                # Output everything before the placeholder
                echo -n "${line%%\{\{SPEC_CONTENT\}\}*}"
                # Output the spec file contents
                cat "$spec_file"
                # Output everything after the placeholder
                echo "${line##*\{\{SPEC_CONTENT\}\}}"
            else
                echo "$line"
            fi
        done < "$template_file"
    fi
}

# ---------------------------------------------------------------------------
# Launch Codex CLI (OpenAI)
# Args: $1 = spec file, $2 = output file
# ---------------------------------------------------------------------------
launch_codex() {
    local spec_file="$1"
    local output_file="$2"
    local sentinel_file="${output_file}${SENTINEL_SUFFIX}"

    local prompt
    prompt=$(build_prompt "$TEMPLATE_DIR/codex-review-prompt.txt" "$spec_file")

    if [[ $? -ne 0 ]]; then
        echo "FAILED: Could not build prompt" > "$output_file"
        echo "error" > "$sentinel_file"
        return 1
    fi

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting Codex review..." >&2

    # Run codex in exec mode with full-auto, output to file
    # Use --model flag if we want to specify, otherwise use default
    "$CODEX_BIN" exec --full-auto -o "$output_file" "$prompt" 2>&1
    local exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
        echo "success" > "$sentinel_file"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Codex review complete" >&2
    else
        echo "error:$exit_code" > "$sentinel_file"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Codex review failed with code $exit_code" >&2
    fi

    return $exit_code
}

# ---------------------------------------------------------------------------
# Launch Gemini CLI (Google)
# Args: $1 = spec file, $2 = output file
# ---------------------------------------------------------------------------
launch_gemini() {
    local spec_file="$1"
    local output_file="$2"
    local sentinel_file="${output_file}${SENTINEL_SUFFIX}"

    local prompt
    prompt=$(build_prompt "$TEMPLATE_DIR/gemini-review-prompt.txt" "$spec_file")

    if [[ $? -ne 0 ]]; then
        echo "FAILED: Could not build prompt" > "$output_file"
        echo "error" > "$sentinel_file"
        return 1
    fi

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting Gemini review..." >&2

    # Gemini uses positional prompt with --yolo for auto-approve
    # Output goes to stdout, so we redirect to file
    "$GEMINI_BIN" --yolo "$prompt" > "$output_file" 2>&1
    local exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
        echo "success" > "$sentinel_file"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Gemini review complete" >&2
    else
        echo "error:$exit_code" > "$sentinel_file"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Gemini review failed with code $exit_code" >&2
    fi

    return $exit_code
}

# ---------------------------------------------------------------------------
# Launch Cursor Agent CLI
# Args: $1 = spec file, $2 = output file
# ---------------------------------------------------------------------------
launch_cursor() {
    local spec_file="$1"
    local output_file="$2"
    local sentinel_file="${output_file}${SENTINEL_SUFFIX}"

    local prompt
    prompt=$(build_prompt "$TEMPLATE_DIR/cursor-review-prompt.txt" "$spec_file")

    if [[ $? -ne 0 ]]; then
        echo "FAILED: Could not build prompt" > "$output_file"
        echo "error" > "$sentinel_file"
        return 1
    fi

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting Cursor review..." >&2

    # Cursor uses --print for non-interactive mode, --output-format text
    "$CURSOR_BIN" --print --output-format text "$prompt" > "$output_file" 2>&1
    local exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
        echo "success" > "$sentinel_file"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cursor review complete" >&2
    else
        echo "error:$exit_code" > "$sentinel_file"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cursor review failed with code $exit_code" >&2
    fi

    return $exit_code
}

# ---------------------------------------------------------------------------
# Get current model info for each CLI
# ---------------------------------------------------------------------------
get_model_info() {
    echo "=== Current Model Configuration ==="

    echo -n "Codex: "
    if [[ -f "$HOME/.codex/config.toml" ]]; then
        grep -E "^model\s*=" "$HOME/.codex/config.toml" 2>/dev/null || echo "(using default)"
    else
        echo "(using default)"
    fi

    echo -n "Gemini: "
    if [[ -f "$HOME/.gemini/settings.json" ]]; then
        cat "$HOME/.gemini/settings.json" 2>/dev/null | grep -o '"model"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 || echo "(using default)"
    else
        echo "(using default)"
    fi

    echo -n "Cursor: "
    if [[ -f "$HOME/.cursor/cli-config.json" ]]; then
        cat "$HOME/.cursor/cli-config.json" 2>/dev/null | grep -o '"modelId"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 || echo "(using default)"
    else
        echo "(using default)"
    fi

    echo "==================================="
}

# ---------------------------------------------------------------------------
# Check if CLI is available
# Args: $1 = cli name (codex|gemini|cursor)
# Returns: 0 if available, 1 if not
# ---------------------------------------------------------------------------
check_cli() {
    local cli_name="$1"

    case "$cli_name" in
        codex)
            [[ -x "$CODEX_BIN" ]] && return 0
            ;;
        gemini)
            [[ -x "$GEMINI_BIN" ]] && return 0
            ;;
        cursor)
            [[ -x "$CURSOR_BIN" ]] && return 0
            ;;
    esac

    return 1
}
