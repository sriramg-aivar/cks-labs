#!/usr/bin/env bash
set -euo pipefail
echo "Restoring kubelet/etcd to secure defaults..."
docker exec cks-lab-control-plane bash -c '
  sed -i "s/enabled: true/enabled: false/" /var/lib/kubelet/config.yaml || true
  sed -i "s/mode: AlwaysAllow/mode: Webhook/" /var/lib/kubelet/config.yaml || true
  systemctl restart kubelet
  sed -i "s/--client-cert-auth=false/--client-cert-auth=true/" /etc/kubernetes/manifests/etcd.yaml
'
echo "Done."
