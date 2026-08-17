#!/usr/bin/env bash
set -euo pipefail
echo "Checking kubeadm upgrade procedure..."

FAILED=0

# Check node is uncordoned
if kubectl get node node01 2>/dev/null | grep -q ' Ready'; then
  if kubectl get node node01 | grep -q 'SchedulingDisabled'; then
    echo "✗ Worker node is still cordoned — run: kubectl uncordon node01"
    FAILED=1
  else
    echo "✓ Worker node is Ready and schedulable"
  fi
else
  echo "✗ Worker node is not Ready"
  FAILED=1
fi

# Check commands file
if [ -f /tmp/upgrade-commands.txt ]; then
  echo "✓ /tmp/upgrade-commands.txt exists"

  CMDS=$(cat /tmp/upgrade-commands.txt)

  if echo "$CMDS" | grep -q 'kubeadm upgrade node'; then
    echo "✓ Contains 'kubeadm upgrade node'"
  else
    echo "✗ Should contain 'kubeadm upgrade node' (worker node command)"
    FAILED=1
  fi

  if echo "$CMDS" | grep -q 'apt-get.*kubeadm\|apt.*install.*kubeadm'; then
    echo "✓ Contains kubeadm package upgrade"
  else
    echo "✗ Should upgrade kubeadm package first"
    FAILED=1
  fi

  if echo "$CMDS" | grep -q 'apt-get.*kubelet\|apt.*install.*kubelet'; then
    echo "✓ Contains kubelet package upgrade"
  else
    echo "✗ Should upgrade kubelet package"
    FAILED=1
  fi

  if echo "$CMDS" | grep -q 'systemctl.*restart.*kubelet'; then
    echo "✓ Contains kubelet restart"
  else
    echo "✗ Should restart kubelet after upgrade"
    FAILED=1
  fi

  if echo "$CMDS" | grep -q 'daemon-reload'; then
    echo "✓ Contains daemon-reload"
  else
    echo "✗ Should run systemctl daemon-reload before restarting kubelet"
    FAILED=1
  fi
else
  echo "✗ /tmp/upgrade-commands.txt not found"
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
