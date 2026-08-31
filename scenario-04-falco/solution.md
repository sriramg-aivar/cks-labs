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
# Validate the ruleset with Falco itself
falco -V /etc/falco/rules.d/custom-rules.yaml

grep 'Read sensitive file shadow' /etc/falco/rules.d/custom-rules.yaml
grep 'open_read' /etc/falco/rules.d/custom-rules.yaml
grep '/etc/shadow' /etc/falco/rules.d/custom-rules.yaml
grep 'WARNING' /etc/falco/rules.d/custom-rules.yaml
grep 'json_output: true' /etc/falco/falco.yaml

# (optional) load rules and dry-run Falco
falco -U 2>&1 | head
```

## Exam tips
- Falco condition syntax: `open_read` = file opened for reading, `fd.name` = file descriptor path
- Output fields: `%evt.time`, `%user.name`, `%proc.name`, `%container.id`, `%container.name`
- Priority levels: EMERGENCY, ALERT, CRITICAL, ERROR, WARNING, NOTICE, INFO, DEBUG
- Rules in `/etc/falco/rules.d/` override/extend the default ruleset
- `json_output: true` makes output machine-parseable
- `falco -V <file>` validates a rules file; `falco -L` lists loaded rules; `falco -U` runs with updated rules
- Note: `/opt/falco` paths are used only if Falco couldn't be installed (fallback)
