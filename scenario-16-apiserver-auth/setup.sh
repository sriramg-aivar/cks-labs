#!/usr/bin/env bash
set -euo pipefail

sed -i 's/--anonymous-auth=false/--anonymous-auth=true/' /etc/kubernetes/manifests/kube-apiserver.yaml 2>/dev/null || true
sed -i 's/--authorization-mode=Node,RBAC/--authorization-mode=AlwaysAllow/' /etc/kubernetes/manifests/kube-apiserver.yaml 2>/dev/null || true
# Remove NodeRestriction from admission plugins
sed -i 's/NodeRestriction,//; s/,NodeRestriction//; s/NodeRestriction//' /etc/kubernetes/manifests/kube-apiserver.yaml 2>/dev/null || true

echo "kube-apiserver weakened:"
echo "  - anonymous-auth=true"
echo "  - authorization-mode=AlwaysAllow"
echo "  - NodeRestriction removed"
echo ""
echo "Fix: /etc/kubernetes/manifests/kube-apiserver.yaml"
