# Solution: Scenario 19

## Fix the kubelet config file permissions
```bash
chmod 600 /var/lib/kubelet/config.yaml
```

(For the kubelet CIS controls you also often need the file owned by root:)
```bash
chown root:root /var/lib/kubelet/config.yaml
```

## Re-run kube-bench to confirm
```bash
kube-bench run --targets node 2>/dev/null | grep "4.1.9"
# [PASS] 4.1.9 Ensure that the kubelet --config file permissions are set to 600 or more restrictive
```

## Test AFTER fix
```bash
stat -c "%a %n" /var/lib/kubelet/config.yaml   # 600
kube-bench run --targets node 2>/dev/null | grep "4.1.9"
```

## Exam tips
- `kube-bench` runs the CIS Kubernetes Benchmark and reports [PASS]/[FAIL]/[WARN] per control.
- `kube-bench run --targets node` = node-level checks (kubelet, config files).
  `--targets master` = control-plane checks (apiserver, etcd, scheduler manifests).
- Common CIS fixes are `chmod`/`chown` on files, or editing flags in static pod manifests.
- Permission rule of thumb: config files `600`, ownership `root:root`.
- Read the FAIL output — kube-bench tells you the exact remediation command.
- Other frequent controls: `/etc/kubernetes/manifests/*.yaml` should be `600` + `root:root`.
