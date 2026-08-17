# Scenario 6: Audit logging

Reconfigure the API server on the controlplane node to:
- Use the audit policy file at `/etc/kubernetes/audit-policy.yaml` (already created)
- Enable log-based audit backend writing to `/var/log/kubernetes/audit/audit.log`
- Set max backup (old log files kept) to 2

Edit `/etc/kubernetes/manifests/kube-apiserver.yaml` to add the relevant `--audit-*`
flags and hostPath volume mounts.
