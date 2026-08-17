# Solution: Scenario 2

```bash
kubectl -n secure create secret tls web-tls --cert=tls.crt --key=tls.key
kubectl -n secure get pods -w
```

Exam tip: the `kubectl create secret tls` subcommand does the base64 encoding and sets
`type: kubernetes.io/tls` for you — don't hand-write the Secret YAML unless asked to.
