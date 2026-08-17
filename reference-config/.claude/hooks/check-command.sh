#!/usr/bin/env bash
# PreToolUse hook for Bash: inspects the command before execution.
#
# Why this exists alongside permissions: permission patterns such as
# Bash(git push:*) match by prefix, so a compound command like
# "cd services && git push" slips past them. This hook inspects the whole
# command string, including everything after && , || and pipes.
#
# Protocol: JSON arrives on stdin with .tool_input.command.
# exit 0 — allowed; exit 2 — blocked, stderr is returned to the model.
set -euo pipefail

input=$(cat)

if command -v jq >/dev/null 2>&1; then
  cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
else
  cmd="$input"
fi

blocked=(
  "sudo "
  "curl "
  "wget "
  "rm -rf /"
  "chmod 777"
  "--no-verify"
  "push --force"
  "push -f"
  "docker system prune"
  "DROP DATABASE"
  "DROP TABLE"
)

for pattern in "${blocked[@]}"; do
  if [[ "$cmd" == *"$pattern"* ]]; then
    echo "Blocked by check-command.sh: the command contains the forbidden pattern '${pattern}'. This applies to compound commands too. Use the project's approved commands (see CLAUDE.md) or ask the user to run it manually." >&2
    exit 2
  fi
done

exit 0
