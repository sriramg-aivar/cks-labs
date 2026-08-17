#!/usr/bin/env bash
set -euo pipefail
echo "Deleting kind cluster 'cks-lab'..."
kind delete cluster --name cks-lab
echo "Done."
