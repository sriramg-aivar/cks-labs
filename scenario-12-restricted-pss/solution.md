# Solution: Scenario 12

## Fix the Deployment
```yaml
spec:
  template:
    spec:
      securityContext:
        runAsNonRoot: true
        seccompProfile:
          type: RuntimeDefault
      containers:
        - name: app
          image: nginx:1.25
          securityContext:
            allowPrivilegeEscalation: false
            runAsNonRoot: true
            runAsUser: 1000
            capabilities:
              drop: ["ALL"]
```
Apply: `kubectl apply -f deployment.yaml` or `kubectl edit deployment -n locked-down noncompliant-app`

## Verify
```bash
# Pods should now be created
kubectl -n locked-down get pods

# Deployment should show available replicas
kubectl -n locked-down get deployment noncompliant-app

# Check events are clean
kubectl -n locked-down describe rs | tail -5
```

## Exam tips
- `restricted` PSS requires ALL of these:
  - Pod level: `runAsNonRoot: true`, `seccompProfile.type: RuntimeDefault`
  - Container level: `allowPrivilegeEscalation: false`, `capabilities.drop: ["ALL"]`
  - Must NOT have: `privileged: true`, hostNetwork, hostPID, hostIPC
- Check why pods fail: `kubectl describe rs <name>` shows the PSS violation message
- Don't touch namespace labels — fix the pod spec
