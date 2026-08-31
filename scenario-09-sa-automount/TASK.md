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

Harden ServiceAccount token mounting in namespace `default`:

1. Disable automatic token mounting on ServiceAccount `restricted-sa`.
2. Edit Deployment `token-app` so it does NOT auto-mount the token, but instead mounts
   the API credentials manually via a read-only projected volume (token + CA cert +
   namespace) at the standard serviceaccount mount path.

The token must still be present inside the pod — just mounted explicitly, not automatically.

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
