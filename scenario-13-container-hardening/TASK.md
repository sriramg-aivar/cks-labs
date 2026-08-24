# Scenario 13: Container Runtime Daemon Hardening

## Test BEFORE fix
```bash
# daemon.json is insecure
cat /opt/docker/daemon.json
# Shows: icc: true, no-new-privileges: false, live-restore: false
# Missing: userns-remap

# fix-permissions.sh is empty (just comments)
cat /opt/docker/fix-permissions.sh
# Shows: TODO comments only
```

## Task

Fix `/opt/docker/daemon.json`:
1. `"icc": false`
2. `"userns-remap": "default"`
3. `"no-new-privileges": true`
4. `"live-restore": true`

Fix `/opt/docker/fix-permissions.sh` — add commands to:
- `chown root:root /var/run/docker.sock`
- `chmod 660 /var/run/docker.sock`

## Test AFTER fix
```bash
# daemon.json should have all secure settings
grep '"icc"' /opt/docker/daemon.json
# Should show: "icc": false

grep 'userns-remap' /opt/docker/daemon.json
# Should show: "userns-remap": "default"

grep 'no-new-privileges' /opt/docker/daemon.json
# Should show: "no-new-privileges": true

grep 'live-restore' /opt/docker/daemon.json
# Should show: "live-restore": true

# fix script should have correct commands
grep 'chown root:root' /opt/docker/fix-permissions.sh
# Should match

grep 'chmod 660' /opt/docker/fix-permissions.sh
# Should match
```
