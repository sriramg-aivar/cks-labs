# Solution: Scenario 16

Edit `/etc/kubernetes/manifests/kube-apiserver.yaml`, ensure:
```
--anonymous-auth=false
--authorization-mode=Node,RBAC
--enable-admission-plugins=NodeRestriction,...   # add NodeRestriction if missing
```
Save — kubelet auto-restarts the static pod. Verify:
```bash
kubectl get pods -n kube-system | grep apiserver
kubectl auth can-i get pods --as=system:anonymous   # should be "no"
```
