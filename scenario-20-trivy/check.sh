#!/usr/bin/env bash
set -euo pipefail
echo "Checking trivy scenario..."

FAILED=0

IMAGE=$(kubectl -n shop get deployment storefront -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || echo "")

if [ "$IMAGE" = "nginx:1.19" ]; then
  echo "✗ Deployment still uses the vulnerable image nginx:1.19"
  echo "  Fix: kubectl -n shop set image deployment/storefront nginx=nginx:1.27"
  FAILED=1
elif [ -z "$IMAGE" ]; then
  echo "✗ Could not read the storefront deployment image"
  FAILED=1
else
  echo "✓ Deployment image updated to: $IMAGE (no longer nginx:1.19)"
fi

# Pod should be running
if kubectl -n shop get pods 2>/dev/null | grep -q Running; then
  echo "✓ storefront pod is Running"
else
  echo "✗ storefront pod is not Running yet"
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
