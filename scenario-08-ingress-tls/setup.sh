#!/usr/bin/env bash
set -euo pipefail

# ─── Auto-install ingress-nginx controller if not present ──────────
if ! kubectl get ns ingress-nginx &>/dev/null || ! kubectl -n ingress-nginx get deploy ingress-nginx-controller &>/dev/null; then
  echo "Installing ingress-nginx controller (this takes 1-2 minutes)..."
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.2/deploy/static/provider/baremetal/deploy.yaml
  echo "Waiting for ingress-nginx controller to be ready..."
  kubectl -n ingress-nginx wait --for=condition=Ready pod \
    -l app.kubernetes.io/component=controller --timeout=180s 2>/dev/null || \
    echo "⚠ Controller still starting — it should be ready shortly."
else
  echo "✓ ingress-nginx controller already installed"
fi

# ─── Create the scenario workload ──────────────────────────────────
kubectl create namespace web-ns --dry-run=client -o yaml | kubectl apply -f -
kubectl -n web-ns create deployment web --image=nginx:1.25 --port=80 --dry-run=client -o yaml | kubectl apply -f -
kubectl -n web-ns expose deployment web --port=80 --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true

# Generate a self-signed cert and create the TLS secret
WORKDIR=$(mktemp -d)
openssl req -x509 -nodes -newkey rsa:2048 -keyout "$WORKDIR/tls.key" -out "$WORKDIR/tls.crt" \
  -days 365 -subj "/CN=web.example.com" 2>/dev/null
kubectl -n web-ns create secret tls web-tls --cert="$WORKDIR/tls.crt" --key="$WORKDIR/tls.key" \
  --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "Setup complete:"
echo "  - Namespace 'web-ns' with Deployment 'web' + Service 'web' (port 80)"
echo "  - TLS secret 'web-tls' created"
echo "  - ingress-nginx controller running"
echo ""
echo "Your task: create the Ingress (no Ingress exists yet)."
