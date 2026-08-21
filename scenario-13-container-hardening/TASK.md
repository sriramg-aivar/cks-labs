# Scenario 13: Container Runtime Daemon Hardening

## Before you start
```bash
# Check current (insecure) daemon.json
cat /opt/docker/daemon.json

# Check permissions info
cat /opt/docker/permissions.txt

# Check the fix script template
cat /opt/docker/fix-permissions.sh
```

## Task

Fix the container runtime configuration at `/opt/docker/daemon.json`:

1. Set `icc` to `false` (disable inter-container communication)
2. Add `userns-remap` set to `"default"` (user namespace isolation)
3. Set `no-new-privileges` to `true`
4. Set `live-restore` to `true`

Also write the correct commands in `/opt/docker/fix-permissions.sh` to:
- Set socket ownership to `root:root`
- Set socket permissions to `660`

## Verify
```bash
# daemon.json should have all security settings
cat /opt/docker/daemon.json | python3 -m json.tool

# Check specific values
grep '"icc"' /opt/docker/daemon.json          # should be false
grep 'userns-remap' /opt/docker/daemon.json    # should be "default"
grep 'no-new-privileges' /opt/docker/daemon.json  # should be true
grep 'live-restore' /opt/docker/daemon.json    # should be true

# fix-permissions.sh should have correct commands
cat /opt/docker/fix-permissions.sh
grep 'chown root:root' /opt/docker/fix-permissions.sh
grep 'chmod 660' /opt/docker/fix-permissions.sh
```
