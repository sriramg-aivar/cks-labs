#!/usr/bin/env bash
set -euo pipefail
cat > Dockerfile << 'DOCKERFILE'
FROM nginx:1.25
COPY ./app /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
DOCKERFILE

cat > deployment.yaml << 'YAML'
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
kubectl apply -f deployment.yaml
echo "Dockerfile and deployment.yaml created/applied (both insecure). Edit both files here, then:"
echo "  kubectl apply -f deployment.yaml"
