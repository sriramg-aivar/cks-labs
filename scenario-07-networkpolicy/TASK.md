# Scenario 7: NetworkPolicy

## Test BEFORE fix
```bash
# No NetworkPolicy exists
kubectl -n team-a get networkpolicy
# Shows: No resources found

# Traffic from team-b to backend WORKS (should be blocked later)
kubectl -n team-b exec frontend -- wget -qO- --timeout=3 backend.team-a.svc.cluster.local
# Shows: nginx HTML (traffic allowed — BAD, no policy)

# Traffic from default namespace ALSO works (should be blocked later)
kubectl run test --rm -it --image=busybox:1.36 --restart=Never -- wget -qO- --timeout=3 backend.team-a.svc.cluster.local
# Also returns HTML (all traffic allowed — BAD)
```

## Task

Create a NetworkPolicy in namespace `team-a` so that:
1. All ingress to pod `backend` is denied by default.
2. Ingress is allowed ONLY from pods in namespace `team-b`.

Traffic from `team-b` must keep working; traffic from any other namespace must be blocked.

## Test AFTER fix
```bash
# NetworkPolicy exists
kubectl -n team-a get networkpolicy
# Should show your policy

# Traffic from team-b STILL WORKS (allowed by policy)
kubectl -n team-b exec frontend -- wget -qO- --timeout=3 backend.team-a.svc.cluster.local
# Should show: nginx HTML

# Traffic from default namespace is BLOCKED
kubectl run test --rm -it --image=busybox:1.36 --restart=Never -- wget -qO- --timeout=3 backend.team-a.svc.cluster.local
# Should TIMEOUT (blocked by policy)
```
