# Scenario 5: Container security context (immutability)

## Test BEFORE fix
```bash
# Deployment has insecure settings
kubectl get deployment immutable-app -o jsonpath='{.spec.template.spec.containers[0].securityContext}'
# Shows: runAsUser:0, readOnlyRootFilesystem:false, allowPrivilegeEscalation:true
```

## Task

Edit Deployment `immutable-app` (namespace `default`) so its container securityContext
enforces immutability:
- runs as UID `30000`
- read-only root filesystem
- privilege escalation not allowed

Use `kubectl edit deployment immutable-app`.

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
