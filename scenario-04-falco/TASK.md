# Scenario 4: Falco Runtime Security

A pod `suspicious-pod` in namespace `monitoring` is accessing sensitive paths.

Your tasks:
1. A Falco rules file template exists at `/opt/falco/rules.d/custom-rules.yaml` on the
   control-plane node. Edit it to add a rule that:
   - Detects any process opening `/etc/shadow` for reading
   - Output should include: timestamp, user, process name, container ID
   - Priority: WARNING
   - Rule name: "Read sensitive file shadow"

2. The file `/opt/falco/falco.yaml` on the control-plane node has `json_output` disabled.
   Enable it.

Note: Falco is not running on this kind cluster — this scenario tests your ability to
write correct Falco configuration and rules (which is what the CKS exam grades).
