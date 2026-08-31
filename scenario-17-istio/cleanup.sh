#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace payments --ignore-not-found --grace-period=0 --force
echo "Done. (Istio itself is left installed in istio-system for reuse — remove with 'istioctl uninstall --purge -y' if desired)"
