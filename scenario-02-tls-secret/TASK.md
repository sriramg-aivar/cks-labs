# Scenario 2: TLS Secret

## Before you start
```bash
# Check the deployment and pods in 'secure' namespace
kubectl -n secure get deployment
kubectl -n secure get pods
kubectl -n secure describe pod | grep -A5 Events

# See what secret the deployment expects
kubectl -n secure get deployment web-app -o yaml | grep -A5 volumes

# Check if the cert/key files exist
ls /root/tls.crt /root/tls.key 2>/dev/null || ls tls.crt tls.key 2>/dev/null
```

## Task

A Deployment `web-app` in namespace `secure` references a TLS secret named `web-tls` in its
volumes, but the secret doesn't exist yet — the pods are stuck in ContainerCreating.

Create the `web-tls` secret (type `kubernetes.io/tls`) using the provided cert/key files
so the pods come up.

## Verify
```bash
# Secret should exist with type kubernetes.io/tls
kubectl -n secure get secret web-tls
kubectl -n secure get secret web-tls -o yaml | grep type

# Pods should be Running now
kubectl -n secure get pods
```
