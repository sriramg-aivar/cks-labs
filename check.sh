#!/usr/bin/env bash
set -euo pipefail
if [ $# -ne 1 ]; then
  echo "Usage: ./check.sh <scenario-number, e.g. 07>"
  exit 1
fi
NUM="$1"
DIR=$(find . -maxdepth 1 -type d -name "scenario-${NUM}-*" | head -n1)
if [ -z "$DIR" ]; then
  echo "No scenario found matching number '$NUM'"
  exit 1
fi
if [ -f "$DIR/check.sh" ]; then
  bash "$DIR/check.sh"
else
  echo "No automated check for this scenario — compare your work against:"
  echo "$DIR/solution.md"
fi
