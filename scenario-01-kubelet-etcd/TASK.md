# Scenario 1: Fix insecure kubelet and etcd

The kubelet on the control-plane node currently allows anonymous requests and does not
enforce webhook authorization. Fix it so that:

- `anonymous-auth` is set to `false`
- `authorization-mode` is set to `Webhook`

(In the real exam this also touches etcd's client-cert-auth flag — check that too as a
bonus: `etcd.yaml` should have `--client-cert-auth=true`.)
