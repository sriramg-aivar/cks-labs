#!/usr/bin/env bash
set -euo pipefail
docker exec cks-lab-control-plane rm -rf /opt/docker
echo "Done."
