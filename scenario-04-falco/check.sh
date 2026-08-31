#!/usr/bin/env bash
set -euo pipefail
echo "Checking Falco configuration..."

FAILED=0

# Detect which config path is in use
if [ -f /etc/falco/rules.d/custom-rules.yaml ]; then
  RULES_FILE="/etc/falco/rules.d/custom-rules.yaml"
  CONFIG_FILE="/etc/falco/falco.yaml"
else
  RULES_FILE="/opt/falco/rules.d/custom-rules.yaml"
  CONFIG_FILE="/opt/falco/falco.yaml"
fi

RULES=$(cat "$RULES_FILE" 2>/dev/null || echo "")
CONFIG=$(cat "$CONFIG_FILE" 2>/dev/null || echo "")

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

if echo "$CONFIG" | grep -q 'json_output: true'; then
  echo "✓ JSON output enabled"
else
  echo "✗ json_output should be true in $CONFIG_FILE"
  FAILED=1
fi

# Bonus: if falco is installed, validate the rules file syntax
if command -v falco &>/dev/null; then
  if falco -V "$RULES_FILE" >/dev/null 2>&1; then
    echo "✓ falco -V validates the rules file (valid syntax)"
  else
    echo "⚠ falco -V reports the rules file has syntax issues (run: falco -V $RULES_FILE)"
  fi
fi

if [ $FAILED -eq 0 ]; then
  echo ""
  echo "All checks passed! ✓"
else
  echo ""
  echo "Some checks failed. Review and try again."
  exit 1
fi
