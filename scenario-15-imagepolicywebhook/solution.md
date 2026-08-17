# Solution: Scenario 15

1. Fix `defaultAllow: true` → `defaultAllow: false` in `admission-config.yaml`, then re-copy
   it to the node:
```bash
docker cp admission-config.yaml cks-lab-control-plane:/etc/kubernetes/imagepolicy/admission-config.yaml
```

2. On the control-plane node, edit `/etc/kubernetes/manifests/kube-apiserver.yaml`:
```
- --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook   # add to existing list
- --admission-control-config-file=/etc/kubernetes/imagepolicy/admission-config.yaml
```
Add a hostPath volume/volumeMount for `/etc/kubernetes/imagepolicy` if not already
reachable (it is, in this setup, since it's on the node's real filesystem under
`/etc/kubernetes` which is already mounted into the static pod).

3. Save, wait for apiserver pod to restart:
```bash
kubectl get pods -n kube-system | grep apiserver
```

`defaultAllow: false` is the key "fail closed" setting — if the webhook backend can't be
reached, image admission is DENIED rather than allowed.
