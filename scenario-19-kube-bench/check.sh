#!/usr/bin/env bash
set -euo pipefail
echo "Checking kube-bench CIS 4.1.9 fix..."

FAILED=0

# Check file permissions are 600 or stricter
PERMS=$(stat -c "%a" /var/lib/kubelet/config.yaml 2>/dev/null || echo "999")
if [ "$PERMS" = "600" ] || [ "$PERMS" = "400" ] || [ "$PERMS" = "640" ]; then
  echo "✓ /var/lib/kubelet/config.yaml permissions are $PERMS (600 or stricter)"
else
  echo "✗ /var/lib/kubelet/config.yaml is $PERMS — should be 600 or more restrictive"
  echo "  Fix: chmod 600 /var/lib/kubelet/config.yaml"
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
