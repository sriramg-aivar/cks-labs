#!/usr/bin/env bash
set -euo pipefail

# ─── Ensure a Cilium IngressClass exists ───────────────────────────
# On CKS Killercoda the CNI is Cilium. Cilium can act as the ingress controller.
# Enable ingressController on Cilium if not already, and make sure the 'cilium'
# IngressClass is present so the Ingress can reference it.
if ! kubectl get ingressclass cilium &>/dev/null; then
  echo "Setting up Cilium ingress controller..."

  # Try enabling via cilium-cli if available
  if command -v cilium &>/dev/null; then
    cilium config set enable-ingress-controller true 2>/dev/null || true
    cilium config set enable-l7-proxy true 2>/dev/null || true
    kubectl -n kube-system rollout restart deployment cilium-operator 2>/dev/null || true
    kubectl -n kube-system rollout restart ds cilium 2>/dev/null || true
    sleep 5
  fi

  # Ensure the IngressClass object exists (create it explicitly if Cilium didn't)
  if ! kubectl get ingressclass cilium &>/dev/null; then
    cat <<'YAML' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: cilium
spec:
  controller: cilium.io/ingress-controller
YAML
  fi
  echo "✓ Cilium IngressClass 'cilium' ready"
else
  echo "✓ Cilium IngressClass already present"
fi

# ─── Create the scenario workload ──────────────────────────────────
kubectl create namespace web-ns --dry-run=client -o yaml | kubectl apply -f -
kubectl -n web-ns create deployment web --image=nginx:1.25 --port=80 --dry-run=client -o yaml | kubectl apply -f -
kubectl -n web-ns expose deployment web --port=80 --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true

# Generate a self-signed cert and create the TLS secret
WORKDIR="${HOME:-/root}/cks-work/scenario-08"
mkdir -p "$WORKDIR"
openssl req -x509 -nodes -newkey rsa:2048 -keyout "$WORKDIR/tls.key" -out "$WORKDIR/tls.crt" \
  -days 365 -subj "/CN=web.example.com" 2>/dev/null
kubectl -n web-ns create secret tls web-tls --cert="$WORKDIR/tls.crt" --key="$WORKDIR/tls.key" \
  --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "Setup complete:"
echo "  - Namespace 'web-ns' with Deployment 'web' + Service 'web' (port 80)"
echo "  - TLS secret 'web-tls' created"
echo "  - Cilium IngressClass 'cilium' available"
echo ""
echo "Your task: create the Ingress using the Cilium ingress class (no Ingress exists yet)."
