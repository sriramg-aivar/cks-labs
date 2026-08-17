# Solution: Scenario 14

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
      # no `authentication` block = no mutual auth required for host traffic
```

Apply with: `kubectl apply -f cnp.yaml`

Key ideas to remember for the exam:
- `authentication.mode: required` on an ingress rule is how Cilium expresses "mutual auth
  required" (needs Cilium's mutual-auth feature / SPIRE enabled on the cluster).
- `fromEntities: [host]` is the special selector for "the node itself", and omitting the
  `authentication` block on that rule means no mTLS is enforced for it.
- CiliumNetworkPolicy is namespaced (like NetworkPolicy) — apply it in the same namespace
  as the workload.

Note: On the CKS exam, Cilium is the CNI and CiliumNetworkPolicy is fully enforced.
In this lab, only the CRD is installed (for YAML validation). The policy structure
and syntax is exactly what the exam tests.
