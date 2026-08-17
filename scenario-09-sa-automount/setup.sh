#!/usr/bin/env bash
set -euo pipefail
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: restricted-sa
  namespace: default
automountServiceAccountToken: true
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: token-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels: {app: token-app}
  template:
    metadata:
      labels: {app: token-app}
    spec:
      serviceAccountName: restricted-sa
      containers:
        - name: app
          image: nginx:1.25
YAML
echo "ServiceAccount 'restricted-sa' + Deployment 'token-app' applied (auto-mount ON)."
