# Scenario 4: Falco Runtime Security

## Before you start
```bash
# Check the template rules file
cat /opt/falco/rules.d/custom-rules.yaml

# Check current falco config
cat /opt/falco/falco.yaml

# Check the suspicious pod exists
kubectl -n monitoring get pods
```

## Task

1. Edit `/opt/falco/rules.d/custom-rules.yaml` to add a rule that:
   - **Rule name:** `Read sensitive file shadow`
   - **Detects:** any process opening `/etc/shadow` for reading
   - **Condition:** use `open_read` and `fd.name`
   - **Output:** include timestamp (`%evt.time`), user (`%user.name`), process name (`%proc.name`), container ID (`%container.id`)
   - **Priority:** `WARNING`

2. Edit `/opt/falco/falco.yaml`:
   - Set `json_output: true`

## Verify
```bash
# Rule file should have correct rule name
grep 'Read sensitive file shadow' /opt/falco/rules.d/custom-rules.yaml

# Should have open_read in condition
grep 'open_read' /opt/falco/rules.d/custom-rules.yaml

# Should reference /etc/shadow
grep '/etc/shadow' /opt/falco/rules.d/custom-rules.yaml

# Priority should be WARNING
grep -i 'WARNING' /opt/falco/rules.d/custom-rules.yaml

# json_output should be true
grep 'json_output: true' /opt/falco/falco.yaml
```
