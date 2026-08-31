#!/usr/bin/env bash
set -euo pipefail

# Work directory OUTSIDE the repo
WORKDIR="${HOME:-/root}/cks-work/scenario-03"
mkdir -p "$WORKDIR"

cat > "$WORKDIR/Dockerfile" << 'DOCKERFILE'
FROM nginx:1.25
COPY ./app /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
DOCKERFILE

cat > "$WORKDIR/deployment.yaml" << 'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hardened-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels: {app: hardened-app}
  template:
    metadata:
      labels: {app: hardened-app}
    spec:
      containers:
        - name: app
          image: nginx:1.25
          securityContext:
            runAsUser: 0
            readOnlyRootFilesystem: false
            privileged: true
YAML
kubectl apply -f "$WORKDIR/deployment.yaml"

echo ""
echo "Setup complete. Files are in: $WORKDIR"
echo "  - $WORKDIR/Dockerfile     (runs as root — fix it)"
echo "  - $WORKDIR/deployment.yaml (insecure securityContext — fix it)"
echo ""
echo "Edit both, then: kubectl apply -f $WORKDIR/deployment.yaml"
