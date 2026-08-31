#!/usr/bin/env bash
set -euo pipefail
# Restore secure permissions (the "fixed" state) so the cluster stays healthy
chmod 600 /var/lib/kubelet/config.yaml 2>/dev/null || true
echo "Done. (kubelet config restored to 600; kube-bench left installed for reuse)"
