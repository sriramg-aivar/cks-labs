# Scenario 13: Container Runtime Daemon Hardening

On the control-plane node, the container runtime daemon configuration at
`/opt/docker/daemon.json` is insecure. Fix it:

1. Disable `icc` (inter-container communication) — set to `false`
2. Enable `userns-remap` — set to `default`
3. Ensure `no-new-privileges` is set to `true`
4. Ensure `live-restore` is `true`
5. The file `/opt/docker/permissions.txt` shows current socket ownership.
   Write the correct ownership fix command into `/opt/docker/fix-permissions.sh`

Edit the files directly on the control-plane node:
  docker exec -it cks-lab-control-plane bash
