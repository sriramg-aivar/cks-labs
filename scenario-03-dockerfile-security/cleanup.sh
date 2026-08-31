#!/usr/bin/env bash
set -euo pipefail
kubectl delete deployment hardened-app -n default --ignore-not-found --grace-period=0 --force
rm -rf "${HOME:-/root}/cks-work/scenario-03"
echo "Done."
