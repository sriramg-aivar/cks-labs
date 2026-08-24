# Scenario 14: Cilium Network Policy

## Test BEFORE fix
```bash
# Namespaces and deployment exist
kubectl get ns svc-ns client-ns
kubectl -n svc-ns get deployment secure-svc

# No CiliumNetworkPolicy yet
kubectl -n svc-ns get ciliumnetworkpolicy
# Shows: No resources found
```

## Task

Write a `CiliumNetworkPolicy` (apiVersion: `cilium.io/v2`) in namespace `svc-ns`:

1. Select pods with label `app: secure-svc`
2. Allow ingress from namespace `client-ns` WITH `authentication.mode: "required"` (mTLS)
3. Allow ingress from host (`fromEntities: [host]`) WITHOUT mutual auth

Apply with: `kubectl apply -f cnp.yaml`

## Test AFTER fix
```bash
# CiliumNetworkPolicy should exist
kubectl -n svc-ns get ciliumnetworkpolicy
# Should show: secure-svc-policy

# Should have authentication mode
kubectl -n svc-ns get cnp secure-svc-policy -o yaml | grep -A1 'authentication'
# Should show: mode: "required"

# Should have fromEntities host
kubectl -n svc-ns get cnp secure-svc-policy -o yaml | grep -A1 'fromEntities'
# Should show: - host
```
