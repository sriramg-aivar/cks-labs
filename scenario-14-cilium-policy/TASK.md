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

Write and apply a CiliumNetworkPolicy in namespace `svc-ns` that protects the
`secure-svc` workload (label `app: secure-svc`):

1. Allow ingress from pods in namespace `client-ns`, requiring mutual authentication (mTLS).
2. Allow ingress from the host itself, WITHOUT requiring mutual authentication.

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
