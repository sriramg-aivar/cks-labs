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

Configure the ImagePolicyWebhook admission controller on the API server:

1. The admission config at `/etc/kubernetes/imagepolicy/admission-config.yaml` is currently
   fail-open. Change it so that if the webhook backend is unreachable, image admission is
   DENIED (fail closed).
2. Edit `/etc/kubernetes/manifests/kube-apiserver.yaml` to enable the ImagePolicyWebhook
   admission plugin and point it at the admission config file. Add the volume/volumeMount
   for the config directory if needed.

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
