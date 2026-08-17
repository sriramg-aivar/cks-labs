#!/usr/bin/env bash
set -euo pipefail
kubectl create namespace secure --dry-run=client -o yaml | kubectl apply -f -

WORKDIR=$(mktemp -d)
openssl req -x509 -nodes -newkey rsa:2048 -keyout "$WORKDIR/tls.key" -out "$WORKDIR/tls.crt" \
  -days 365 -subj "/CN=web-app.secure.svc.cluster.local" 2>/dev/null
cp "$WORKDIR/tls.crt" "$WORKDIR/tls.key" .
echo "Generated tls.crt / tls.key in this folder — you'll use these to create the secret."

cat <<'YAML' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: secure
spec:
  replicas: 1
  selector:
    matchLabels: {app: web-app}
  template:
    metadata:
      labels: {app: web-app}
    spec:
      containers:
        - name: web
          image: nginx:1.25
          volumeMounts:
            - name: tls
              mountPath: /etc/nginx/tls
              readOnly: true
      volumes:
        - name: tls
          secret:
            secretName: web-tls
YAML
echo "Deployment applied. Pod will be stuck until you create secret 'web-tls' in namespace 'secure'."
