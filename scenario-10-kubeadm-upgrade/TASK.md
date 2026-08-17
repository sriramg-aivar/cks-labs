# Scenario 10: Kubernetes Node Upgrade (kubeadm)

The cluster's worker node `cks-lab-worker` is running an older version and needs to be
upgraded. Perform the upgrade procedure:

1. Drain the worker node (ignore DaemonSets)
2. The upgrade commands are simulated — create a file `/tmp/upgrade-commands.txt` on
   your local machine with the EXACT sequence of commands you would run on a real node
   to upgrade from v1.30.0 to v1.31.0
3. Uncordon the worker node

Your `/tmp/upgrade-commands.txt` should contain the complete kubeadm upgrade sequence
for a WORKER node (not control-plane), one command per line.
