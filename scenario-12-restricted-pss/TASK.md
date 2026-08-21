# Scenario 12: Restricted Pod Security Standard

## Before you start
```bash
# Check namespace labels (PSS enforcement)
kubectl get ns locked-down --show-labels

# Check deployment status (pods should be failing)
kubectl -n locked-down get deployment noncompliant-app
kubectl -n locked-down get replicaset
kubectl -n locked-down describe rs | grep -A5 Warning

# See current pod spec
kubectl -n locked-down get deployment noncompliant-app -o yaml | grep -A20 containers
```

## Task

Namespace `locked-down` enforces the `restricted` Pod Security Standard.
Deployment `noncompliant-app` is failing to create pods.

Fix the Deployment's pod spec to satisfy `restricted` PSS:
- `runAsNonRoot: true` (pod-level)
- `seccompProfile.type: RuntimeDefault` (pod-level)
- `allowPrivilegeEscalation: false` (container-level)
- `runAsNonRoot: true` (container-level)
- `runAsUser: 1000` (container-level)
- `capabilities.drop: ["ALL"]` (container-level)

Do NOT modify the namespace labels.

## Verify
```bash
# Pods should be created and running now
kubectl -n locked-down get pods

# Deployment should be Available
kubectl -n locked-down get deployment noncompliant-app

# Check securityContext is set correctly
kubectl -n locked-down get deployment noncompliant-app -o yaml | grep -A10 securityContext
```
