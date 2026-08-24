# Scenario 10: Kubernetes Node Upgrade (kubeadm)

## Test BEFORE fix
```bash
# Node should be schedulable (Ready, no SchedulingDisabled)
kubectl get nodes

# Pods are running on both nodes
kubectl get pods -o wide

# No upgrade commands file exists yet
cat /tmp/upgrade-commands.txt
# ^ Should show: No such file
```

## Task

The cluster's worker node `node01` needs to be upgraded.
The setup script shows you the current and target versions.

Perform the upgrade procedure:

1. **Drain** worker node `node01` (ignore DaemonSets, delete emptyDir data)
2. **Write** the EXACT upgrade commands to `/tmp/upgrade-commands.txt`
   (the sequence you would run ON the worker node, one command per line)
3. **Uncordon** node01

The commands file should contain the complete `kubeadm upgrade` sequence
for a **WORKER node** (not control-plane).

## Test AFTER fix
```bash
# Node should be Ready and schedulable (no SchedulingDisabled)
kubectl get nodes
# node01 should show Ready without SchedulingDisabled

# Commands file should exist and contain correct sequence
cat /tmp/upgrade-commands.txt
# Should have: apt-get update, apt-get install kubeadm, kubeadm upgrade node,
#              apt-get install kubelet kubectl, daemon-reload, restart kubelet
```
