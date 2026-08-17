#!/usr/bin/env bash
set -euo pipefail
echo "Breaking kubelet config on cks-lab-control-plane..."
docker exec cks-lab-control-plane bash -c '
  sed -i "s/anonymous-auth=false/anonymous-auth=true/" /var/lib/kubelet/config.yaml 2>/dev/null || true
  # kind uses config.yaml (KubeletConfiguration), not flags, for most kubelets:
  if grep -q "anonymous:" /var/lib/kubelet/config.yaml; then
    sed -i "s/enabled: false/enabled: true/" /var/lib/kubelet/config.yaml
  fi
  if grep -q "mode: Webhook" /var/lib/kubelet/config.yaml; then
    sed -i "s/mode: Webhook/mode: AlwaysAllow/" /var/lib/kubelet/config.yaml
  fi
  systemctl restart kubelet
'
echo "Also setting etcd client-cert-auth=false (bonus part)"
docker exec cks-lab-control-plane bash -c '
  sed -i "s/--client-cert-auth=true/--client-cert-auth=false/" /etc/kubernetes/manifests/etcd.yaml
'
echo "Done. kubelet & etcd on control-plane node are now insecure. Fix via:"
echo "  docker exec -it cks-lab-control-plane bash"
echo "  vi /var/lib/kubelet/config.yaml   # then: systemctl restart kubelet"
echo "  vi /etc/kubernetes/manifests/etcd.yaml"
