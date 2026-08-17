#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace secure --ignore-not-found
rm -f "$(dirname "$0")"/tls.crt "$(dirname "$0")"/tls.key
echo "Done."
