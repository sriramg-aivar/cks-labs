# Solution: Scenario 6

Edit `/etc/kubernetes/manifests/kube-apiserver.yaml`:

Add flags to the `command:` list:
```
- --audit-policy-file=/etc/kubernetes/audit-policy.yaml
- --audit-log-path=/var/log/kubernetes/audit/audit.log
- --audit-log-maxbackup=2
```

Add matching hostPath volumes + volumeMounts:
```yaml
volumeMounts:
  - name: audit-policy
    mountPath: /etc/kubernetes/audit-policy.yaml
    readOnly: true
  - name: audit-log
    mountPath: /var/log/kubernetes/audit
...
volumes:
  - name: audit-policy
    hostPath:
      path: /etc/kubernetes/audit-policy.yaml
      type: File
  - name: audit-log
    hostPath:
      path: /var/log/kubernetes/audit
      type: DirectoryOrCreate
```

Save — kubelet restarts the static pod automatically. Verify:
```bash
kubectl get pods -n kube-system | grep apiserver
ls /var/log/kubernetes/audit/
```
