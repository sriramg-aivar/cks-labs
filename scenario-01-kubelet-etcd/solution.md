# Solution: Scenario 1

On the control-plane node (`docker exec -it cks-lab-control-plane bash`):

**Kubelet** — edit `/var/lib/kubelet/config.yaml` (kind uses the KubeletConfiguration file,
not CLI flags, for these settings):
```yaml
authentication:
  anonymous:
    enabled: false
authorization:
  mode: Webhook
```
Then: `systemctl restart kubelet`

**etcd** — edit `/etc/kubernetes/manifests/etcd.yaml`, ensure:
```
--client-cert-auth=true
```
Saving this file auto-restarts the etcd static pod (kubelet watches the manifests dir).

**Verify:**
```bash
ps -ef | grep kubelet   # or check config.yaml directly
kubectl get pods -n kube-system | grep etcd
```

Note: on a real exam cluster (kubeadm, not kind) these are often CLI flags directly on
`kube-apiserver.yaml` / kubelet systemd unit args instead of a config file — know both forms.
