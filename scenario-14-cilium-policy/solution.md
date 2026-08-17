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

Key ideas to remember for the exam:
- `authentication.mode: required` on an ingress rule is how Cilium expresses "mutual auth
  required" (needs Cilium's mutual-auth feature / SPIRE enabled on the cluster).
- `fromEntities: [host]` is the special selector for "the node itself", and omitting the
  `authentication` block on that rule means no mTLS is enforced for it.

**Setting up a Cilium-enabled kind cluster** (only if you want to actually test this):
```bash
cat > cilium-kind-config.yaml <<'YAML'
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
nodes:
  - role: control-plane
  - role: worker
YAML
kind create cluster --name cks-cilium --config cilium-kind-config.yaml
cilium install --version 1.16.0   # requires cilium-cli installed
cilium status --wait
```
