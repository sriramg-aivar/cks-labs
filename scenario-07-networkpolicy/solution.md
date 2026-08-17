# Solution: Scenario 7

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

Apply with `kubectl apply -f -`. This both denies all ingress by default (empty rule set
would deny everything; here we scope the one allowed `from`) and allows only team-b.

Verify:
```bash
kubectl -n team-b exec frontend -- wget -qO- --timeout=2 backend.team-a
kubectl -n default run test --rm -it --image=busybox:1.36 -- wget -qO- --timeout=2 backend.team-a.svc.cluster.local
```
(second command should time out / fail)

Note: kind's default CNI is `kindnet`, which does NOT enforce NetworkPolicies out of the
box. Install Calico or Cilium on the cluster first if you want policies to actually be
enforced — otherwise this scenario only tests whether you can *write* the correct YAML.
See `cluster/README` note below.
