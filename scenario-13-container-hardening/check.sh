#!/usr/bin/env bash
set -euo pipefail
echo "Checking container hardening configuration..."

FAILED=0

# Check daemon.json
CONFIG=$(docker exec cks-lab-control-plane cat /opt/docker/daemon.json 2>/dev/null)

if echo "$CONFIG" | grep -q '"icc".*false'; then
  echo "✓ icc disabled"
else
  echo "✗ icc should be false"
  FAILED=1
fi

if echo "$CONFIG" | grep -q '"userns-remap".*"default"'; then
  echo "✓ userns-remap set to default"
else
  echo "✗ userns-remap should be set to \"default\""
  FAILED=1
fi

if echo "$CONFIG" | grep -q '"no-new-privileges".*true'; then
  echo "✓ no-new-privileges enabled"
else
  echo "✗ no-new-privileges should be true"
  FAILED=1
fi

if echo "$CONFIG" | grep -q '"live-restore".*true'; then
  echo "✓ live-restore enabled"
else
  echo "✗ live-restore should be true"
  FAILED=1
fi

# Check fix-permissions.sh
FIX=$(docker exec cks-lab-control-plane cat /opt/docker/fix-permissions.sh 2>/dev/null)

if echo "$FIX" | grep -q 'chown root:root'; then
  echo "✓ fix-permissions.sh sets correct ownership"
else
  echo "✗ fix-permissions.sh should chown root:root the socket"
  FAILED=1
fi

if echo "$FIX" | grep -q 'chmod 660\|chmod 0660'; then
  echo "✓ fix-permissions.sh sets correct mode"
else
  echo "✗ fix-permissions.sh should chmod 660 the socket"
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
