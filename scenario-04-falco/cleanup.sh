#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace monitoring --ignore-not-found --grace-period=0 --force
rm -rf /opt/falco
echo "Done."
