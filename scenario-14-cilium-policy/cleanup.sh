#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace svc-ns client-ns --ignore-not-found --grace-period=0 --force
echo "Done."
