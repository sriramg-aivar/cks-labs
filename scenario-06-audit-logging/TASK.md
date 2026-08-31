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

Enable API server audit logging by editing `/etc/kubernetes/manifests/kube-apiserver.yaml`:

1. Point the API server at the audit policy file already present at
   `/etc/kubernetes/audit-policy.yaml`.
2. Write audit logs to `/var/log/kubernetes/audit/audit.log`.
3. Keep at most 2 old (rotated) log files.
4. Add the hostPath volumes and volumeMounts so the API server pod can read the policy
   file and write to the log directory.

The API server is a static pod — saving the manifest restarts it automatically.

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
