#!/usr/bin/env bash
set -euo pipefail

if ! kubectl get pods -n kube-system -l k8s-app=cilium 2>/dev/null | grep -q cilium; then
  cat <<'MSG'
Cilium is NOT installed on this cluster yet. This scenario needs Cilium as the CNI
(kindnet, kind's default, does not support CiliumNetworkPolicy / mutual auth).

To set this up properly you'd want a SEPARATE kind cluster created with the default CNI
disabled, then Cilium installed via Helm/cilium-cli. That's a bigger one-time step —
see cluster/cilium-cluster/ for a ready-made config once you're ready, or practice this
one on Killercoda's Cilium-flavored playgrounds instead, since spinning up a second
Cilium-enabled kind cluster just for this one scenario is heavy for a single question.
MSG
  exit 0
fi

kubectl create namespace svc-ns --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace client-ns --dry-run=client -o yaml | kubectl apply -f -
kubectl -n svc-ns create deployment secure-svc --image=nginx:1.25 --port=80
echo "Namespaces + Deployment created. Write your CiliumNetworkPolicy now."
