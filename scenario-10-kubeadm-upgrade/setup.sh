#!/usr/bin/env bash
set -euo pipefail

# Detect current cluster version
CURRENT_VERSION=$(kubectl get nodes -o jsonpath='{.items[0].status.nodeInfo.kubeletVersion}' | sed 's/v//')
MAJOR=$(echo $CURRENT_VERSION | cut -d. -f1)
MINOR=$(echo $CURRENT_VERSION | cut -d. -f2)
TARGET_MINOR=$((MINOR + 1))
TARGET_VERSION="${MAJOR}.${TARGET_MINOR}.0"

echo "Current cluster version: v${CURRENT_VERSION}"
echo "Target upgrade version: v${TARGET_VERSION}"
echo ""

# Create workload pods to make drain meaningful
kubectl create deployment drain-test --image=nginx:1.25 --replicas=3 --dry-run=client -o yaml | kubectl apply -f -
kubectl wait --for=condition=Available deployment/drain-test --timeout=60s 2>/dev/null || true

# Store version info for check script
echo "$TARGET_VERSION" > /tmp/.upgrade-target-version

echo ""
echo "Deployment 'drain-test' created with 3 replicas."
echo ""
echo "Worker node: node01"
echo "Upgrade FROM: v${CURRENT_VERSION}"
echo "Upgrade TO:   v${TARGET_VERSION}"
echo ""
echo "Your task:"
echo "  1. Drain node01"
echo "  2. Write upgrade commands to /tmp/upgrade-commands.txt"
echo "  3. Uncordon node01"
