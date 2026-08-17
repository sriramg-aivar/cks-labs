#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace svc-ns client-ns --ignore-not-found
echo "Done."
