#!/usr/bin/env bash
set -euo pipefail

# ─── Auto-install Falco if not present ─────────────────────────────
if ! command -v falco &>/dev/null; then
  echo "Installing Falco (this can take 1-2 minutes)..."
  # Add Falco apt repo + install (Debian/Ubuntu — Killercoda nodes are Ubuntu)
  curl -fsSL https://falco.org/repo/falcosecurity-packages.asc | \
    gpg --dearmor -o /usr/share/keyrings/falco-archive-keyring.gpg 2>/dev/null || true
  echo "deb [signed-by=/usr/share/keyrings/falco-archive-keyring.gpg] https://download.falco.org/packages/deb stable main" \
    > /etc/apt/sources.list.d/falcosecurity.list

  export DEBIAN_FRONTEND=noninteractive
  apt-get update -y >/dev/null 2>&1 || true
  # Install falco WITHOUT the driver/kernel module (we only need rule validation + config)
  # FALCO_FRONTEND=noninteractive avoids the interactive driver prompt
  echo "falco falco/dialog_dkms boolean false" | debconf-set-selections 2>/dev/null || true
  apt-get install -y falco >/dev/null 2>&1 || {
    echo "⚠ apt install failed — trying the standalone binary..."
    FALCO_VER="0.38.2"
    curl -sSL "https://download.falco.org/packages/bin/x86_64/falco-${FALCO_VER}-x86_64.tar.gz" | tar xz -C /tmp 2>/dev/null || true
    cp /tmp/falco-*/usr/bin/falco /usr/local/bin/falco 2>/dev/null || true
  }

  if command -v falco &>/dev/null; then
    echo "✓ Falco installed ($(falco --version 2>/dev/null | head -1))"
  else
    echo "⚠ Falco binary not available — you can still write/validate the rules by hand."
  fi
else
  echo "✓ Falco already installed"
fi

# ─── Create scenario workload + broken Falco config ────────────────
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -
kubectl -n monitoring run suspicious-pod --image=busybox:1.36 --command --dry-run=client -o yaml -- sleep 3600 | kubectl apply -f -

# Use Falco's real config dir if Falco is installed, else /opt/falco
if [ -d /etc/falco ]; then
  RULES_DIR="/etc/falco/rules.d"
  CONFIG="/etc/falco/falco.yaml"
else
  RULES_DIR="/opt/falco/rules.d"
  CONFIG="/opt/falco/falco.yaml"
fi
mkdir -p "$RULES_DIR"

# Template rules file (incomplete — student must fix)
cat > "$RULES_DIR/custom-rules.yaml" <<'EOF'
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

# Break json_output in the config
if [ -f "$CONFIG" ]; then
  # Falco's real config already exists — force json_output to false
  if grep -q '^json_output:' "$CONFIG"; then
    sed -i 's/^json_output:.*/json_output: false/' "$CONFIG"
  else
    echo "json_output: false" >> "$CONFIG"
  fi
else
  cat > "$CONFIG" <<'EOF'
rules_file:
  - /etc/falco/falco_rules.yaml
  - /etc/falco/rules.d

json_output: false
log_stderr: true
log_syslog: true
log_level: info
priority: debug
EOF
fi

echo ""
echo "Setup complete:"
echo "  - Falco installed (validate rules with: falco -V $RULES_DIR/custom-rules.yaml)"
echo "  - Rules file:  $RULES_DIR/custom-rules.yaml  (has placeholders — fix it)"
echo "  - Config file: $CONFIG  (json_output is false — enable it)"
echo ""
echo "Tip: after fixing, dry-run validate the ruleset:  falco -V $RULES_DIR/custom-rules.yaml"
