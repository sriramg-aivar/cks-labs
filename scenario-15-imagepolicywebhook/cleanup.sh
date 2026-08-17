#!/usr/bin/env bash
set -euo pipefail
sed -i '/--admission-control-config-file/d' /etc/kubernetes/manifests/kube-apiserver.yaml 2>/dev/null || true
sed -i 's/,ImagePolicyWebhook//; s/ImagePolicyWebhook,//; s/ImagePolicyWebhook//' /etc/kubernetes/manifests/kube-apiserver.yaml 2>/dev/null || true
rm -rf /etc/kubernetes/imagepolicy
echo "Done. Verify apiserver is healthy: kubectl get pods -n kube-system | grep apiserver"
