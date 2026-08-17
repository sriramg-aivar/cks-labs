# Scenario 1: Fix insecure kubelet and etcd

The kubelet on the controlplane node currently allows anonymous requests and does not
enforce webhook authorization. Fix it so that:

- `anonymous-auth` is set to `false` (in /var/lib/kubelet/config.yaml)
- `authorization-mode` is set to `Webhook`
- Restart kubelet after: `systemctl restart kubelet`

Also check etcd — `/etc/kubernetes/manifests/etcd.yaml` should have
`--client-cert-auth=true`.
