# Solution: Scenario 8

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
    - hosts: ["web.example.com"]
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

Verify:
```bash
kubectl -n web-ns get ingress
curl -k -H "Host: web.example.com" https://localhost:443   # if controller NodePort/hostPort is mapped
```
