# Scenario 16: API server authentication

## Before you start
```bash
# Check current apiserver flags
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep anonymous-auth
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep authorization-mode
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep enable-admission-plugins

# Try anonymous access (might work if broken)
kubectl auth can-i get pods --as=system:anonymous
```

## Task

Reconfigure kube-apiserver on the controlplane node:

1. Set `--anonymous-auth=false`
2. Set `--authorization-mode=Node,RBAC`
3. Ensure `NodeRestriction` is in `--enable-admission-plugins`

Edit: `/etc/kubernetes/manifests/kube-apiserver.yaml`

## Verify
```bash
# Wait for apiserver to restart (~30-60s)
sleep 40

# API server should be running
kubectl get pods -n kube-system | grep apiserver

# Check flags
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep anonymous-auth
# Should show: --anonymous-auth=false

cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep authorization-mode
# Should show: --authorization-mode=Node,RBAC

cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep enable-admission-plugins
# Should include NodeRestriction

# Anonymous access should be denied
kubectl auth can-i get pods --as=system:anonymous
# Should output: no

# Normal access should work
kubectl get nodes
```
