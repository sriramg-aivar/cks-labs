#!/usr/bin/env bash
set -euo pipefail

# Create audit policy file
cat > /etc/kubernetes/audit-policy.yaml <<'YAML'
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
  - level: Metadata
YAML

mkdir -p /var/log/kubernetes/audit

echo "audit-policy.yaml created at /etc/kubernetes/audit-policy.yaml"
echo "Now edit /etc/kubernetes/manifests/kube-apiserver.yaml to wire it up."
echo ""
echo "Add flags: --audit-policy-file, --audit-log-path, --audit-log-maxbackup"
echo "Add volumes + volumeMounts for the policy file and log directory."
