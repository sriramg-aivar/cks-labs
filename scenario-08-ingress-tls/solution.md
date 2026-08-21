# Solution: Scenario 8

## Ingress YAML
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: web-ns
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - web.example.com
      secretName: web-tls
  rules:
    - host: web.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: web
                port:
                  number: 80
```
Apply: `kubectl apply -f ingress.yaml`

## Verify
```bash
kubectl -n web-ns get ingress
kubectl -n web-ns describe ingress web-ingress
kubectl -n web-ns get ingress web-ingress -o yaml | grep -A3 tls
kubectl -n web-ns get ingress web-ingress -o yaml | grep ssl-redirect
```

## Exam tips
- `ingressClassName: nginx` is required (not the old annotation)
- TLS secret must be in the SAME namespace as the Ingress
- `pathType` is required: use `Prefix` or `Exact`
- The host in `tls.hosts` must match the rule host
