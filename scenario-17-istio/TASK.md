# Scenario 17: Istio Sidecar Injection & Strict mTLS

## Test BEFORE fix
```bash
# The namespace 'payments' exists but is NOT labeled for injection
kubectl get ns payments --show-labels

# The pod in 'payments' has only 1 container (no Istio sidecar)
kubectl -n payments get pods
kubectl -n payments get pod -l app=api -o jsonpath='{.items[0].spec.containers[*].name}'
# Shows: api   (only one container, no istio-proxy)
```

## Task

The team runs a workload in namespace `payments` and wants it on the Istio mesh with
strict security.

1. Enable **automatic sidecar injection** for the `payments` namespace
   (Istio injects the `istio-proxy` sidecar into every pod in a labeled namespace).

2. Restart the existing `api` deployment so the sidecar gets injected.

3. Create a **PeerAuthentication** named `default` in namespace `payments` that enforces
   **STRICT** mutual TLS for all workloads in that namespace.

Resources involved:
- Namespace: `payments`
- Deployment: `api` (already running)
- Istio is already installed in the `istio-system` namespace.

## Test AFTER fix
```bash
# Namespace should have the injection label
kubectl get ns payments --show-labels
# Should show: istio-injection=enabled

# The api pod should now have 2 containers (api + istio-proxy)
kubectl -n payments get pod -l app=api -o jsonpath='{.items[0].spec.containers[*].name}'
# Should show: api istio-proxy

# PeerAuthentication should exist and be STRICT
kubectl -n payments get peerauthentication
kubectl -n payments get peerauthentication default -o jsonpath='{.spec.mtls.mode}'
# Should show: STRICT
```
