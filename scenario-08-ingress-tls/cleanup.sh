#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace web-ns --ignore-not-found --grace-period=0 --force
echo "Done. (ingress-nginx controller, if installed, is left in place for reuse — delete manually if desired)"
