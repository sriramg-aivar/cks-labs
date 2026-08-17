#!/usr/bin/env bash
set -euo pipefail

cat > admission-config.yaml << 'YAML'
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

cat > webhook-kubeconfig.yaml << 'YAML'
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

docker exec cks-lab-control-plane mkdir -p /etc/kubernetes/imagepolicy
docker cp admission-config.yaml cks-lab-control-plane:/etc/kubernetes/imagepolicy/admission-config.yaml
docker cp webhook-kubeconfig.yaml cks-lab-control-plane:/etc/kubernetes/imagepolicy/kubeconfig.yaml

echo "Files copied to /etc/kubernetes/imagepolicy/ on control-plane node (defaultAllow: true — WRONG, fail-open)."
echo "Fix admission-config.yaml's defaultAllow and wire kube-apiserver.yaml to use it."
