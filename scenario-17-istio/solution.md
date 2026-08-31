# Solution: Scenario 17

## Step 1: Label the namespace for sidecar injection
```bash
kubectl label namespace payments istio-injection=enabled --overwrite
```

## Step 2: Restart the deployment so the sidecar is injected
```bash
kubectl -n payments rollout restart deployment api
kubectl -n payments rollout status deployment api
```
(Injection only happens at pod creation time — existing pods need a restart.)

## Step 3: Create STRICT PeerAuthentication
```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: security.istio.io/v1
kind: PeerAuthentication
metadata:
  name: default
  namespace: payments
spec:
  mtls:
    mode: STRICT
YAML
```

## Test AFTER fix
```bash
kubectl get ns payments --show-labels                       # istio-injection=enabled
kubectl -n payments get pod -l app=api -o jsonpath='{.items[0].spec.containers[*].name}'  # api istio-proxy
kubectl -n payments get peerauthentication default -o jsonpath='{.spec.mtls.mode}'         # STRICT
```

## Exam tips
- `istio-injection=enabled` on a NAMESPACE = every new pod there gets the `istio-proxy` sidecar automatically
- Injection happens at pod creation — **you must restart existing deployments** to inject them
- `PeerAuthentication` with `mtls.mode: STRICT` = workloads only accept mTLS traffic (reject plaintext)
- Modes: `STRICT` (mTLS only), `PERMISSIVE` (both mTLS + plaintext), `DISABLE` (no mTLS)
- Name `default` + namespace scope = applies to ALL workloads in that namespace
- Mesh-wide STRICT = PeerAuthentication named `default` in the `istio-system` namespace
- API version: `security.istio.io/v1` (older clusters: `security.istio.io/v1beta1`)
