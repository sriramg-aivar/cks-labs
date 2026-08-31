#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace secure --ignore-not-found --grace-period=0 --force
rm -rf "${HOME:-/root}/cks-work/scenario-02"
echo "Done."
