# Solution: Scenario 2

## Create the TLS secret
```bash
kubectl -n secure create secret tls web-tls --cert=tls.crt --key=tls.key
```

## Verify
```bash
# Secret exists with correct type
kubectl -n secure get secret web-tls
kubectl -n secure get secret web-tls -o jsonpath='{.type}'
# Should output: kubernetes.io/tls

# Pods should now be Running
kubectl -n secure get pods -w
```

## Exam tips
- `kubectl create secret tls` handles base64 encoding + sets type for you
- Don't hand-write the Secret YAML unless explicitly asked
- The cert/key files are usually in the current directory or specified in the question
