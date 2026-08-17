#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace monitoring --ignore-not-found
rm -rf /opt/falco
echo "Done."
