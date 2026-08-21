# Scenario 8: Expose HTTPS via Ingress

## Before you start
```bash
# Check deployment and service exist
kubectl -n web-ns get deployment web
kubectl -n web-ns get svc web

# Check the TLS secret exists
kubectl -n web-ns get secret web-tls

# Check existing ingress (should be none)
kubectl -n web-ns get ingress

# Check ingress controller is running
kubectl get pods -n ingress-nginx 2>/dev/null || kubectl get pods --all-namespaces | grep ingress
```

## Task

Create an Ingress in namespace `web-ns` that:
1. Terminates TLS using secret `web-tls`
2. Routes host `web.example.com` to service `web` on port `80`
3. Has annotation: `nginx.ingress.kubernetes.io/ssl-redirect: "true"`
4. Uses `ingressClassName: nginx`

## Verify
```bash
# Ingress should exist with TLS configured
kubectl -n web-ns get ingress
kubectl -n web-ns describe ingress web-ingress

# Check TLS section
kubectl -n web-ns get ingress web-ingress -o yaml | grep -A3 tls

# Check the host rule
kubectl -n web-ns get ingress web-ingress -o yaml | grep host

# Check annotation
kubectl -n web-ns get ingress web-ingress -o yaml | grep ssl-redirect
```
