# Scenario 10: Kubernetes Node Upgrade (kubeadm)

## Before you start
```bash
# Check current node versions
kubectl get nodes -o wide

# Check pods running on the worker
kubectl get pods -o wide | grep node01

# Check the deployment to drain
kubectl get deployment drain-test
```

## Task

1. Drain worker node `node01` (ignore DaemonSets, delete emptyDir data)
2. Create `/tmp/upgrade-commands.txt` with the EXACT commands to run ON the worker
   node to upgrade from v1.30.0 to v1.31.0 (one command per line)
3. Uncordon node01

Your file should contain the complete sequence for a **WORKER node** upgrade.

## Verify
```bash
# Node should be Ready and schedulable (not cordoned)
kubectl get nodes
# node01 should show 'Ready' without 'SchedulingDisabled'

# Commands file should exist
cat /tmp/upgrade-commands.txt

# Should contain these key commands:
grep 'kubeadm upgrade node' /tmp/upgrade-commands.txt
grep 'apt-get.*kubeadm' /tmp/upgrade-commands.txt
grep 'apt-get.*kubelet' /tmp/upgrade-commands.txt
grep 'daemon-reload' /tmp/upgrade-commands.txt
grep 'restart.*kubelet' /tmp/upgrade-commands.txt
```
