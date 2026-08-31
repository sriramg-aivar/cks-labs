#!/usr/bin/env bash
set -euo pipefail

# ─── Auto-install bom if not present ───────────────────────────────
if ! command -v bom &>/dev/null; then
  echo "Installing bom (SPDX SBOM tool)..."
  BOM_VERSION="0.6.0"
  ARCH=$(uname -m)
  case "$ARCH" in
    x86_64) BOM_ARCH="amd64" ;;
    aarch64|arm64) BOM_ARCH="arm64" ;;
    *) BOM_ARCH="amd64" ;;
  esac
  curl -sSfL "https://github.com/kubernetes-sigs/bom/releases/download/v${BOM_VERSION}/bom-linux-${BOM_ARCH}" -o /usr/local/bin/bom
  chmod +x /usr/local/bin/bom
  echo "✓ bom installed"
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
