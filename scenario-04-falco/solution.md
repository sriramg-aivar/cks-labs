# Solution: Scenario 4

## Custom rule (`/etc/falco/rules.d/custom-rules.yaml`)
```yaml
- rule: Read sensitive file shadow
  desc: Detect any process reading /etc/shadow
  condition: open_read and fd.name = "/etc/shadow"
  output: "%evt.time %user.name %proc.name %container.id"
  priority: WARNING
  tags: [filesystem, mitre_credential_access]
```

## Enable JSON output (`/etc/falco/falco.yaml`)
Change:
```yaml
json_output: true
```

## Verify
```bash
# Validate the ruleset — load the BASE rules file too (defines open_read etc.)
falco -V /etc/falco/falco_rules.yaml -V /etc/falco/rules.d/custom-rules.yaml

# List loaded rules to confirm yours is parsed
falco -L 2>/dev/null | grep 'Read sensitive file shadow'

grep 'Read sensitive file shadow' /etc/falco/rules.d/custom-rules.yaml
grep 'open_read' /etc/falco/rules.d/custom-rules.yaml
grep '/etc/shadow' /etc/falco/rules.d/custom-rules.yaml
grep 'WARNING' /etc/falco/rules.d/custom-rules.yaml
grep 'json_output: true' /etc/falco/falco.yaml

# See it FIRE (run falco in one terminal, trigger in another):
#   Terminal 1: falco
#   Terminal 2: cat /etc/shadow   -> alert appears in Terminal 1
```

## Exam tips
- Falco condition syntax: `open_read` = file opened for reading, `fd.name` = file descriptor path
- Output fields: `%evt.time`, `%user.name`, `%proc.name`, `%container.id`, `%container.name`
- Priority levels: EMERGENCY, ALERT, CRITICAL, ERROR, WARNING, NOTICE, INFO, DEBUG
- Rules in `/etc/falco/rules.d/` override/extend the default ruleset
- `json_output: true` makes output machine-parseable
- `falco -V <base_rules> -V <your_rules>` validates syntax (load the base file so macros resolve)
- `falco -L` LISTS loaded rules; `falco -U` RUNS the engine (alerts only when a rule fires)
- To trigger this rule: run `falco`, then in another shell `cat /etc/shadow`
- Note: `/opt/falco` paths are used only if Falco couldn't be installed (fallback)
