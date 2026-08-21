# Solution: Scenario 16

## Edit `/etc/kubernetes/manifests/kube-apiserver.yaml`

Ensure these flags:
```yaml
- --anonymous-auth=false
- --authorization-mode=Node,RBAC
- --enable-admission-plugins=NodeRestriction
```

## Verify
```bash
# Wait for restart
sleep 40
kubectl get pods -n kube-system | grep apiserver

# Check flags
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep anonymous-auth
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep authorization-mode
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep admission-plugins

# Anonymous should be denied
kubectl auth can-i get pods --as=system:anonymous
# Should output: no

# Normal access works
kubectl get nodes
```

## Exam tips
- `--anonymous-auth=false` — disables unauthenticated access
- `--authorization-mode=Node,RBAC` — Node for kubelet, RBAC for everything else
- Order matters: Node MUST come before RBAC
- `NodeRestriction` admission — limits what kubelets can modify (only their own node/pods)
- If you break apiserver: check `/var/log/pods/` for error logs
