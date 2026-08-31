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

Create an Ingress named `web-ingress` in namespace `web-ns` that:
1. Terminates TLS for host `web.example.com` using the existing secret `web-tls`.
2. Routes `web.example.com` traffic to Service `web` on port `80`.
3. Forces HTTP→HTTPS redirect (nginx ssl-redirect annotation).
4. Uses the `nginx` ingress class.

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
