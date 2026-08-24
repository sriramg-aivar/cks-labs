# Scenario 4: Falco Runtime Security

## Test BEFORE fix
```bash
# Rules file has placeholder values (not real rules)
cat /opt/falco/rules.d/custom-rules.yaml
# Shows: CHANGEME everywhere

# json_output is disabled
grep 'json_output' /opt/falco/falco.yaml
# Shows: json_output: false
```

## Task

1. Edit `/opt/falco/rules.d/custom-rules.yaml` — write a rule:
   - **Rule name:** `Read sensitive file shadow`
   - **Condition:** `open_read and fd.name = "/etc/shadow"`
   - **Output:** `"%evt.time %user.name %proc.name %container.id"`
   - **Priority:** `WARNING`

2. Edit `/opt/falco/falco.yaml` — set `json_output: true`

## Test AFTER fix
```bash
# Rule should have correct name
grep 'Read sensitive file shadow' /opt/falco/rules.d/custom-rules.yaml
# Should match

# Condition should use open_read
grep 'open_read' /opt/falco/rules.d/custom-rules.yaml
# Should match

# Should reference /etc/shadow
grep '/etc/shadow' /opt/falco/rules.d/custom-rules.yaml
# Should match

# Priority WARNING
grep 'WARNING' /opt/falco/rules.d/custom-rules.yaml
# Should match

# JSON output enabled
grep 'json_output: true' /opt/falco/falco.yaml
# Should match
```
