# Scenario 15: ImagePolicyWebhook

## Before you start
```bash
# Check the admission config (note: defaultAllow is wrong!)
cat /etc/kubernetes/imagepolicy/admission-config.yaml

# Check the webhook kubeconfig
cat /etc/kubernetes/imagepolicy/kubeconfig.yaml

# Check current apiserver admission plugins
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep admission
```

## Task

1. Fix `/etc/kubernetes/imagepolicy/admission-config.yaml`:
   - Change `defaultAllow: true` → `defaultAllow: false` (fail closed!)

2. Edit `/etc/kubernetes/manifests/kube-apiserver.yaml`:
   - Add `ImagePolicyWebhook` to `--enable-admission-plugins`
   - Add `--admission-control-config-file=/etc/kubernetes/imagepolicy/admission-config.yaml`
   - Add hostPath volume/volumeMount for `/etc/kubernetes/imagepolicy` if needed

## Verify
```bash
# Wait for apiserver to restart (~30-60s)
sleep 40

# API server should be running
kubectl get pods -n kube-system | grep apiserver

# Check admission plugins include ImagePolicyWebhook
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep enable-admission-plugins

# Check config file flag is set
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep admission-control-config

# defaultAllow should be false (fail closed)
grep defaultAllow /etc/kubernetes/imagepolicy/admission-config.yaml
```
