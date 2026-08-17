#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Verifying kubeadm cluster is ready..."
if ! kubectl get nodes &>/dev/null; then
  echo "ERROR: kubectl cannot reach the cluster. Make sure you're on the controlplane node."
  exit 1
fi

echo ""
kubectl get nodes -o wide

# Ensure Calico is running (Killercoda CKS playgrounds have it by default)
echo ""
if kubectl get pods -n kube-system -l k8s-app=calico-node 2>/dev/null | grep -q Running; then
  echo "✓ Calico CNI is running (NetworkPolicies enforced)"
elif kubectl get pods -n calico-system 2>/dev/null | grep -q Running; then
  echo "✓ Calico CNI is running (NetworkPolicies enforced)"
else
  echo "⚠ Calico not detected. Installing..."
  kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml
  echo "Waiting for Calico to be ready..."
  kubectl wait --for=condition=Ready pods -l k8s-app=calico-node -n kube-system --timeout=120s 2>/dev/null || true
fi

# Install Cilium CRDs for scenario 14
echo ""
echo "Installing Cilium CRDs (for scenario 14 - CiliumNetworkPolicy)..."
kubectl apply -f "$SCRIPT_DIR/cilium-crd.yaml" 2>/dev/null && echo "✓ Cilium CRDs installed" || echo "⚠ Cilium CRD install skipped"

echo ""
echo "═══════════════════════════════════════════════════"
echo "  Cluster ready! Run ../cks.sh to start studying"
echo "═══════════════════════════════════════════════════"
echo ""
echo "Nodes:"
echo "  controlplane — you are here"
echo "  node01       — ssh node01"
echo ""
echo "Key paths:"
echo "  /var/lib/kubelet/config.yaml"
echo "  /etc/kubernetes/manifests/kube-apiserver.yaml"
echo "  /etc/kubernetes/manifests/etcd.yaml"
