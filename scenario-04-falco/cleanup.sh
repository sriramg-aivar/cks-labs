#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace monitoring --ignore-not-found --grace-period=0 --force
# Remove only the scenario's custom rule file (leave Falco itself installed)
rm -f /etc/falco/rules.d/custom-rules.yaml 2>/dev/null || true
rm -rf /opt/falco 2>/dev/null || true
echo "Done. (Falco left installed for reuse; scenario custom rule removed)"
