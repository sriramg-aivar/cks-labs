# Scenario 9: Disable API credential auto-mounting

ServiceAccount `restricted-sa` (namespace `default`) currently auto-mounts its token into
every pod that uses it. Fix it so:
- `automountServiceAccountToken: false` on the ServiceAccount
- Deployment `token-app` (uses `restricted-sa`) instead mounts the token manually via a
  read-only **projected volume**
