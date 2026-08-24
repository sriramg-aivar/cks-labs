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

A Deployment `web-app` in namespace `secure` references a TLS secret named `web-tls`
in its volumes, but the secret doesn't exist — pods are stuck in ContainerCreating.

Create the `web-tls` secret (type `kubernetes.io/tls`) using the cert/key files
(`tls.crt` and `tls.key` in the current directory).

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
