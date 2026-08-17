#!/usr/bin/env bash
set -euo pipefail
sed -i '/--audit-/d' /etc/kubernetes/manifests/kube-apiserver.yaml 2>/dev/null || true
rm -f /etc/kubernetes/audit-policy.yaml
rm -rf /var/log/kubernetes/audit
echo "Note: also manually remove any audit-policy/audit-log volumes+volumeMounts"
echo "from kube-apiserver.yaml, then wait for apiserver to restart cleanly."
echo "Done."
