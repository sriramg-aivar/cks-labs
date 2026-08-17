#!/usr/bin/env bash
set -euo pipefail

mkdir -p /opt/docker

# Insecure daemon.json
cat > /opt/docker/daemon.json <<'EOF'
{
  "icc": true,
  "no-new-privileges": false,
  "live-restore": false,
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

# Show current (bad) permissions
cat > /opt/docker/permissions.txt <<'EOF'
Current socket ownership (INSECURE):
srw-rw-rw- 1 root root 0 Aug 17 00:00 /var/run/docker.sock

Fix this by writing the correct commands to /opt/docker/fix-permissions.sh
EOF

# Empty fix script for student to fill
cat > /opt/docker/fix-permissions.sh <<'EOF'
#!/bin/bash
# TODO: Fix the docker socket ownership and permissions
# The socket should be owned by root:root with 660 permissions
EOF
chmod +x /opt/docker/fix-permissions.sh

echo "Container runtime config files created."
echo "Fix: /opt/docker/daemon.json"
echo "Fix: /opt/docker/fix-permissions.sh"
