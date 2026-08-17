# Solution: Scenario 4

**Custom rule** (`/opt/falco/rules.d/custom-rules.yaml`):
```yaml
- rule: Read sensitive file shadow
  desc: Detect any process reading /etc/shadow
  condition: open_read and fd.name = "/etc/shadow"
  output: "%evt.time %user.name %proc.name %container.id"
  priority: WARNING
  tags: [filesystem, mitre_credential_access]
```

**Enable JSON output** (`/opt/falco/falco.yaml`):
```yaml
json_output: true
```

Key exam tips:
- Falco condition syntax: `open_read` = file opened for reading, `fd.name` = file descriptor name
- Output fields: `%evt.time`, `%user.name`, `%proc.name`, `%container.id`, `%container.name`
- Priority levels: EMERGENCY, ALERT, CRITICAL, ERROR, WARNING, NOTICE, INFO, DEBUG
- `json_output: true` makes Falco output machine-parseable (often asked in CKS)
- Rules in `/etc/falco/rules.d/` override/extend the default ruleset
