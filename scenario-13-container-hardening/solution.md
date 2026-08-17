# Solution: Scenario 13

**Fixed `/opt/docker/daemon.json`:**
```json
{
  "icc": false,
  "userns-remap": "default",
  "no-new-privileges": true,
  "live-restore": true,
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

**Fix permissions script** (`/opt/docker/fix-permissions.sh`):
```bash
#!/bin/bash
chown root:root /var/run/docker.sock
chmod 660 /var/run/docker.sock
```

Key exam tips:
- `icc: false` — prevents containers from communicating directly via bridge (defense in depth)
- `userns-remap: default` — maps container root to unprivileged host user (user namespace isolation)
- `no-new-privileges: true` — prevents processes from gaining additional privileges via setuid/setgid
- `live-restore: true` — keeps containers running if daemon restarts
- Docker socket should be `root:root` with `660` (or `root:docker` with `660` — but removing users from docker group is preferred)
- Always `systemctl restart docker` after changing daemon.json
