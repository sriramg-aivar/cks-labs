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

Namespace `locked-down` enforces the `restricted` Pod Security Standard, and Deployment
`noncompliant-app` is failing to create pods because it violates that standard.

Fix the Deployment's pod template so it satisfies `restricted` PSS. That means: run as
non-root, disallow privilege escalation, drop ALL capabilities, and set the seccomp
profile to the runtime default.

Do NOT modify the namespace labels — fix the workload.

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
