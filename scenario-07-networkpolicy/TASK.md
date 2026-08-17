# Scenario 7: NetworkPolicy

Namespace `team-a` has pod `backend` and namespace `team-b` has pod `frontend`. Currently
all traffic is allowed. Create NetworkPolicy(s) in `team-a` so that:
- All ingress traffic to `backend` is denied by default
- Ingress is allowed ONLY from pods within namespace `team-b`
