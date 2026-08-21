# Solution: Scenario 1

## Fix kubelet

Edit `/var/lib/kubelet/config.yaml`:
```yaml
authentication:
  anonymous:
    enabled: false
authorization:
  mode: Webhook
```

Restart kubelet:
```bash
systemctl restart kubelet
```

## Fix etcd

Edit `/etc/kubernetes/manifests/etcd.yaml`, ensure this flag exists:
```
--client-cert-auth=true
```
Saving auto-restarts the etcd static pod.

## Verify
```bash
# Kubelet config
cat /var/lib/kubelet/config.yaml | grep -A2 'anonymous:'
cat /var/lib/kubelet/config.yaml | grep -A1 'authorization:'
systemctl status kubelet | grep Active

# etcd
cat /etc/kubernetes/manifests/etcd.yaml | grep client-cert-auth

# Cluster health
kubectl get nodes
kubectl get pods -n kube-system
```

## Exam tips
- Know both KubeletConfiguration YAML format and CLI flags
- `systemctl restart kubelet` is mandatory after config changes
- Static pod changes auto-restart (just save the file)
