#!/usr/bin/env bash
set -euo pipefail
docker exec cks-lab-control-plane bash -c '
  sed -i "/--admission-control-config-file/d" /etc/kubernetes/manifests/kube-apiserver.yaml || true
  sed -i "s/,ImagePolicyWebhook//; s/ImagePolicyWebhook,//; s/ImagePolicyWebhook//" /etc/kubernetes/manifests/kube-apiserver.yaml || true
  rm -rf /etc/kubernetes/imagepolicy
'
rm -f "$(dirname "$0")"/admission-config.yaml "$(dirname "$0")"/webhook-kubeconfig.yaml
echo "Done. Also double check /etc/kubernetes/manifests/kube-apiserver.yaml enable-admission-plugins list looks sane."
