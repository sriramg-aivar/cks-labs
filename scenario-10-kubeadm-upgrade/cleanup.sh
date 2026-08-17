#!/usr/bin/env bash
set -euo pipefail
kubectl uncordon cks-lab-worker 2>/dev/null || true
kubectl delete deployment drain-test --ignore-not-found
rm -f /tmp/upgrade-commands.txt
echo "Done."
