#!/usr/bin/env bash
set -euo pipefail
echo "Breaking kubelet config on controlplane..."

# Break kubelet anonymous auth
if grep -q "anonymous:" /var/lib/kubelet/config.yaml; then
  sed -i 's/enabled: false/enabled: true/' /var/lib/kubelet/config.yaml
fi
if grep -q "mode: Webhook" /var/lib/kubelet/config.yaml; then
  sed -i 's/mode: Webhook/mode: AlwaysAllow/' /var/lib/kubelet/config.yaml
fi
systemctl restart kubelet

# Break etcd client-cert-auth
sed -i 's/--client-cert-auth=true/--client-cert-auth=false/' /etc/kubernetes/manifests/etcd.yaml

echo ""
echo "Done. kubelet & etcd on controlplane are now insecure."
echo "Fix: /var/lib/kubelet/config.yaml (then systemctl restart kubelet)"
echo "Fix: /etc/kubernetes/manifests/etcd.yaml"
