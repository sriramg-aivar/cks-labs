#!/usr/bin/env bash
set -euo pipefail

# ─── Auto-install trivy if not present ─────────────────────────────
if ! command -v trivy &>/dev/null; then
  echo "Installing trivy..."
  curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v0.55.0
  echo "✓ trivy installed"
else
  echo "✓ trivy already installed"
fi

# ─── Create the vulnerable workload ────────────────────────────────
kubectl create namespace shop --dry-run=client -o yaml | kubectl apply -f -
kubectl -n shop create deployment storefront --image=nginx:1.19 --port=80 --dry-run=client -o yaml | kubectl apply -f -
kubectl -n shop rollout status deployment/storefront --timeout=60s 2>/dev/null || true

echo ""
echo "Setup complete:"
echo "  - trivy installed"
echo "  - Namespace 'shop' with Deployment 'storefront' running vulnerable image nginx:1.19"
echo ""
echo "Your task: scan the image, then update the deployment to a patched image."
