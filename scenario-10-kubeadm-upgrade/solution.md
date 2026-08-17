# Solution: Scenario 10

**Step 1: Drain the worker node**
```bash
kubectl drain cks-lab-worker --ignore-daemonsets --delete-emptydir-data
```

**Step 2: Commands file** (`/tmp/upgrade-commands.txt`):
```
apt-get update
apt-get install -y kubeadm=1.31.0-1.1
kubeadm upgrade node
apt-get install -y kubelet=1.31.0-1.1 kubectl=1.31.0-1.1
systemctl daemon-reload
systemctl restart kubelet
```

**Step 3: Uncordon**
```bash
kubectl uncordon cks-lab-worker
```

Key exam tips:
- Worker nodes use `kubeadm upgrade node` (NOT `kubeadm upgrade apply` — that's for control-plane only)
- Always upgrade kubeadm FIRST, then run the upgrade, then upgrade kubelet+kubectl
- Drain before upgrade, uncordon after
- `--ignore-daemonsets` is almost always needed (DaemonSets can't be evicted)
- `--delete-emptydir-data` if pods use emptyDir volumes
- The version format for apt is `1.31.0-1.1` (not just `1.31.0`)
- Control-plane upgrade sequence: kubeadm upgrade plan → kubeadm upgrade apply v1.31.0
