# Solution: Scenario 13

## Fix daemon.json (`/opt/docker/daemon.json`)
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

## Fix permissions script (`/opt/docker/fix-permissions.sh`)
```bash
#!/bin/bash
chown root:root /var/run/docker.sock
chmod 660 /var/run/docker.sock
```

## Verify
```bash
cat /opt/docker/daemon.json | python3 -m json.tool
grep 'icc.*false' /opt/docker/daemon.json
grep 'userns-remap' /opt/docker/daemon.json
cat /opt/docker/fix-permissions.sh
```

## Exam tips
- `icc: false` — prevents direct container-to-container communication on bridge
- `userns-remap: "default"` — maps container root to unprivileged host UID
- `no-new-privileges: true` — blocks setuid/setgid escalation
- `live-restore: true` — containers keep running during daemon restart
- Socket: `root:root` + `660` (only root/docker group can access)
- After changes: `systemctl restart docker`
