# Scenario 5: Container security context (immutability)

## Before you start
```bash
# Check current deployment securityContext
kubectl get deployment immutable-app -o yaml | grep -A10 securityContext

# Check if pods are running
kubectl get pods -l app=immutable-app

# Describe to see any issues
kubectl describe deployment immutable-app | tail -10
```

## Task

Deployment `immutable-app` (namespace `default`) is applied but not compliant.
Edit it so the container has:
```yaml
securityContext:
  runAsUser: 30000
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
```

## Verify
```bash
# Check the securityContext is correct
kubectl get deployment immutable-app -o jsonpath='{.spec.template.spec.containers[0].securityContext}' | python3 -m json.tool

# Or with grep
kubectl get deployment immutable-app -o yaml | grep -A5 securityContext

# Verify specific values
kubectl get deployment immutable-app -o jsonpath='{.spec.template.spec.containers[0].securityContext.runAsUser}'
# Should output: 30000
```
