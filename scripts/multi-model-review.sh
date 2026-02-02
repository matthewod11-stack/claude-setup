#!/usr/bin/env bash
# Multi-Model Review Orchestrator
# Launches Codex, Gemini, and Cursor CLIs in parallel for spec review
# Usage: multi-model-review.sh <spec-file> [output-dir]

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"
TEMPLATE_DIR="$SCRIPT_DIR/templates"

# Source CLI wrappers
source "$LIB_DIR/cli-wrappers.sh"

# Timeouts
POLL_INTERVAL=30        # seconds between status checks
PER_MODEL_TIMEOUT=900   # 15 minutes per model
TOTAL_TIMEOUT=1200      # 20 minutes total

# ---------------------------------------------------------------------------
# Utility Functions
# ---------------------------------------------------------------------------
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

die() {
    log "ERROR: $*" >&2
    exit 1
}

usage() {
    cat <<EOF
Multi-Model Review Orchestrator

Usage: $(basename "$0") <spec-file> [output-dir]

Arguments:
  spec-file   Path to the specification file to review
  output-dir  Optional output directory (default: creates timestamped dir)

Options:
  -h, --help     Show this help message
  --dry-run      Show what would be executed without running
  --models       Show configured models for each CLI

Examples:
  $(basename "$0") specs/my-feature.md
  $(basename "$0") specs/my-feature.md ./reviews/
  $(basename "$0") --models
EOF
}

# ---------------------------------------------------------------------------
# Argument Parsing
# ---------------------------------------------------------------------------
DRY_RUN=false
SHOW_MODELS=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --models)
            SHOW_MODELS=true
            shift
            ;;
        -*)
            die "Unknown option: $1"
            ;;
        *)
            break
            ;;
    esac
done

if [[ "$SHOW_MODELS" == "true" ]]; then
    get_model_info
    exit 0
fi

# Validate spec file argument
SPEC_FILE="${1:-}"
if [[ -z "$SPEC_FILE" ]]; then
    usage
    die "Spec file is required"
fi

if [[ ! -f "$SPEC_FILE" ]]; then
    die "Spec file not found: $SPEC_FILE"
fi

# Resolve to absolute path
SPEC_FILE="$(cd "$(dirname "$SPEC_FILE")" && pwd)/$(basename "$SPEC_FILE")"

# Set up output directory
OUTPUT_DIR="${2:-}"
if [[ -z "$OUTPUT_DIR" ]]; then
    TIMESTAMP=$(date '+%Y-%m-%d-%H%M')
    OUTPUT_DIR="$HOME/.claude/reviews/reviews-$TIMESTAMP"
fi
mkdir -p "$OUTPUT_DIR"
OUTPUT_DIR="$(cd "$OUTPUT_DIR" && pwd)"

# ---------------------------------------------------------------------------
# Pre-flight Checks
# ---------------------------------------------------------------------------
log "=== Multi-Model Review Orchestrator ==="
log "Spec file: $SPEC_FILE"
log "Output dir: $OUTPUT_DIR"
log ""

# Check CLI availability
AVAILABLE_CLIS=()
UNAVAILABLE_CLIS=()

for cli in codex gemini cursor; do
    if check_cli "$cli"; then
        AVAILABLE_CLIS+=("$cli")
        log "✓ $cli CLI available"
    else
        UNAVAILABLE_CLIS+=("$cli")
        log "✗ $cli CLI not found"
    fi
done

if [[ ${#AVAILABLE_CLIS[@]} -eq 0 ]]; then
    die "No CLIs available. Install at least one of: codex, gemini, cursor-agent"
fi

if [[ ${#UNAVAILABLE_CLIS[@]} -gt 0 ]]; then
    log "WARNING: Some CLIs unavailable: ${UNAVAILABLE_CLIS[*]}"
fi

log ""
get_model_info
log ""

if [[ "$DRY_RUN" == "true" ]]; then
    log "DRY RUN: Would launch ${#AVAILABLE_CLIS[@]} reviewers"
    for cli in "${AVAILABLE_CLIS[@]}"; do
        log "  - $cli -> ${OUTPUT_DIR}/${cli}_feedback.md"
    done
    exit 0
fi

# ---------------------------------------------------------------------------
# Launch Reviews in Parallel
# ---------------------------------------------------------------------------
log "Launching ${#AVAILABLE_CLIS[@]} parallel reviewers..."
log ""

declare -A PIDS
declare -A OUTPUT_FILES
START_TIME=$(date +%s)

for cli in "${AVAILABLE_CLIS[@]}"; do
    output_file="${OUTPUT_DIR}/${cli}_feedback.md"
    OUTPUT_FILES[$cli]="$output_file"

    case "$cli" in
        codex)
            launch_codex "$SPEC_FILE" "$output_file" &
            PIDS[$cli]=$!
            ;;
        gemini)
            launch_gemini "$SPEC_FILE" "$output_file" &
            PIDS[$cli]=$!
            ;;
        cursor)
            launch_cursor "$SPEC_FILE" "$output_file" &
            PIDS[$cli]=$!
            ;;
    esac

    log "Started $cli (PID: ${PIDS[$cli]}) -> $(basename "$output_file")"
done

log ""
log "All reviewers launched. Monitoring progress..."
log ""

# ---------------------------------------------------------------------------
# Monitor Progress
# ---------------------------------------------------------------------------
monitor_progress() {
    local completed=0
    local total=${#AVAILABLE_CLIS[@]}
    local elapsed=0

    while [[ $completed -lt $total ]]; do
        sleep "$POLL_INTERVAL"
        elapsed=$(($(date +%s) - START_TIME))

        # Check timeout
        if [[ $elapsed -gt $TOTAL_TIMEOUT ]]; then
            log "TIMEOUT: Total timeout ($TOTAL_TIMEOUT seconds) exceeded"
            break
        fi

        # Check each CLI
        completed=0
        local status_line=""

        for cli in "${AVAILABLE_CLIS[@]}"; do
            local output_file="${OUTPUT_FILES[$cli]}"
            local sentinel_file="${output_file}.done"
            local pid="${PIDS[$cli]}"

            if [[ -f "$sentinel_file" ]]; then
                local status
                status=$(cat "$sentinel_file")
                if [[ "$status" == "success" ]]; then
                    status_line+="  $cli: ✓ Complete\n"
                else
                    status_line+="  $cli: ✗ Failed ($status)\n"
                fi
                ((completed++))
            elif ! kill -0 "$pid" 2>/dev/null; then
                # Process died without sentinel
                echo "error:process-died" > "$sentinel_file"
                status_line+="  $cli: ✗ Process died\n"
                ((completed++))
            else
                local runtime=$((elapsed / 60))
                status_line+="  $cli: ⏳ Working (${runtime}m)\n"
            fi
        done

        log "Progress: $completed/$total complete (${elapsed}s elapsed)"
        echo -e "$status_line"
    done

    return $completed
}

# Run monitoring
monitor_progress
COMPLETED=$?

# ---------------------------------------------------------------------------
# Cleanup and Summary
# ---------------------------------------------------------------------------
log ""
log "=== Review Complete ==="
log "Duration: $(($(date +%s) - START_TIME)) seconds"
log "Completed: $COMPLETED/${#AVAILABLE_CLIS[@]} reviews"
log ""

# Collect results
log "Output files:"
for cli in "${AVAILABLE_CLIS[@]}"; do
    local output_file="${OUTPUT_FILES[$cli]}"
    local sentinel_file="${output_file}.done"

    if [[ -f "$sentinel_file" ]]; then
        local status
        status=$(cat "$sentinel_file")
        local size=0
        [[ -f "$output_file" ]] && size=$(wc -c < "$output_file" | tr -d ' ')

        if [[ "$status" == "success" ]]; then
            log "  ✓ $cli: $(basename "$output_file") ($size bytes)"
        else
            log "  ✗ $cli: FAILED - $status"
        fi
    else
        log "  ? $cli: Status unknown (no sentinel)"
    fi
done

log ""
log "Output directory: $OUTPUT_DIR"

# Write manifest file
MANIFEST_FILE="${OUTPUT_DIR}/manifest.json"
cat > "$MANIFEST_FILE" <<EOF
{
  "timestamp": "$(date -Iseconds)",
  "spec_file": "$SPEC_FILE",
  "output_dir": "$OUTPUT_DIR",
  "duration_seconds": $(($(date +%s) - START_TIME)),
  "reviewers": [
$(for i in "${!AVAILABLE_CLIS[@]}"; do
    cli="${AVAILABLE_CLIS[$i]}"
    output_file="${OUTPUT_FILES[$cli]}"
    sentinel_file="${output_file}.done"
    status="unknown"
    [[ -f "$sentinel_file" ]] && status=$(cat "$sentinel_file")
    comma=""
    [[ $i -lt $((${#AVAILABLE_CLIS[@]} - 1)) ]] && comma=","
    echo "    {\"name\": \"$cli\", \"output\": \"$(basename "$output_file")\", \"status\": \"$status\"}$comma"
done)
  ]
}
EOF

log "Manifest written: $MANIFEST_FILE"

# Exit with appropriate code
if [[ $COMPLETED -eq ${#AVAILABLE_CLIS[@]} ]]; then
    exit 0
elif [[ $COMPLETED -ge 2 ]]; then
    log "Partial completion - sufficient for consensus detection"
    exit 0
else
    log "WARNING: Insufficient reviews for consensus (need 2+)"
    exit 1
fi
