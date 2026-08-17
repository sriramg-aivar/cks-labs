# Scenario 10: Kubernetes Node Upgrade (kubeadm)

The cluster's worker node `node01` needs to be upgraded. Perform the upgrade procedure:

1. Drain the worker node (ignore DaemonSets)
2. Create a file `/tmp/upgrade-commands.txt` with the EXACT sequence of commands
   you would run ON the worker node to upgrade from v1.30.0 to v1.31.0
3. Uncordon the worker node

Your `/tmp/upgrade-commands.txt` should contain the complete kubeadm upgrade sequence
for a WORKER node (not control-plane), one command per line.
