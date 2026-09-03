#!/usr/bin/env bash
set -euo pipefail

# ─── Auto-install bom if not present ───────────────────────────────
if ! command -v bom &>/dev/null; then
  echo "Installing bom (SPDX SBOM tool)..."
  ARCH=$(uname -m)
  case "$ARCH" in
    x86_64) BOM_ARCH="amd64" ;;
    aarch64|arm64) BOM_ARCH="arm64" ;;
    *) BOM_ARCH="amd64" ;;
  esac
  # Resolve the latest release tag dynamically (falls back to a known-good version)
  BOM_VERSION=$(curl -sL https://api.github.com/repos/kubernetes-sigs/bom/releases/latest \
    | grep -m1 '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
  [ -z "$BOM_VERSION" ] && BOM_VERSION="v0.7.1"
  # Correct asset name format is: bom-<arch>-linux
  if curl -sSfL "https://github.com/kubernetes-sigs/bom/releases/download/${BOM_VERSION}/bom-${BOM_ARCH}-linux" -o /usr/local/bin/bom; then
    chmod +x /usr/local/bin/bom
    echo "✓ bom ${BOM_VERSION} installed"
  else
    echo "⚠ bom download failed — check network. URL tried: bom-${BOM_ARCH}-linux (${BOM_VERSION})"
  fi
else
  echo "✓ bom already installed"
fi

# Work directory OUTSIDE the repo for generated .spdx files
WORKDIR="${HOME:-/root}/cks-work/scenario-11"
mkdir -p "$WORKDIR"

cat <<'YAML' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: multi-arch-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels: {app: multi-arch-app}
  template:
    metadata:
      labels: {app: multi-arch-app}
    spec:
      containers:
        - name: side-a
          image: alpine:3.19.1
          command: ["sleep", "3600"]
        - name: side-b
          image: alpine:3.18.4
          command: ["sleep", "3600"]
YAML

echo ""
echo "Setup complete:"
echo "  - bom installed"
echo "  - Deployment 'multi-arch-app' with two alpine images (3.19.1, 3.18.4)"
echo "  - Work directory for .spdx files: $WORKDIR"
echo ""
echo "Generate SBOMs there, e.g.:"
echo "  cd $WORKDIR"
echo "  bom generate --image alpine:3.19.1 --output alpine-3191.spdx"
