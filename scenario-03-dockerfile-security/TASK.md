# Scenario 3: Dockerfile security

## Test BEFORE fix
```bash
# Dockerfile runs as root (no USER line)
cat Dockerfile | grep -i USER
# Shows nothing — runs as root!

# Deployment has insecure securityContext
kubectl get deployment hardened-app -o jsonpath='{.spec.template.spec.containers[0].securityContext}'
# Shows: runAsUser:0, privileged:true, readOnlyRootFilesystem:false
```

## Task

1. Fix `Dockerfile` — add `USER nobody`
2. Fix Deployment `hardened-app` securityContext:
```yaml
securityContext:
  runAsUser: 65535
  readOnlyRootFilesystem: true
  privileged: false
```
Then apply: `kubectl apply -f deployment.yaml`

## Test AFTER fix
```bash
# Dockerfile should have USER nobody
grep 'USER nobody' Dockerfile
# Should match

# Deployment securityContext should be secure
kubectl get deployment hardened-app -o jsonpath='{.spec.template.spec.containers[0].securityContext.runAsUser}'
# Should show: 65535

kubectl get deployment hardened-app -o jsonpath='{.spec.template.spec.containers[0].securityContext.readOnlyRootFilesystem}'
# Should show: true

kubectl get deployment hardened-app -o jsonpath='{.spec.template.spec.containers[0].securityContext.privileged}'
# Should show: false
```
