# Solution: Scenario 9

## Patch ServiceAccount
```bash
kubectl patch serviceaccount restricted-sa -p '{"automountServiceAccountToken": false}'
```

## Edit Deployment
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

## Verify
```bash
# SA has automount disabled
kubectl get sa restricted-sa -o jsonpath='{.automountServiceAccountToken}'

# Pod has token mounted via projected volume
kubectl exec deploy/token-app -- ls /var/run/secrets/kubernetes.io/serviceaccount/
# Should show: ca.crt  namespace  token

# Deployment has automount false
kubectl get deploy token-app -o yaml | grep automount
```

## Exam tips
- Set automount `false` on BOTH the ServiceAccount AND the pod spec
- projected volume sources: serviceAccountToken + configMap (kube-root-ca.crt) + downwardAPI (namespace)
- `expirationSeconds: 3607` is the default kubelet uses
- `readOnly: true` on the volumeMount for security
