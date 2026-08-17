#!/usr/bin/env bash
set -euo pipefail
kubectl delete deployment token-app -n default --ignore-not-found
kubectl delete serviceaccount restricted-sa -n default --ignore-not-found
echo "Done."
