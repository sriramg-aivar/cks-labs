# Scenario 15: ImagePolicyWebhook

Configure the API server to use the `ImagePolicyWebhook` admission plugin with the
provided AdmissionConfiguration (`admission-config.yaml`, generated for you). Ensure the
webhook is set to DENY images when its backend is unavailable (fail closed).
