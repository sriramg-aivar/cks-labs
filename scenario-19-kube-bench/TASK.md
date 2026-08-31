# Scenario 19: CIS Benchmark with kube-bench

## Test BEFORE fix
```bash
# kube-bench is installed by setup (check it exists)
which kube-bench

# The kubelet config file has insecure permissions (should be 600 or stricter)
stat -c "%a %n" /var/lib/kubelet/config.yaml
# Shows: 644 (world-readable — FAILS CIS check 4.1.9)

# Run kube-bench against the node and see the FAIL
kube-bench run --targets node 2>/dev/null | grep -A2 "4.1.9"
# Shows: [FAIL] 4.1.9 ... kubelet config file permissions
```

## Task

A CIS Kubernetes Benchmark scan (via `kube-bench`) reports a FAIL for the kubelet
configuration file permissions on this node.

The CIS control **4.1.9** requires that the kubelet config file
(`/var/lib/kubelet/config.yaml`) has permissions set to `600` or more restrictive.

Fix the file permissions so this control passes.

## Test AFTER fix
```bash
# File permissions should now be 600 (or stricter like 400)
stat -c "%a %n" /var/lib/kubelet/config.yaml
# Should show: 600

# kube-bench check 4.1.9 should now PASS
kube-bench run --targets node 2>/dev/null | grep "4.1.9"
# Should show: [PASS] 4.1.9 ...
```
