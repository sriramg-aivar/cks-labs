# Scenario 8: Expose HTTPS via Ingress

Deployment+Service `web` exist in namespace `web-ns`. Create an Ingress that:
- Terminates TLS using secret `web-tls` (already created for you)
- Routes `web.example.com` to the `web` service on port 80
- Sets the annotation `nginx.ingress.kubernetes.io/ssl-redirect: "true"`
