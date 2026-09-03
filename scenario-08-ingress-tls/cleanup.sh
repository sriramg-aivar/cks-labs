#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace web-ns --ignore-not-found --grace-period=0 --force
rm -rf "${HOME:-/root}/cks-work/scenario-08"
echo "Done. (Cilium IngressClass left in place for reuse)"
