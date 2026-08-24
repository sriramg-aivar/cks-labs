# Scenario 9: Disable API credential auto-mounting

## Test BEFORE fix
```bash
# ServiceAccount has automount enabled (or not set = defaults to true)
kubectl get sa restricted-sa -o jsonpath='{.automountServiceAccountToken}'
# Shows: true (or empty = defaults true)

# Token is auto-mounted in the pod
kubectl exec deploy/token-app -- ls /var/run/secrets/kubernetes.io/serviceaccount/
# Shows: ca.crt namespace token (auto-mounted by kubelet)

# No projected volume in deployment
kubectl get deployment token-app -o yaml | grep projected
# Shows nothing
```

## Task

1. Patch ServiceAccount `restricted-sa`:
   - Set `automountServiceAccountToken: false`

2. Edit Deployment `token-app`:
   - Set `automountServiceAccountToken: false` in pod spec
   - Add a **projected volume** to manually mount the token:
     - serviceAccountToken (path: token, expirationSeconds: 3607)
     - configMap `kube-root-ca.crt` (key: ca.crt, path: ca.crt)
     - downwardAPI (path: namespace, fieldRef: metadata.namespace)
   - Mount it read-only at `/var/run/secrets/kubernetes.io/serviceaccount`

## Test AFTER fix
```bash
# SA automount disabled
kubectl get sa restricted-sa -o jsonpath='{.automountServiceAccountToken}'
# Should show: false

# Deployment has automount false
kubectl get deployment token-app -o yaml | grep 'automountServiceAccountToken'
# Should show: false

# Projected volume exists
kubectl get deployment token-app -o yaml | grep 'projected'
# Should match

# Token still accessible in pod (manually mounted)
kubectl exec deploy/token-app -- ls /var/run/secrets/kubernetes.io/serviceaccount/
# Should show: ca.crt namespace token
```
