# Scenario 1: Fix insecure kubelet and etcd

## Before you start
```bash
# Check current kubelet config (look at anonymous and authorization sections)
cat /var/lib/kubelet/config.yaml | grep -A2 'anonymous:'
cat /var/lib/kubelet/config.yaml | grep -A1 'authorization:'

# Check etcd client-cert-auth flag
cat /etc/kubernetes/manifests/etcd.yaml | grep client-cert-auth
```

## Task

The kubelet on the controlplane node currently allows anonymous requests and does not
enforce webhook authorization. Fix it so that:

1. In `/var/lib/kubelet/config.yaml`:
   - `authentication.anonymous.enabled` → `false`
   - `authorization.mode` → `Webhook`
2. Restart kubelet: `systemctl restart kubelet`
3. In `/etc/kubernetes/manifests/etcd.yaml`:
   - Ensure `--client-cert-auth=true`

## Verify
```bash
# Kubelet config should show anonymous disabled + webhook auth
cat /var/lib/kubelet/config.yaml | grep -A2 'anonymous:'
cat /var/lib/kubelet/config.yaml | grep -A1 'authorization:'

# Kubelet should be running
systemctl status kubelet | grep Active

# etcd should have client-cert-auth=true
cat /etc/kubernetes/manifests/etcd.yaml | grep client-cert-auth

# Cluster should be healthy
kubectl get nodes
kubectl get pods -n kube-system | grep etcd
```
