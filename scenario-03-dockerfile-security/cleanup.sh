#!/usr/bin/env bash
set -euo pipefail
kubectl delete -f "$(dirname "$0")/deployment.yaml" --ignore-not-found 2>/dev/null || \
  kubectl delete deployment hardened-app -n default --ignore-not-found
rm -f "$(dirname "$0")"/Dockerfile "$(dirname "$0")"/deployment.yaml
echo "Done."
