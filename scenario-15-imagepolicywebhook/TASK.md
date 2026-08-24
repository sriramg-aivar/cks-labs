# Scenario 15: ImagePolicyWebhook

## Test BEFORE fix
```bash
# admission-config has defaultAllow: true (WRONG - fail open!)
grep defaultAllow /etc/kubernetes/imagepolicy/admission-config.yaml
# Shows: defaultAllow: true

# ImagePolicyWebhook is NOT in admission plugins yet
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep enable-admission-plugins
# Shows: NodeRestriction only (no ImagePolicyWebhook)
```

## Task

1. Fix `/etc/kubernetes/imagepolicy/admission-config.yaml`:
   - Change `defaultAllow: true` → `defaultAllow: false` (fail CLOSED)

2. Edit `/etc/kubernetes/manifests/kube-apiserver.yaml`:
   - Add `ImagePolicyWebhook` to `--enable-admission-plugins=NodeRestriction,ImagePolicyWebhook`
   - Add `--admission-control-config-file=/etc/kubernetes/imagepolicy/admission-config.yaml`
   - Add volume/volumeMount for `/etc/kubernetes/imagepolicy` if needed

## Test AFTER fix
```bash
# Wait for apiserver restart
sleep 40

# Apiserver should be Running
kubectl get pods -n kube-system | grep apiserver
# Should show: Running

# defaultAllow should be false
grep defaultAllow /etc/kubernetes/imagepolicy/admission-config.yaml
# Should show: defaultAllow: false

# ImagePolicyWebhook in admission plugins
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep enable-admission-plugins
# Should contain: ImagePolicyWebhook

# Config file flag set
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep admission-control-config
# Should show the path
```
