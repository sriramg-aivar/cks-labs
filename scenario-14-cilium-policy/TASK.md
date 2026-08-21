# Scenario 14: Cilium Network Policy

## Before you start
```bash
# Check namespaces
kubectl get ns svc-ns client-ns

# Check the deployment
kubectl -n svc-ns get deployment secure-svc
kubectl -n svc-ns get pods

# Check CiliumNetworkPolicy CRD is available
kubectl get crd ciliumnetworkpolicies.cilium.io

# Check existing policies (should be none)
kubectl -n svc-ns get ciliumnetworkpolicy 2>/dev/null || echo "no policies yet"
```

## Task

In namespace `svc-ns`, Deployment `secure-svc` should:
1. Be reachable by pods in namespace `client-ns` WITH mutual authentication (mTLS) required
2. Be reachable from the host itself WITHOUT requiring mutual auth

Write and apply a `CiliumNetworkPolicy` (apiVersion: `cilium.io/v2`) that expresses both rules.

Hints:
- Use `endpointSelector` to select the `secure-svc` pods
- Use `authentication.mode: "required"` for mTLS
- Use `fromEntities: [host]` for host access

## Verify
```bash
# CiliumNetworkPolicy should exist
kubectl -n svc-ns get ciliumnetworkpolicy

# Check the policy YAML
kubectl -n svc-ns get ciliumnetworkpolicy secure-svc-policy -o yaml

# Should have authentication mode required
kubectl -n svc-ns get ciliumnetworkpolicy secure-svc-policy -o yaml | grep -A1 authentication

# Should have fromEntities host
kubectl -n svc-ns get ciliumnetworkpolicy secure-svc-policy -o yaml | grep -A1 fromEntities
```
