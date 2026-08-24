# Scenario 5: Container security context (immutability)

## Test BEFORE fix
```bash
# Deployment has insecure settings
kubectl get deployment immutable-app -o jsonpath='{.spec.template.spec.containers[0].securityContext}'
# Shows: runAsUser:0, readOnlyRootFilesystem:false, allowPrivilegeEscalation:true
```

## Task

Edit Deployment `immutable-app` (namespace `default`) container securityContext:
```yaml
securityContext:
  runAsUser: 30000
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
```

Use: `kubectl edit deployment immutable-app`

## Test AFTER fix
```bash
# runAsUser should be 30000
kubectl get deployment immutable-app -o jsonpath='{.spec.template.spec.containers[0].securityContext.runAsUser}'
# Should show: 30000

# readOnlyRootFilesystem should be true
kubectl get deployment immutable-app -o jsonpath='{.spec.template.spec.containers[0].securityContext.readOnlyRootFilesystem}'
# Should show: true

# allowPrivilegeEscalation should be false
kubectl get deployment immutable-app -o jsonpath='{.spec.template.spec.containers[0].securityContext.allowPrivilegeEscalation}'
# Should show: false
```
