# Solution: Scenario 6

## Edit `/etc/kubernetes/manifests/kube-apiserver.yaml`

Add flags:
```yaml
- --audit-policy-file=/etc/kubernetes/audit-policy.yaml
- --audit-log-path=/var/log/kubernetes/audit/audit.log
- --audit-log-maxbackup=2
```

Add volumeMounts:
```yaml
volumeMounts:
  - name: audit-policy
    mountPath: /etc/kubernetes/audit-policy.yaml
    readOnly: true
  - name: audit-log
    mountPath: /var/log/kubernetes/audit
```

Add volumes:
```yaml
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

## Verify
```bash
# Wait ~30-60s for apiserver restart
kubectl get pods -n kube-system | grep apiserver

# Audit log should exist and have content
ls -la /var/log/kubernetes/audit/audit.log
tail -3 /var/log/kubernetes/audit/audit.log

# Flags should be visible
ps -ef | grep kube-apiserver | grep audit
```

## Exam tips
- Always add BOTH the volume AND volumeMount (common mistake: forget one)
- `type: File` for the policy, `type: DirectoryOrCreate` for the log dir
- If apiserver doesn't come back: check `crictl logs <container-id>` or `/var/log/pods/`
- Common mistake: wrong indentation in the YAML breaks the static pod
