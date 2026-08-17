#!/usr/bin/env bash
set -euo pipefail
cat <<'YAML' | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: locked-down
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/enforce-version: latest
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: noncompliant-app
  namespace: locked-down
spec:
  replicas: 1
  selector:
    matchLabels: {app: noncompliant-app}
  template:
    metadata:
      labels: {app: noncompliant-app}
    spec:
      containers:
        - name: app
          image: nginx:1.25
          securityContext:
            privileged: true
YAML
echo "Namespace enforces 'restricted' PSS. Deployment applied but pods will fail to be admitted."
kubectl -n locked-down get events --field-selector reason=FailedCreate 2>/dev/null || true
