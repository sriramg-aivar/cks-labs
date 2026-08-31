# Solution: Scenario 20

## Step 1: Scan the current (vulnerable) image
```bash
trivy image --severity HIGH,CRITICAL nginx:1.19
```

## Step 2: Scan the candidate replacement
```bash
trivy image --severity HIGH,CRITICAL nginx:1.27
```

## Step 3: Update the deployment to the patched image
```bash
kubectl -n shop set image deployment/storefront nginx=nginx:1.27
kubectl -n shop rollout status deployment/storefront
```
(Or `kubectl -n shop edit deployment storefront` and change the image field.)

## Test AFTER fix
```bash
kubectl -n shop get deployment storefront -o jsonpath='{.spec.template.spec.containers[0].image}'  # nginx:1.27
kubectl -n shop get pods
```

## Exam tips
- `trivy image <image>` scans a container image for CVEs.
- `--severity HIGH,CRITICAL` filters to the vulns that matter most.
- `--ignore-unfixed` shows only vulnerabilities that have a fix available (useful for prioritizing).
- `trivy image --exit-code 1 --severity CRITICAL <image>` fails (exit 1) if any CRITICAL found — great for CI gates.
- The fix is almost always: bump to a newer image tag that patches the CVEs.
- `kubectl set image deployment/<name> <container>=<image>` is the fast way to update.
- trivy can also scan filesystems (`trivy fs`) and k8s clusters (`trivy k8s`).
