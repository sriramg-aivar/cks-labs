#!/usr/bin/env bash
set -euo pipefail

# ─── Auto-install kube-bench if not present ────────────────────────
if ! command -v kube-bench &>/dev/null; then
  echo "Installing kube-bench..."
  KB_VERSION="0.7.3"
  ARCH=$(uname -m)
  case "$ARCH" in
    x86_64) KB_ARCH="amd64" ;;
    aarch64|arm64) KB_ARCH="arm64" ;;
    *) KB_ARCH="amd64" ;;
  esac
  TMP=$(mktemp -d)
  curl -sL "https://github.com/aquasecurity/kube-bench/releases/download/v${KB_VERSION}/kube-bench_${KB_VERSION}_linux_${KB_ARCH}.tar.gz" | tar xz -C "$TMP"
  cp "$TMP/kube-bench" /usr/local/bin/kube-bench
  chmod +x /usr/local/bin/kube-bench
  # kube-bench needs its cfg directory
  mkdir -p /etc/kube-bench
  cp -r "$TMP/cfg" /etc/kube-bench/cfg 2>/dev/null || true
  echo "✓ kube-bench installed"
else
  echo "✓ kube-bench already installed"
fi

# ─── Break the kubelet config file permissions (CIS 4.1.9) ─────────
chmod 644 /var/lib/kubelet/config.yaml

echo ""
echo "Setup complete:"
echo "  - kube-bench installed"
echo "  - /var/lib/kubelet/config.yaml set to 644 (INSECURE — fails CIS 4.1.9)"
echo ""
echo "Your task: run kube-bench, find the failing kubelet config permission check, and fix it."
