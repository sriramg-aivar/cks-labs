#!/usr/bin/env bash
set -euo pipefail
kubectl delete deployment immutable-app -n default --ignore-not-found --grace-period=0 --force
echo "Done."
