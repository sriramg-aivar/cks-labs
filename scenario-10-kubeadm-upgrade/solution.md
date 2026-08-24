# Solution: Scenario 10

## Step 1: Drain
```bash
kubectl drain node01 --ignore-daemonsets --delete-emptydir-data
```

## Step 2: Write commands (`/tmp/upgrade-commands.txt`)

Replace `<VERSION>` with the target version shown during setup (e.g., `1.36.0-1.1`):
```bash
cat > /tmp/upgrade-commands.txt << 'EOF'
apt-get update
apt-get install -y kubeadm=<VERSION>-1.1
kubeadm upgrade node
apt-get install -y kubelet=<VERSION>-1.1 kubectl=<VERSION>-1.1
systemctl daemon-reload
systemctl restart kubelet
EOF
```

## Step 3: Uncordon
```bash
kubectl uncordon node01
```

## Test AFTER fix
```bash
kubectl get nodes
# node01 = Ready, no SchedulingDisabled
cat /tmp/upgrade-commands.txt
```

## Exam tips
- **Worker** = `kubeadm upgrade node` (NOT `kubeadm upgrade apply`)
- **Control-plane** = `kubeadm upgrade plan` then `kubeadm upgrade apply vX.Y.Z`
- Always: upgrade kubeadm → run upgrade → upgrade kubelet+kubectl → daemon-reload → restart
- `--ignore-daemonsets` is always needed for drain
- `--delete-emptydir-data` if pods have emptyDir
- apt version format: `1.36.0-1.1` (not just `1.36.0`)
- On exam: SSH to the worker node to run the actual commands
