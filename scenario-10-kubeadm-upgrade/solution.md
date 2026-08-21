# Solution: Scenario 10

## Step 1: Drain
```bash
kubectl drain node01 --ignore-daemonsets --delete-emptydir-data
```

## Step 2: Write commands (`/tmp/upgrade-commands.txt`)
```
apt-get update
apt-get install -y kubeadm=1.31.0-1.1
kubeadm upgrade node
apt-get install -y kubelet=1.31.0-1.1 kubectl=1.31.0-1.1
systemctl daemon-reload
systemctl restart kubelet
```

## Step 3: Uncordon
```bash
kubectl uncordon node01
```

## Verify
```bash
# Node is Ready and schedulable
kubectl get nodes

# Commands file exists with correct content
cat /tmp/upgrade-commands.txt
grep 'kubeadm upgrade node' /tmp/upgrade-commands.txt
grep 'daemon-reload' /tmp/upgrade-commands.txt
```

## Exam tips
- **Worker** = `kubeadm upgrade node` (NOT `kubeadm upgrade apply`)
- **Control-plane** = `kubeadm upgrade plan` then `kubeadm upgrade apply v1.31.0`
- Always: upgrade kubeadm → run upgrade → upgrade kubelet+kubectl → daemon-reload → restart
- `--ignore-daemonsets` is always needed for drain
- `--delete-emptydir-data` if pods have emptyDir
- apt version format: `1.31.0-1.1` (not just `1.31.0`)
- On exam: SSH to the worker node (`ssh node01`) to run the actual commands
