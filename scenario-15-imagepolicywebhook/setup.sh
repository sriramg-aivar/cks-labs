#!/usr/bin/env bash
set -euo pipefail

mkdir -p /etc/kubernetes/imagepolicy

# Admission config (deliberately wrong: defaultAllow: true = fail-open)
cat > /etc/kubernetes/imagepolicy/admission-config.yaml <<'YAML'
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
  - name: ImagePolicyWebhook
    configuration:
      imagePolicy:
        kubeConfigFile: /etc/kubernetes/imagepolicy/kubeconfig.yaml
        allowTTL: 50
        denyTTL: 50
        retryBackoff: 500
        defaultAllow: true
YAML

# Webhook kubeconfig
cat > /etc/kubernetes/imagepolicy/kubeconfig.yaml <<'YAML'
apiVersion: v1
kind: Config
clusters:
  - name: image-checker
    cluster:
      server: https://image-checker.example.com/authorize
users:
  - name: api-server
current-context: image-checker
contexts:
  - context:
      cluster: image-checker
      user: api-server
    name: image-checker
YAML

echo "Files created at /etc/kubernetes/imagepolicy/"
echo "  admission-config.yaml  (defaultAllow: true — WRONG, this is fail-open!)"
echo "  kubeconfig.yaml"
echo ""
echo "Fix admission-config.yaml and wire kube-apiserver.yaml to use ImagePolicyWebhook."
