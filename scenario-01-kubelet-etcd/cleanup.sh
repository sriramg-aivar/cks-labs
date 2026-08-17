#!/usr/bin/env bash
set -euo pipefail
echo "Restoring kubelet/etcd to secure defaults..."
sed -i 's/enabled: true/enabled: false/' /var/lib/kubelet/config.yaml 2>/dev/null || true
sed -i 's/mode: AlwaysAllow/mode: Webhook/' /var/lib/kubelet/config.yaml 2>/dev/null || true
systemctl restart kubelet
sed -i 's/--client-cert-auth=false/--client-cert-auth=true/' /etc/kubernetes/manifests/etcd.yaml 2>/dev/null || true
echo "Done."
