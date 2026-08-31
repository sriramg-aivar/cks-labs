# Scenario 16: API server authentication

## Test BEFORE fix
```bash
# Anonymous auth is enabled (BAD)
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep anonymous-auth
# Shows: --anonymous-auth=true

# Authorization is AlwaysAllow (BAD)
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep authorization-mode
# Shows: --authorization-mode=AlwaysAllow

# NodeRestriction is missing from admission plugins
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep enable-admission-plugins
# Shows: no NodeRestriction
```

## Task

Secure the kube-apiserver by editing `/etc/kubernetes/manifests/kube-apiserver.yaml`:

1. Disable anonymous authentication.
2. Set the authorization mode to Node,RBAC.
3. Enable the NodeRestriction admission controller.

The API server is a static pod — saving the manifest restarts it automatically.

## Test AFTER fix
```bash
# Wait for apiserver restart
sleep 40

# Apiserver running
kubectl get pods -n kube-system | grep apiserver
# Should show: Running

# Anonymous auth disabled
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep anonymous-auth
# Should show: --anonymous-auth=false

# Authorization mode correct
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep authorization-mode
# Should show: --authorization-mode=Node,RBAC

# NodeRestriction in admission plugins
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep enable-admission-plugins
# Should contain: NodeRestriction

# Anonymous access denied
kubectl auth can-i get pods --as=system:anonymous
# Should show: no
```
