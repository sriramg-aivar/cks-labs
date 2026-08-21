# Solution: Scenario 15

## Fix admission config
Edit `/etc/kubernetes/imagepolicy/admission-config.yaml`:
```yaml
defaultAllow: false
```

## Edit kube-apiserver.yaml
Add to `/etc/kubernetes/manifests/kube-apiserver.yaml`:
```yaml
- --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook
- --admission-control-config-file=/etc/kubernetes/imagepolicy/admission-config.yaml
```

If `/etc/kubernetes/imagepolicy` is not already accessible to the pod, add:
```yaml
volumeMounts:
  - name: imagepolicy
    mountPath: /etc/kubernetes/imagepolicy
    readOnly: true
volumes:
  - name: imagepolicy
    hostPath:
      path: /etc/kubernetes/imagepolicy
      type: DirectoryOrCreate
```

## Verify
```bash
# Wait for apiserver to restart
sleep 40
kubectl get pods -n kube-system | grep apiserver

# Check flags
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep ImagePolicyWebhook
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep admission-control-config

# defaultAllow should be false
grep defaultAllow /etc/kubernetes/imagepolicy/admission-config.yaml
```

## Exam tips
- `defaultAllow: false` = fail CLOSED (deny if webhook unreachable)
- `defaultAllow: true` = fail OPEN (allow if webhook unreachable) — WRONG for security
- Don't forget to add the config file flag AND the admission plugin
- If apiserver doesn't come back: check logs with `crictl logs`
- Common mistake: trailing comma in admission-plugins list
