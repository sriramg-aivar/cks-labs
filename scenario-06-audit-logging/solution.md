# Solution: Scenario 6

Inside the control-plane node, edit `/etc/kubernetes/manifests/kube-apiserver.yaml`:

Add flags to the `command:` list:
```
- --audit-policy-file=/etc/kubernetes/audit-policy.yaml
- --audit-log-path=/var/log/kubernetes/audit/audit.log
- --audit-log-maxbackup=2
- --audit-log-maxage=7   # (or whatever "X days" the exam specifies)
```

Add matching hostPath volumes + volumeMounts so the container can see the policy file and
write logs:
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

Save the file — kubelet restarts the static pod automatically. Verify:
```bash
kubectl get pods -n kube-system | grep apiserver
docker exec cks-lab-control-plane ls /var/log/kubernetes/audit
```
