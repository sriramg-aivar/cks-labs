#!/usr/bin/env bash
set -euo pipefail

# Create the monitoring namespace and suspicious pod
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -
kubectl -n monitoring run suspicious-pod --image=busybox:1.36 --command -- sleep 3600

# Create Falco config directories on this node
mkdir -p /opt/falco/rules.d

# Template rules file (incomplete - student must fix)
cat > /opt/falco/rules.d/custom-rules.yaml <<'EOF'
# TODO: Add a rule named "Read sensitive file shadow"
# that detects reading of /etc/shadow
# Include: timestamp, user, process name, container ID
# Priority: WARNING
- rule: CHANGEME
  desc: CHANGEME
  condition: CHANGEME
  output: "CHANGEME"
  priority: CHANGEME
EOF

# Falco config with json_output disabled
cat > /opt/falco/falco.yaml <<'EOF'
rules_file:
  - /etc/falco/falco_rules.yaml
  - /etc/falco/rules.d

json_output: false
log_stderr: true
log_syslog: true
log_level: info
priority: debug
EOF

echo ""
echo "Falco config files created."
echo "Edit: /opt/falco/rules.d/custom-rules.yaml"
echo "Edit: /opt/falco/falco.yaml"
