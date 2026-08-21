# Solution: Scenario 7

## NetworkPolicy YAML
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-allow-team-b
  namespace: team-a
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Ingress
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: team-b
```
Apply: `kubectl apply -f netpol.yaml`

## Verify
```bash
# Policy exists
kubectl -n team-a get networkpolicy

# Traffic from team-b WORKS
kubectl -n team-b exec frontend -- wget -qO- --timeout=3 backend.team-a.svc.cluster.local

# Traffic from other namespaces BLOCKED
kubectl run test --rm -it --image=busybox:1.36 --restart=Never -- wget -qO- --timeout=3 backend.team-a.svc.cluster.local
# ^ Should timeout
```

## Exam tips
- `kubernetes.io/metadata.name` label is auto-set on all namespaces — use it for namespace selection
- `policyTypes: [Ingress]` with a specific `from` rule = deny-all-except
- An empty `ingress: []` would deny ALL ingress (no exceptions)
- If no podSelector labels: policy applies to ALL pods in namespace
