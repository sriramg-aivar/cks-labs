# Solution: Scenario 14

## CiliumNetworkPolicy YAML
```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: secure-svc-policy
  namespace: svc-ns
spec:
  endpointSelector:
    matchLabels:
      app: secure-svc
  ingress:
    - fromEndpoints:
        - matchLabels:
            k8s:io.kubernetes.pod.namespace: client-ns
      authentication:
        mode: "required"
    - fromEntities:
        - host
```
Apply: `kubectl apply -f cnp.yaml`

## Verify
```bash
kubectl -n svc-ns get ciliumnetworkpolicy
kubectl -n svc-ns get ciliumnetworkpolicy secure-svc-policy -o yaml | grep -A1 authentication
kubectl -n svc-ns get ciliumnetworkpolicy secure-svc-policy -o yaml | grep -A1 fromEntities
```

## Exam tips
- `authentication.mode: "required"` = mutual TLS required for that rule
- `fromEntities: [host]` = allow from the node itself (no mTLS)
- Omitting `authentication` block = no mTLS requirement
- CiliumNetworkPolicy is namespaced — same namespace as workload
- `k8s:io.kubernetes.pod.namespace` is how Cilium selects by namespace
- On CKS exam: Cilium is the CNI, CiliumNetworkPolicy is fully enforced
