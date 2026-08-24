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

Edit `/etc/kubernetes/manifests/kube-apiserver.yaml`:

1. Set `--anonymous-auth=false`
2. Set `--authorization-mode=Node,RBAC`
3. Add `NodeRestriction` to `--enable-admission-plugins`

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
