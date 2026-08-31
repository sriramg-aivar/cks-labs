#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace shop --ignore-not-found --grace-period=0 --force
echo "Done. (trivy left installed for reuse)"
