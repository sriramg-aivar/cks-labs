#!/usr/bin/env bash
set -euo pipefail
if [ $# -ne 1 ]; then
  echo "Usage: ./run.sh <scenario-number, e.g. 07>"
  exit 1
fi
NUM="$1"
DIR=$(find . -maxdepth 1 -type d -name "scenario-${NUM}-*" | head -n1)
if [ -z "$DIR" ]; then
  echo "No scenario found matching number '$NUM'"
  exit 1
fi
echo "=== Setting up: $DIR ==="
bash "$DIR/setup.sh"
echo
echo "Task file: $DIR/TASK.md"
[ -f "$DIR/TASK.md" ] && cat "$DIR/TASK.md"
