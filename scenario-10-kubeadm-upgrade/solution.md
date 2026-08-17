# Solution: Scenario 10

**Step 1: Drain the worker node**
```bash
kubectl drain node01 --ignore-daemonsets --delete-emptydir-data
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
kubectl uncordon node01
```

Key exam tips:
- Worker nodes use `kubeadm upgrade node` (NOT `kubeadm upgrade apply`)
- Always upgrade kubeadm FIRST, then run the upgrade, then kubelet+kubectl
- Drain before upgrade, uncordon after
- `--ignore-daemonsets` is almost always needed
- `--delete-emptydir-data` if pods use emptyDir volumes
- The version format for apt is `1.31.0-1.1`
- On the real exam: ssh to the worker node to run these commands
