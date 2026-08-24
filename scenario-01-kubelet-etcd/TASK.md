# Scenario 1: Fix insecure kubelet and etcd

## Test BEFORE fix
```bash
# Kubelet allows anonymous access (BAD - should be false)
cat /var/lib/kubelet/config.yaml | grep -A1 'anonymous:'
# Shows: enabled: true

# Authorization is AlwaysAllow (BAD - should be Webhook)
cat /var/lib/kubelet/config.yaml | grep -A1 'authorization:'
# Shows: mode: AlwaysAllow

# etcd has client-cert-auth disabled (BAD)
cat /etc/kubernetes/manifests/etcd.yaml | grep client-cert-auth
# Shows: --client-cert-auth=false
```

## Task

The kubelet on the controlplane node is insecure. Fix:

1. Edit `/var/lib/kubelet/config.yaml`:
   - Set `authentication.anonymous.enabled` → `false`
   - Set `authorization.mode` → `Webhook`
2. Restart kubelet: `systemctl restart kubelet`
3. Edit `/etc/kubernetes/manifests/etcd.yaml`:
   - Set `--client-cert-auth=true`

## Test AFTER fix
```bash
# Kubelet anonymous access disabled
cat /var/lib/kubelet/config.yaml | grep -A1 'anonymous:'
# Should show: enabled: false

# Authorization is Webhook
cat /var/lib/kubelet/config.yaml | grep -A1 'authorization:'
# Should show: mode: Webhook

# Kubelet running
systemctl is-active kubelet
# Should show: active

# etcd has client-cert-auth enabled
cat /etc/kubernetes/manifests/etcd.yaml | grep client-cert-auth
# Should show: --client-cert-auth=true

# Cluster works
kubectl get nodes
```
