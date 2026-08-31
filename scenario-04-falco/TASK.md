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
# Validate your ruleset syntax with Falco.
# IMPORTANT: load the BASE rules file too, because your rule uses macros
# like `open_read` that are DEFINED in the default ruleset.
falco -V /etc/falco/falco_rules.yaml -V /etc/falco/rules.d/custom-rules.yaml
# Should say: Ok / rules loaded successfully

# Confirm your rule was actually loaded (list rules)
falco -L 2>/dev/null | grep 'Read sensitive file shadow'
# Should print your rule name

# Rule should have correct name + condition + priority
grep 'Read sensitive file shadow' /etc/falco/rules.d/custom-rules.yaml
grep 'open_read'  /etc/falco/rules.d/custom-rules.yaml
grep '/etc/shadow' /etc/falco/rules.d/custom-rules.yaml
grep 'WARNING' /etc/falco/rules.d/custom-rules.yaml

# JSON output enabled
grep 'json_output: true' /etc/falco/falco.yaml
```

### Note on `falco -U`
`falco -U` **runs the engine** and only prints an alert **when the rule fires** — i.e.
when a process actually reads `/etc/shadow`. It does NOT list your rules, so
`falco -U | grep 'Read sensitive file shadow'` shows nothing unless the rule triggers.

To see it fire live: run Falco in one terminal, then trigger it in another:
```bash
# Terminal 1
falco
# Terminal 2 — trigger the rule
cat /etc/shadow
# Terminal 1 should now print a WARNING alert with your rule name
```
Use `falco -L` to LIST loaded rules, and `falco -V ...` to VALIDATE syntax.
