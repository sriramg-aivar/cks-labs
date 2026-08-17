#!/usr/bin/env bash
set -euo pipefail
kubectl create namespace web-ns --dry-run=client -o yaml | kubectl apply -f -
kubectl -n web-ns create deployment web --image=nginx:1.25 --port=80
kubectl -n web-ns expose deployment web --port=80

WORKDIR=$(mktemp -d)
openssl req -x509 -nodes -newkey rsa:2048 -keyout "$WORKDIR/tls.key" -out "$WORKDIR/tls.crt" \
  -days 365 -subj "/CN=web.example.com" 2>/dev/null
kubectl -n web-ns create secret tls web-tls --cert="$WORKDIR/tls.crt" --key="$WORKDIR/tls.key"

echo "NOTE: this scenario assumes an ingress-nginx controller is installed."
echo "If not installed yet, run:"
echo "  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.2/deploy/static/provider/kind/deploy.yaml"
echo "  kubectl -n ingress-nginx wait --for=condition=Ready pod -l app.kubernetes.io/component=controller --timeout=180s"
echo "Deployment, Service, and TLS secret 'web-tls' are ready in namespace 'web-ns'. Now write the Ingress."
