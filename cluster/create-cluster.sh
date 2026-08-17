#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Creating kind cluster 'cks-lab' (control-plane + worker, CNI disabled)..."
kind create cluster --name cks-lab --config "$SCRIPT_DIR/kind-config.yaml"

echo ""
echo "Installing Calico CNI..."
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/custom-resources.yaml

echo "Waiting for Calico pods to be ready (this may take 1-2 minutes)..."
kubectl wait --for=condition=Ready pods --all -n calico-system --timeout=300s 2>/dev/null || true
kubectl wait --for=condition=Ready nodes --all --timeout=300s

echo ""
echo "Installing Cilium CRDs (for scenario 14 - CiliumNetworkPolicy)..."
kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/v1.16.0/pkg/k8s/apis/cilium.io/client/crds/v2/ciliumnetworkpolicies.yaml 2>/dev/null || \
  kubectl apply -f "$SCRIPT_DIR/cilium-crd.yaml" 2>/dev/null || \
  echo "Note: Cilium CRD install skipped (will be installed during scenario 14 setup if needed)"

echo ""
echo "Done. Context is 'kind-cks-lab'."
kubectl get nodes -o wide

cat <<'MSG'

Cluster ready with Calico CNI (NetworkPolicies are enforced!).

Tip: for scenarios that edit kube-apiserver flags or the audit policy (1, 6, 15, 16),
you'll be editing files INSIDE the control-plane container:

  docker exec -it cks-lab-control-plane bash
  vi /etc/kubernetes/manifests/kube-apiserver.yaml

Saving that file triggers the kubelet on that node to restart the static pod automatically
(usually within ~30-60s). Watch it with:

  kubectl get pods -n kube-system -w | grep apiserver
MSG
