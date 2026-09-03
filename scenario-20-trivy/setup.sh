#!/usr/bin/env bash
set -euo pipefail

# ─── Auto-install trivy if not present ─────────────────────────────
if ! command -v trivy &>/dev/null; then
  echo "Installing trivy..."
  ARCH=$(uname -m)
  case "$ARCH" in
    x86_64)        TRIVY_ARCH="Linux-64bit" ;;
    aarch64|arm64) TRIVY_ARCH="Linux-ARM64" ;;
    *)             TRIVY_ARCH="Linux-64bit" ;;
  esac
  # Resolve latest version dynamically (fallback to known-good)
  TRIVY_VERSION=$(curl -sL https://api.github.com/repos/aquasecurity/trivy/releases/latest \
    | grep -m1 '"tag_name"' | sed -E 's/.*"v?([^"]+)".*/\1/')
  [ -z "$TRIVY_VERSION" ] && TRIVY_VERSION="0.55.0"

  TMP=$(mktemp -d)
  TARBALL="trivy_${TRIVY_VERSION}_${TRIVY_ARCH}.tar.gz"
  if curl -sSfL "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/${TARBALL}" -o "$TMP/trivy.tar.gz"; then
    tar xzf "$TMP/trivy.tar.gz" -C "$TMP"
    mv "$TMP/trivy" /usr/local/bin/trivy
    chmod +x /usr/local/bin/trivy
    echo "✓ trivy ${TRIVY_VERSION} installed"
  else
    echo "⚠ Direct download failed, trying official install script..."
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin || \
      echo "⚠ trivy install failed — check network connectivity."
  fi
  rm -rf "$TMP"
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
