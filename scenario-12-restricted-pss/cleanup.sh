#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace locked-down --ignore-not-found
echo "Done."
