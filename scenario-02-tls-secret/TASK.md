# Scenario 2: TLS Secret

## Test BEFORE fix
```bash
# Pod is stuck in ContainerCreating (waiting for secret)
kubectl -n secure get pods
# Shows: ContainerCreating

# Secret doesn't exist yet
kubectl -n secure get secret web-tls
# Shows: Error - not found

# Deployment expects a volume from secret 'web-tls'
kubectl -n secure describe pod | grep -A3 'Events'
# Shows: secret "web-tls" not found
```

## Task

Deployment `web-app` in namespace `secure` is stuck in ContainerCreating because it
mounts a TLS secret named `web-tls` that doesn't exist yet.

Create the `web-tls` secret (of type TLS) in namespace `secure` using the certificate
and key files (`tls.crt`, `tls.key`) in the current directory, so the pods start.

## Test AFTER fix
```bash
# Secret should exist with correct type
kubectl -n secure get secret web-tls
# Should show the secret

kubectl -n secure get secret web-tls -o jsonpath='{.type}'
# Should show: kubernetes.io/tls

# Pods should now be Running
kubectl -n secure get pods
# Should show: Running
```
