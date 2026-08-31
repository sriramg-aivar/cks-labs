#!/usr/bin/env bash
set -euo pipefail
echo "Checking RBAC least-privilege..."

FAILED=0
SA="system:serviceaccount:project-x:app-reader"

check_allowed() {
  local verb=$1 res=$2 ns=$3
  if [ "$(kubectl auth can-i "$verb" "$res" --as="$SA" -n "$ns" 2>/dev/null)" = "yes" ]; then
    echo "✓ CAN $verb $res in $ns (correct)"
  else
    echo "✗ should be able to $verb $res in $ns"
    FAILED=1
  fi
}

check_denied() {
  local verb=$1 res=$2 ns=$3
  if [ "$(kubectl auth can-i "$verb" "$res" --as="$SA" -n "$ns" 2>/dev/null)" = "no" ]; then
    echo "✓ CANNOT $verb $res in $ns (correct)"
  else
    echo "✗ should NOT be able to $verb $res in $ns (too much access)"
    FAILED=1
  fi
}

# Should be allowed
check_allowed get pods project-x
check_allowed list pods project-x
check_allowed watch pods project-x

# Should be denied (least privilege)
check_denied delete pods project-x
check_denied create pods project-x
check_denied get secrets project-x
check_denied get pods default

if [ $FAILED -eq 0 ]; then
  echo ""
  echo "All checks passed! ✓"
else
  echo ""
  echo "Some checks failed. Review and try again."
  exit 1
fi
