#!/usr/bin/env bash
set -euo pipefail
sed -i 's/--anonymous-auth=true/--anonymous-auth=false/' /etc/kubernetes/manifests/kube-apiserver.yaml 2>/dev/null || true
sed -i 's/--authorization-mode=AlwaysAllow/--authorization-mode=Node,RBAC/' /etc/kubernetes/manifests/kube-apiserver.yaml 2>/dev/null || true
# Re-add NodeRestriction if missing
if ! grep -q 'NodeRestriction' /etc/kubernetes/manifests/kube-apiserver.yaml; then
  sed -i 's/--enable-admission-plugins=/--enable-admission-plugins=NodeRestriction,/' /etc/kubernetes/manifests/kube-apiserver.yaml 2>/dev/null || true
fi
echo "Restored. Wait for apiserver to restart (~30s)."
