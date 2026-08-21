#!/usr/bin/env bash
set -euo pipefail
kubectl delete deployment multi-arch-app -n default --ignore-not-found --grace-period=0 --force
rm -f "$(dirname "$0")"/*.spdx
echo "Done."
