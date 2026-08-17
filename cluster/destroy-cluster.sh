#!/usr/bin/env bash
set -euo pipefail
echo "On Killercoda, the cluster is managed by the platform."
echo "To reset, simply restart the Killercoda scenario."
echo ""
echo "If running on your own VMs, use:"
echo "  kubeadm reset -f"
echo "  ssh node01 kubeadm reset -f"
