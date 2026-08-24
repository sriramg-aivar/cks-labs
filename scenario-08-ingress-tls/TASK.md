# Scenario 8: Expose HTTPS via Ingress

## Test BEFORE fix
```bash
# Deployment and Service exist
kubectl -n web-ns get deploy,svc
# Shows: deployment/web, service/web

# TLS secret exists
kubectl -n web-ns get secret web-tls
# Shows the secret

# No Ingress yet
kubectl -n web-ns get ingress
# Shows: No resources found
```

## Task

Create an Ingress in namespace `web-ns`:
1. Name: `web-ingress`
2. TLS: terminate using secret `web-tls` for host `web.example.com`
3. Route: `web.example.com` → service `web` port `80`
4. Annotation: `nginx.ingress.kubernetes.io/ssl-redirect: "true"`
5. `ingressClassName: nginx`

## Test AFTER fix
```bash
# Ingress should exist
kubectl -n web-ns get ingress web-ingress
# Should show the ingress

# TLS should be configured
kubectl -n web-ns get ingress web-ingress -o jsonpath='{.spec.tls[0].secretName}'
# Should show: web-tls

# Host should be correct
kubectl -n web-ns get ingress web-ingress -o jsonpath='{.spec.rules[0].host}'
# Should show: web.example.com

# Annotation should be set
kubectl -n web-ns get ingress web-ingress -o jsonpath='{.metadata.annotations}'
# Should contain: ssl-redirect: "true"
```
