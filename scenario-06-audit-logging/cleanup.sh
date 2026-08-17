#!/usr/bin/env bash
set -euo pipefail
docker exec cks-lab-control-plane bash -c '
  sed -i "/--audit-/d" /etc/kubernetes/manifests/kube-apiserver.yaml || true
  rm -f /etc/kubernetes/audit-policy.yaml
  rm -rf /var/log/kubernetes/audit
'
rm -f "$(dirname "$0")"/audit-policy.yaml
echo "Note: also manually remove any audit-policy/audit-log volumes+volumeMounts you added"
echo "to kube-apiserver.yaml if sed didn't catch them, then confirm the apiserver pod restarts clean:"
echo "  kubectl get pods -n kube-system | grep apiserver"
