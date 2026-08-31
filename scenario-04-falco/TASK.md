# Scenario 4: Falco Runtime Security

> Falco is installed by the setup script. The config lives in `/etc/falco/`
> (if Falco isn't installed, the files are under `/opt/falco/` instead).
> This scenario uses `/etc/falco` paths below — adjust to `/opt/falco` if needed.

## Test BEFORE fix
```bash
# Falco is installed
falco --version

# Rules file has placeholder values (not real rules)
cat /etc/falco/rules.d/custom-rules.yaml
# Shows: CHANGEME everywhere

# json_output is disabled
grep 'json_output' /etc/falco/falco.yaml
# Shows: json_output: false
```

## Task

Write a Falco rule and fix the Falco config:

1. In `/etc/falco/rules.d/custom-rules.yaml`, replace the placeholder with a rule named
   `Read sensitive file shadow` that fires when any process reads `/etc/shadow`. The
   alert output must include the timestamp, user, process name, and container ID, and the
   rule priority must be WARNING.
2. In `/etc/falco/falco.yaml`, enable JSON output.

## Test AFTER fix
```bash
# Validate your ruleset syntax with Falco itself
falco -V /etc/falco/rules.d/custom-rules.yaml
# Should say: Ok / validation successful

# Rule should have correct name + condition + priority
grep 'Read sensitive file shadow' /etc/falco/rules.d/custom-rules.yaml
grep 'open_read'  /etc/falco/rules.d/custom-rules.yaml
grep '/etc/shadow' /etc/falco/rules.d/custom-rules.yaml
grep 'WARNING' /etc/falco/rules.d/custom-rules.yaml

# JSON output enabled
grep 'json_output: true' /etc/falco/falco.yaml

# (optional) dry-run Falco to load rules and confirm no errors
falco -U 2>&1 | head -20
```
