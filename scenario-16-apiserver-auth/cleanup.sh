#!/usr/bin/env bash
set -euo pipefail
docker exec cks-lab-control-plane bash -c '
  sed -i "s/--anonymous-auth=true/--anonymous-auth=false/" /etc/kubernetes/manifests/kube-apiserver.yaml || true
  sed -i "s/--authorization-mode=AlwaysAllow/--authorization-mode=Node,RBAC/" /etc/kubernetes/manifests/kube-apiserver.yaml || true
  sed -i "s/--enable-admission-plugins=/--enable-admission-plugins=NodeRestriction,/" /etc/kubernetes/manifests/kube-apiserver.yaml || true
'
echo "Restored (best-effort). Confirm apiserver pod is healthy:"
echo "  kubectl get pods -n kube-system | grep apiserver"
