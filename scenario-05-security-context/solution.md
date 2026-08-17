# Solution: Scenario 5

```bash
kubectl edit deployment immutable-app -n default
```
Set:
```yaml
securityContext:
  runAsUser: 30000
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
```
Verify: `kubectl get pod -n default -l app=immutable-app -o yaml | grep -A3 securityContext`

Note: with `readOnlyRootFilesystem: true`, nginx will actually crashloop unless you also
mount writable emptyDirs for `/var/cache/nginx`, `/var/run`, etc. — the exam usually only
grades the securityContext fields, but it's worth knowing why the pod might not go Ready.
