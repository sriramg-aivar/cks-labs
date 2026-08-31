#!/usr/bin/env bash
set -euo pipefail

# ─── Auto-install Istio if not present ─────────────────────────────
if ! kubectl get ns istio-system &>/dev/null || ! kubectl -n istio-system get deploy istiod &>/dev/null; then
  echo "Istio not found. Installing Istio (this takes 1-2 minutes)..."

  # Download istioctl if missing
  if ! command -v istioctl &>/dev/null; then
    echo "Downloading istioctl..."
    ISTIO_VERSION="1.23.0"
    curl -sL "https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux-amd64.tar.gz" | tar xz -C /tmp
    export PATH="/tmp/istio-${ISTIO_VERSION}/bin:$PATH"
    # Make it available system-wide for later use
    cp "/tmp/istio-${ISTIO_VERSION}/bin/istioctl" /usr/local/bin/istioctl 2>/dev/null || true
  fi

  # Install Istio with demo profile
  istioctl install --set profile=demo -y

  echo "Waiting for istiod to be ready..."
  kubectl -n istio-system wait --for=condition=Available deployment/istiod --timeout=180s
else
  echo "✓ Istio is already installed"
fi

# ─── Create the scenario namespace + workload ──────────────────────
kubectl create namespace payments --dry-run=client -o yaml | kubectl apply -f -

# Make sure it's NOT labeled for injection (the task is to add it)
kubectl label namespace payments istio-injection- 2>/dev/null || true

# Deploy the api workload (no sidecar yet)
kubectl -n payments create deployment api --image=nginx:1.25 --port=80 --dry-run=client -o yaml | kubectl apply -f -
kubectl -n payments patch deployment api -p '{"spec":{"template":{"metadata":{"labels":{"app":"api"}}}}}'
kubectl -n payments rollout status deployment api --timeout=60s 2>/dev/null || true

# Remove any leftover PeerAuthentication from previous runs
kubectl -n payments delete peerauthentication --all --ignore-not-found --grace-period=0 --force 2>/dev/null || true

echo ""
echo "Setup complete:"
echo "  - Namespace 'payments' created (NOT yet labeled for injection)"
echo "  - Deployment 'api' running with 1 container (no sidecar)"
echo "  - Istio is installed in istio-system"
echo ""
echo "Your task: enable sidecar injection + create STRICT PeerAuthentication."
