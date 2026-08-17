# Solution: Scenario 9

**ServiceAccount:**
```bash
kubectl patch serviceaccount restricted-sa -n default -p '{"automountServiceAccountToken": false}'
```

**Deployment** — add explicit manual mount via projected volume:
```yaml
spec:
  template:
    spec:
      serviceAccountName: restricted-sa
      automountServiceAccountToken: false
      containers:
        - name: app
          image: nginx:1.25
          volumeMounts:
            - name: kube-api-access
              mountPath: /var/run/secrets/kubernetes.io/serviceaccount
              readOnly: true
      volumes:
        - name: kube-api-access
          projected:
            sources:
              - serviceAccountToken:
                  path: token
                  expirationSeconds: 3607
              - configMap:
                  name: kube-root-ca.crt
                  items:
                    - key: ca.crt
                      path: ca.crt
              - downwardAPI:
                  items:
                    - path: namespace
                      fieldRef:
                        fieldPath: metadata.namespace
```
Apply with `kubectl apply -f -`, then verify the token is mounted:
```bash
kubectl exec deploy/token-app -- ls /var/run/secrets/kubernetes.io/serviceaccount
```
