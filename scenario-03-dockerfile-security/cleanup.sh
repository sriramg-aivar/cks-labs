#!/usr/bin/env bash
set -euo pipefail
kubectl delete -f "$(dirname "$0")/deployment.yaml" --ignore-not-found --grace-period=0 --force 2>/dev/null || \
  kubectl delete deployment hardened-app -n default --ignore-not-found --grace-period=0 --force
rm -f "$(dirname "$0")"/Dockerfile "$(dirname "$0")"/deployment.yaml
echo "Done."
