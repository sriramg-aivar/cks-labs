# Scenario 7: NetworkPolicy

## Before you start
```bash
# Check namespaces and pods
kubectl get ns team-a team-b
kubectl -n team-a get pods --show-labels
kubectl -n team-b get pods --show-labels

# Test current connectivity (should work — no policies yet)
kubectl -n team-b exec frontend -- wget -qO- --timeout=2 backend.team-a.svc.cluster.local

# Check existing NetworkPolicies (should be none)
kubectl -n team-a get networkpolicy
```

## Task

Namespace `team-a` has pod `backend` and namespace `team-b` has pod `frontend`.
Currently all traffic is allowed.

Create a NetworkPolicy in namespace `team-a` so that:
1. All ingress traffic to `backend` is denied by default
2. Ingress is allowed ONLY from pods in namespace `team-b`

## Verify
```bash
# NetworkPolicy should exist
kubectl -n team-a get networkpolicy

# Traffic from team-b should WORK
kubectl -n team-b exec frontend -- wget -qO- --timeout=3 backend.team-a.svc.cluster.local

# Traffic from default namespace should FAIL (timeout)
kubectl run test-pod --rm -it --image=busybox:1.36 --restart=Never -- wget -qO- --timeout=3 backend.team-a.svc.cluster.local
# ^ This should timeout/fail
```
