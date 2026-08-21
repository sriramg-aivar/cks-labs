# Scenario 9: Disable API credential auto-mounting

## Before you start
```bash
# Check the ServiceAccount
kubectl get sa restricted-sa -o yaml
kubectl get sa restricted-sa -o jsonpath='{.automountServiceAccountToken}'

# Check the deployment
kubectl get deployment token-app -o yaml | grep -A5 serviceAccount
kubectl get deployment token-app -o yaml | grep -A20 volumes

# Check if token is currently auto-mounted in the pod
kubectl exec deploy/token-app -- ls /var/run/secrets/kubernetes.io/serviceaccount/
```

## Task

1. Patch ServiceAccount `restricted-sa` (namespace `default`):
   - Set `automountServiceAccountToken: false`

2. Edit Deployment `token-app` to manually mount the token via a **projected volume**:
   - `automountServiceAccountToken: false` on the pod spec
   - Add a projected volume with: serviceAccountToken, configMap `kube-root-ca.crt`, and downwardAPI namespace
   - Mount it read-only at `/var/run/secrets/kubernetes.io/serviceaccount`

## Verify
```bash
# ServiceAccount should have automount disabled
kubectl get sa restricted-sa -o jsonpath='{.automountServiceAccountToken}'
# Should output: false

# Deployment should have automountServiceAccountToken: false
kubectl get deployment token-app -o yaml | grep automountServiceAccountToken

# Pod should have the projected volume
kubectl get deployment token-app -o yaml | grep -A15 'projected'

# Token should still be accessible inside the pod (manually mounted)
kubectl exec deploy/token-app -- ls /var/run/secrets/kubernetes.io/serviceaccount/
# Should show: ca.crt  namespace  token
```
