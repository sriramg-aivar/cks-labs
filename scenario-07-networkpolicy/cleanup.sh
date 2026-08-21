#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace team-a team-b --ignore-not-found --grace-period=0 --force
echo "Done."
