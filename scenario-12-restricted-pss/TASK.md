# Scenario 12: Restricted Pod Security Standard

## Test BEFORE fix
```bash
# Namespace enforces restricted PSS
kubectl get ns locked-down -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/enforce}'
# Shows: restricted

# Deployment exists but pods FAIL to be created
kubectl -n locked-down get deployment noncompliant-app
kubectl -n locked-down get pods
# Shows: 0 pods (none created)

# ReplicaSet shows WHY pods fail
kubectl -n locked-down describe rs | grep -A2 Warning
# Shows: violates PodSecurity "restricted"
```

## Task

Fix Deployment `noncompliant-app` in namespace `locked-down` to satisfy `restricted` PSS:

Pod-level securityContext:
```yaml
securityContext:
  runAsNonRoot: true
  seccompProfile:
    type: RuntimeDefault
```

Container-level securityContext:
```yaml
securityContext:
  allowPrivilegeEscalation: false
  runAsNonRoot: true
  runAsUser: 1000
  capabilities:
    drop: ["ALL"]
```

Do NOT modify namespace labels.

## Test AFTER fix
```bash
# Pods should now be created and running
kubectl -n locked-down get pods
# Should show: Running

# Deployment should be Available
kubectl -n locked-down get deployment noncompliant-app
# AVAILABLE should be >= 1

# No more PSS violations
kubectl -n locked-down describe rs | grep Warning
# Should show nothing (or old events only)
```
