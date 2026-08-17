#!/usr/bin/env bash
set -euo pipefail
cat > audit-policy.yaml << 'YAML'
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
  - level: Metadata
YAML
docker cp audit-policy.yaml cks-lab-control-plane:/etc/kubernetes/audit-policy.yaml
docker exec cks-lab-control-plane mkdir -p /var/log/kubernetes/audit
echo "audit-policy.yaml copied to /etc/kubernetes/ on the control-plane node."
echo "Now edit /etc/kubernetes/manifests/kube-apiserver.yaml inside the node to wire it up."
echo "  docker exec -it cks-lab-control-plane bash"
