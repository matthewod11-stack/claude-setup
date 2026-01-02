#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
model=$(echo "$input" | jq -r '.model.display_name')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size')

# Get directory name
dir_name=$(basename "$cwd")

# Get git branch if in a git repository
git_branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        git_branch=" on $branch"
    fi
fi

# Calculate context usage percentage
total_tokens=$((total_input + total_output))
if [ "$context_size" -gt 0 ]; then
    usage_percent=$((total_tokens * 100 / context_size))
else
    usage_percent=0
fi

# Determine color based on usage percentage
if [ "$usage_percent" -ge 80 ]; then
    # Red for high usage (80%+)
    color_code="\033[31m"
elif [ "$usage_percent" -ge 50 ]; then
    # Yellow for medium usage (50-79%)
    color_code="\033[33m"
else
    # Green for low usage (0-49%)
    color_code="\033[32m"
fi
reset_code="\033[0m"

# Format and print status line with colored context percentage
printf "%s%s | %s | Context: ${color_code}%d%%${reset_code}" "$dir_name" "$git_branch" "$model" "$usage_percent"
