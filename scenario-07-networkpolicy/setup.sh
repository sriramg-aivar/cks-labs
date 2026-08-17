#!/usr/bin/env bash
set -euo pipefail
kubectl create namespace team-a --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace team-b --dry-run=client -o yaml | kubectl apply -f -
kubectl label namespace team-b kubernetes.io/metadata.name=team-b --overwrite

kubectl -n team-a run backend --image=nginx:1.25 --labels=app=backend --port=80
kubectl -n team-b run frontend --image=busybox:1.36 --labels=app=frontend --command -- sleep 3600
echo "Namespaces + pods created (no NetworkPolicy yet — everything can reach 'backend')."
