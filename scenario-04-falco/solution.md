# Solution: Scenario 4

## Custom rule (`/opt/falco/rules.d/custom-rules.yaml`)
```yaml
- rule: Read sensitive file shadow
  desc: Detect any process reading /etc/shadow
  condition: open_read and fd.name = "/etc/shadow"
  output: "%evt.time %user.name %proc.name %container.id"
  priority: WARNING
  tags: [filesystem, mitre_credential_access]
```

## Enable JSON output (`/opt/falco/falco.yaml`)
Change:
```yaml
json_output: true
```

## Verify
```bash
grep 'Read sensitive file shadow' /opt/falco/rules.d/custom-rules.yaml
grep 'open_read' /opt/falco/rules.d/custom-rules.yaml
grep '/etc/shadow' /opt/falco/rules.d/custom-rules.yaml
grep 'WARNING' /opt/falco/rules.d/custom-rules.yaml
grep 'json_output: true' /opt/falco/falco.yaml
```

## Exam tips
- Falco condition syntax: `open_read` = file opened for reading, `fd.name` = file descriptor path
- Output fields: `%evt.time`, `%user.name`, `%proc.name`, `%container.id`, `%container.name`
- Priority levels: EMERGENCY, ALERT, CRITICAL, ERROR, WARNING, NOTICE, INFO, DEBUG
- Rules in `/etc/falco/rules.d/` override/extend the default ruleset
- `json_output: true` makes output machine-parseable
