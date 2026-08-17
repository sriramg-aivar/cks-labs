#!/usr/bin/env bash
set -euo pipefail

# Create some workload pods on the worker node to make drain meaningful
kubectl create deployment drain-test --image=nginx:1.25 --replicas=3
kubectl wait --for=condition=Available deployment/drain-test --timeout=60s

echo "Deployment 'drain-test' created with 3 replicas spread across nodes."
echo ""
echo "Your task: perform a worker node upgrade procedure."
echo "1. Drain the worker node"
echo "2. Write the upgrade commands to /tmp/upgrade-commands.txt"
echo "3. Uncordon the worker node"
