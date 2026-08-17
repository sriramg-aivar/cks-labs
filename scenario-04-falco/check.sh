#!/usr/bin/env bash
set -euo pipefail
echo "Checking Falco configuration..."

FAILED=0

# Check rules file
RULES=$(docker exec cks-lab-control-plane cat /opt/falco/rules.d/custom-rules.yaml 2>/dev/null)
if echo "$RULES" | grep -q 'Read sensitive file shadow'; then
  echo "✓ Rule name correct"
else
  echo "✗ Rule name should be 'Read sensitive file shadow'"
  FAILED=1
fi

if echo "$RULES" | grep -qi '/etc/shadow'; then
  echo "✓ Rule targets /etc/shadow"
else
  echo "✗ Rule should detect access to /etc/shadow"
  FAILED=1
fi

if echo "$RULES" | grep -qi 'WARNING'; then
  echo "✓ Priority is WARNING"
else
  echo "✗ Priority should be WARNING"
  FAILED=1
fi

if echo "$RULES" | grep -q 'open_read'; then
  echo "✓ Condition uses open_read"
else
  echo "✗ Condition should use 'open_read' for read detection"
  FAILED=1
fi

# Check falco.yaml
CONFIG=$(docker exec cks-lab-control-plane cat /opt/falco/falco.yaml 2>/dev/null)
if echo "$CONFIG" | grep -q 'json_output: true'; then
  echo "✓ JSON output enabled"
else
  echo "✗ json_output should be true in falco.yaml"
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
