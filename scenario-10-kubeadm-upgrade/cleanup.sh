#!/usr/bin/env bash
set -euo pipefail
kubectl uncordon node01 2>/dev/null || true
kubectl delete deployment drain-test --ignore-not-found --grace-period=0 --force
rm -f /tmp/upgrade-commands.txt
echo "Done."
