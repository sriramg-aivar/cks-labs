# Scenario 3: Dockerfile security best practices

## Before you start
```bash
# Check the current Dockerfile
cat /root/Dockerfile 2>/dev/null || cat Dockerfile

# Check the deployment's current securityContext
kubectl get deployment hardened-app -o yaml | grep -A10 securityContext

# Check if pods are running
kubectl get pods -l app=hardened-app
```

## Task

1. A Dockerfile at `/root/Dockerfile` currently runs as root. Add `USER nobody` to it.

2. Fix the Deployment `hardened-app` (namespace `default`) so its container securityContext has:
```yaml
securityContext:
  runAsUser: 65535
  readOnlyRootFilesystem: true
  privileged: false
```

(You don't need to build the image — just fix the Dockerfile and Deployment YAML.)

## Verify
```bash
# Dockerfile should have USER nobody
grep -i 'USER nobody' /root/Dockerfile

# Deployment should have correct securityContext
kubectl get deployment hardened-app -o yaml | grep -A5 securityContext

# Check runAsUser is 65535
kubectl get deployment hardened-app -o jsonpath='{.spec.template.spec.containers[0].securityContext}'
```
