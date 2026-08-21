#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace locked-down --ignore-not-found --grace-period=0 --force
echo "Done."
