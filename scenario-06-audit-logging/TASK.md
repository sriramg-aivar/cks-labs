# Scenario 6: Audit logging

## Test BEFORE fix
```bash
# No audit flags in apiserver yet
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep audit
# Shows nothing — audit not configured

# Audit log doesn't exist
ls /var/log/kubernetes/audit/audit.log 2>&1
# Shows: No such file

# Policy file exists (created by setup)
cat /etc/kubernetes/audit-policy.yaml
# Shows the policy
```

## Task

Edit `/etc/kubernetes/manifests/kube-apiserver.yaml` to enable audit logging:

1. Add flags:
   - `--audit-policy-file=/etc/kubernetes/audit-policy.yaml`
   - `--audit-log-path=/var/log/kubernetes/audit/audit.log`
   - `--audit-log-maxbackup=2`

2. Add hostPath volumes + volumeMounts:
   - Policy file: mount `/etc/kubernetes/audit-policy.yaml` (readOnly, type: File)
   - Log dir: mount `/var/log/kubernetes/audit` (type: DirectoryOrCreate)

## Test AFTER fix
```bash
# Wait for apiserver to restart (~30-60s)
sleep 40

# Apiserver should be running
kubectl get pods -n kube-system | grep apiserver
# Should show: Running

# Audit flags should be present
ps -ef | grep kube-apiserver | grep audit-log-path
# Should match

# Audit log should exist with content
ls -la /var/log/kubernetes/audit/audit.log
tail -1 /var/log/kubernetes/audit/audit.log
# Should show JSON log entries
```
