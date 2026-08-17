# Scenario 5: Container security context (immutability)

Deployment `immutable-app` (namespace `default`) is applied but not compliant. Edit it so
the container has:
```
runAsUser: 30000
readOnlyRootFilesystem: true
allowPrivilegeEscalation: false
```
