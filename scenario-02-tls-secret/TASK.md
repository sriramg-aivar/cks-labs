# Scenario 2: TLS Secret

A Deployment `web-app` in namespace `secure` references a TLS secret named `web-tls` in its
volumes, but the secret doesn't exist yet — the pods are stuck in ContainerCreating.
Create the `web-tls` secret (type `kubernetes.io/tls`) using the provided cert/key so the
pods come up.
