#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace web-ns --ignore-not-found
echo "Done. (ingress-nginx controller, if installed, is left in place for reuse — delete manually if desired)"
