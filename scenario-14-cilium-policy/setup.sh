#!/usr/bin/env bash
set -euo pipefail

# Ensure Cilium CRDs are installed
if ! kubectl get crd ciliumnetworkpolicies.cilium.io &>/dev/null; then
  echo "Installing Cilium CRDs..."
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  kubectl apply -f "$SCRIPT_DIR/../cluster/cilium-crd.yaml" 2>/dev/null || \
    kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/v1.16.0/pkg/k8s/apis/cilium.io/client/crds/v2/ciliumnetworkpolicies.yaml 2>/dev/null || \
    echo "WARNING: Could not install Cilium CRDs. The YAML won't apply."
fi

kubectl create namespace svc-ns --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace client-ns --dry-run=client -o yaml | kubectl apply -f -
kubectl -n svc-ns create deployment secure-svc --image=nginx:1.25 --port=80 --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "Namespaces + Deployment created."
echo "Write your CiliumNetworkPolicy for namespace svc-ns."
