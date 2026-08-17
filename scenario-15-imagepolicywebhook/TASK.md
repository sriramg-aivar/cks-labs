# Scenario 15: ImagePolicyWebhook

Configure the API server to use the `ImagePolicyWebhook` admission plugin.
Files are at `/etc/kubernetes/imagepolicy/`:
- `admission-config.yaml` — AdmissionConfiguration (has a mistake!)
- `kubeconfig.yaml` — webhook kubeconfig

Ensure the webhook is set to DENY images when its backend is unavailable (fail closed).
Then wire kube-apiserver.yaml to use ImagePolicyWebhook with this config.
