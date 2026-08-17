#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace monitoring --ignore-not-found
docker exec cks-lab-control-plane rm -rf /opt/falco
echo "Done."
