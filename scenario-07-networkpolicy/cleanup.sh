#!/usr/bin/env bash
set -euo pipefail
kubectl delete namespace team-a team-b --ignore-not-found
echo "Done."
