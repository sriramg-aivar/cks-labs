#!/usr/bin/env bash
set -euo pipefail
kubectl delete deployment multi-arch-app -n default --ignore-not-found
rm -f "$(dirname "$0")"/*.spdx
echo "Done."
