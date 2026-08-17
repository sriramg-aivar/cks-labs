#!/usr/bin/env bash
set -euo pipefail
cat <<'YAML' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: multi-arch-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels: {app: multi-arch-app}
  template:
    metadata:
      labels: {app: multi-arch-app}
    spec:
      containers:
        - name: side-a
          image: alpine:3.19.1
          command: ["sleep", "3600"]
        - name: side-b
          image: alpine:3.18.4
          command: ["sleep", "3600"]
YAML
echo "Deployment applied with two alpine images (3.19.1 and 3.18.4)."
echo "Install bom if you haven't: go install sigs.k8s.io/bom/cmd/bom@latest  (needs Go + internet)"
echo "Or: docker run --rm -v /var/run/docker.sock:/var/run/docker.sock ... (check bom docs for a container option)"
echo "Then run e.g.: bom generate --image alpine:3.19.1 --output alpine-3191.spdx"
echo "              bom generate --image alpine:3.18.4 --output alpine-3184.spdx"
echo "and grep each .spdx file for libcrypto3."
