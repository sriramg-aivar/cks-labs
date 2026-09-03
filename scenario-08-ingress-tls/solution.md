# Solution: Scenario 8

## Ingress YAML (Cilium ingress class)
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: web-ns
  annotations:
    ingress.cilium.io/force-https: enabled
spec:
  ingressClassName: cilium
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
kubectl -n web-ns get ingress web-ingress -o jsonpath='{.spec.ingressClassName}'   # cilium
kubectl -n web-ns get ingress web-ingress -o yaml | grep -A3 tls
kubectl -n web-ns get ingress web-ingress -o yaml | grep force-https
```

## Exam tips
- Cilium ingress uses `ingressClassName: cilium` (controller `cilium.io/ingress-controller`)
- Cilium HTTP→HTTPS redirect annotation: `ingress.cilium.io/force-https: enabled`
  (nginx uses `nginx.ingress.kubernetes.io/ssl-redirect: "true"` — know both)
- TLS secret must be in the SAME namespace as the Ingress
- `pathType` is required: use `Prefix` or `Exact`
- The host in `tls.hosts` must match the rule host
- Cilium ingress needs `enable-ingress-controller: true` + `enable-l7-proxy: true` in the Cilium config
