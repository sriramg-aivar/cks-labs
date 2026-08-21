# Scenario 6: Audit logging

## Before you start
```bash
# Check if audit policy file exists
ls -la /etc/kubernetes/audit-policy.yaml
cat /etc/kubernetes/audit-policy.yaml

# Check current kube-apiserver flags (no audit flags yet)
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep audit

# Check log directory
ls /var/log/kubernetes/audit/ 2>/dev/null || echo "directory doesn't exist yet"
```

## Task

Reconfigure the API server to enable audit logging:

1. Edit `/etc/kubernetes/manifests/kube-apiserver.yaml` to add:
   - `--audit-policy-file=/etc/kubernetes/audit-policy.yaml`
   - `--audit-log-path=/var/log/kubernetes/audit/audit.log`
   - `--audit-log-maxbackup=2`

2. Add the corresponding hostPath volumes and volumeMounts:
   - Mount the policy file (readOnly)
   - Mount the log directory

## Verify
```bash
# Wait for apiserver to restart (~30-60s)
sleep 30

# API server should be running
kubectl get pods -n kube-system | grep apiserver

# Check the flags are in place
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep audit

# Audit log should exist
ls -la /var/log/kubernetes/audit/audit.log

# Check log has entries
tail -5 /var/log/kubernetes/audit/audit.log
```
