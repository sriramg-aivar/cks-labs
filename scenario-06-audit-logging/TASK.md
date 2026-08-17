# Scenario 6: Audit logging

Reconfigure the API server on the control-plane node to:
- Use an audit policy file (a basic one is provided at `audit-policy.yaml` — copy it into
  the node)
- Enable log-based audit backend with log retention: max 2 old log files kept

You'll need to edit `/etc/kubernetes/manifests/kube-apiserver.yaml` on
`cks-lab-control-plane` to add the relevant `--audit-*` flags and hostPath volume mounts.
