#!/usr/bin/env bash
set -euo pipefail
cat <<'YAML' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: immutable-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels: {app: immutable-app}
  template:
    metadata:
      labels: {app: immutable-app}
    spec:
      containers:
        - name: app
          image: nginx:1.25
          securityContext:
            runAsUser: 0
            readOnlyRootFilesystem: false
            allowPrivilegeEscalation: true
YAML
echo "Deployment 'immutable-app' applied (non-compliant). Fix with: kubectl edit deployment immutable-app"
