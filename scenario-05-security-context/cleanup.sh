#!/usr/bin/env bash
set -euo pipefail
kubectl delete deployment immutable-app -n default --ignore-not-found
echo "Done."
