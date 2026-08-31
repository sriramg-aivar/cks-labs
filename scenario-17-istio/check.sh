#!/usr/bin/env bash
set -euo pipefail
echo "Checking Istio scenario..."

FAILED=0

# 1. Namespace labeled for injection
LABEL=$(kubectl get ns payments -o jsonpath='{.metadata.labels.istio-injection}' 2>/dev/null || echo "")
if [ "$LABEL" = "enabled" ]; then
  echo "✓ Namespace 'payments' has istio-injection=enabled"
else
  echo "✗ Namespace 'payments' should have label istio-injection=enabled"
  FAILED=1
fi

# 2. api pod has istio-proxy sidecar (2 containers)
CONTAINERS=$(kubectl -n payments get pod -l app=api -o jsonpath='{.items[0].spec.containers[*].name}' 2>/dev/null || echo "")
if echo "$CONTAINERS" | grep -q "istio-proxy"; then
  echo "✓ api pod has istio-proxy sidecar injected"
else
  echo "✗ api pod missing istio-proxy sidecar — did you restart the deployment after labeling?"
  echo "  (current containers: $CONTAINERS)"
  FAILED=1
fi

# 3. PeerAuthentication exists and is STRICT
MODE=$(kubectl -n payments get peerauthentication default -o jsonpath='{.spec.mtls.mode}' 2>/dev/null || echo "")
if [ "$MODE" = "STRICT" ]; then
  echo "✓ PeerAuthentication 'default' is STRICT"
else
  echo "✗ PeerAuthentication 'default' should exist with mtls.mode: STRICT (found: '$MODE')"
  FAILED=1
fi

if [ $FAILED -eq 0 ]; then
  echo ""
  echo "All checks passed! ✓"
else
  echo ""
  echo "Some checks failed. Review and try again."
  exit 1
fi
