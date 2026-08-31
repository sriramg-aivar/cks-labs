#!/usr/bin/env bash
set -euo pipefail

kubectl create namespace project-x --dry-run=client -o yaml | kubectl apply -f -
kubectl -n project-x create serviceaccount app-reader --dry-run=client -o yaml | kubectl apply -f -

# Create a sample pod so there's something to read
kubectl -n project-x run sample --image=nginx:1.25 --dry-run=client -o yaml | kubectl apply -f -

# Remove any Role/RoleBinding from previous runs (start clean)
kubectl -n project-x delete role pod-reader --ignore-not-found --grace-period=0 --force 2>/dev/null || true
kubectl -n project-x delete rolebinding app-reader-binding --ignore-not-found --grace-period=0 --force 2>/dev/null || true

echo ""
echo "Setup complete:"
echo "  - Namespace 'project-x' created"
echo "  - ServiceAccount 'app-reader' created (currently NO permissions)"
echo "  - Sample pod running"
echo ""
echo "Your task: grant app-reader least-privilege read access to pods only."
