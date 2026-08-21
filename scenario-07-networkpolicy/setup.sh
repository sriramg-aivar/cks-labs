#!/usr/bin/env bash
set -euo pipefail

kubectl create namespace team-a --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace team-b --dry-run=client -o yaml | kubectl apply -f -
kubectl label namespace team-b kubernetes.io/metadata.name=team-b --overwrite

# Create backend pod + service in team-a
kubectl -n team-a run backend --image=nginx:1.25 --labels=app=backend --port=80 --dry-run=client -o yaml | kubectl apply -f -
kubectl -n team-a expose pod backend --port=80 --target-port=80 --dry-run=client -o yaml | kubectl apply -f -

# Create frontend pod in team-b
kubectl -n team-b run frontend --image=busybox:1.36 --labels=app=frontend --command --dry-run=client -o yaml -- sleep 3600 | kubectl apply -f -

# Wait for pods to be ready
kubectl -n team-a wait --for=condition=Ready pod/backend --timeout=60s
kubectl -n team-b wait --for=condition=Ready pod/frontend --timeout=60s

echo ""
echo "Setup complete:"
echo "  - team-a: pod/backend + svc/backend (port 80)"
echo "  - team-b: pod/frontend (busybox)"
echo ""
echo "Test connectivity: kubectl -n team-b exec frontend -- wget -qO- --timeout=2 backend.team-a.svc.cluster.local"
