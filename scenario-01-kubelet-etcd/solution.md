# Solution: Scenario 1

Edit `/var/lib/kubelet/config.yaml`:
```yaml
authentication:
  anonymous:
    enabled: false
authorization:
  mode: Webhook
```
Then: `systemctl restart kubelet`

Edit `/etc/kubernetes/manifests/etcd.yaml`, ensure:
```
--client-cert-auth=true
```
Saving this file auto-restarts the etcd static pod.

Verify:
```bash
ps -ef | grep kubelet
kubectl get pods -n kube-system | grep etcd
```

Note: the CKS exam uses kubeadm clusters — know both config file format
(KubeletConfiguration YAML) and CLI flags.
