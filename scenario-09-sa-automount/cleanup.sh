#!/usr/bin/env bash
set -euo pipefail
kubectl delete deployment token-app -n default --ignore-not-found --grace-period=0 --force
kubectl delete serviceaccount restricted-sa -n default --ignore-not-found --grace-period=0 --force
echo "Done."
