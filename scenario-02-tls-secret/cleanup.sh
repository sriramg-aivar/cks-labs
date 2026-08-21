#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace secure --ignore-not-found --grace-period=0 --force
rm -f "$(dirname "$0")"/tls.crt "$(dirname "$0")"/tls.key
echo "Done."
