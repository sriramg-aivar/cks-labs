#!/usr/bin/env bash
set -euo pipefail
docker exec cks-lab-control-plane bash -c '
  sed -i "s/--anonymous-auth=false/--anonymous-auth=true/" /etc/kubernetes/manifests/kube-apiserver.yaml || true
  sed -i "s/--authorization-mode=Node,RBAC/--authorization-mode=AlwaysAllow/" /etc/kubernetes/manifests/kube-apiserver.yaml || true
  sed -i "s/NodeRestriction,//; s/,NodeRestriction//; s/NodeRestriction//" /etc/kubernetes/manifests/kube-apiserver.yaml || true
'
echo "kube-apiserver on control-plane weakened (anonymous-auth=true, authz=AlwaysAllow, NodeRestriction removed)."
echo "Fix via: docker exec -it cks-lab-control-plane vi /etc/kubernetes/manifests/kube-apiserver.yaml"
