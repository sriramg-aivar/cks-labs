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

Write a Falco rule and fix Falco config on the controlplane node:

1. In `/opt/falco/rules.d/custom-rules.yaml`, replace the placeholder with a rule named
   `Read sensitive file shadow` that fires when any process reads `/etc/shadow`. The
   alert output must include the timestamp, user, process name, and container ID, and the
   rule priority must be WARNING.
2. In `/opt/falco/falco.yaml`, enable JSON output.

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
