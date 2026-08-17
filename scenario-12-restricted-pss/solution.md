# Solution: Scenario 12

`restricted` PSS requires (among other things): no privileged containers, no host
namespaces, `allowPrivilegeEscalation: false`, `runAsNonRoot: true`, a restricted
seccomp profile, and dropping all capabilities. Fix the pod template:

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
Apply, then check the pod actually got created:
```bash
kubectl -n locked-down get pods
kubectl -n locked-down describe deployment noncompliant-app | grep -A5 Conditions
```
