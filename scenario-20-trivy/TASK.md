# Scenario 20: Image Vulnerability Scanning with Trivy

## Test BEFORE fix
```bash
# trivy is installed by setup (check it exists)
which trivy

# The deployment uses a known-vulnerable old image
kubectl -n shop get deployment storefront -o jsonpath='{.spec.template.spec.containers[0].image}'
# Shows: nginx:1.19  (old, many HIGH/CRITICAL CVEs)

# Scan it — you'll see HIGH/CRITICAL vulnerabilities
trivy image --severity HIGH,CRITICAL nginx:1.19 2>/dev/null | grep Total
# Shows a high count of vulnerabilities
```

## Task

The Deployment `storefront` in namespace `shop` runs an old, vulnerable image.

1. Use `trivy` to scan the current image and confirm it has HIGH/CRITICAL vulnerabilities.
2. Also scan the newer image `nginx:1.27` to confirm it has fewer (or none).
3. Update the `storefront` deployment to use `nginx:1.27` so it no longer runs the
   vulnerable image.

## Test AFTER fix
```bash
# Deployment should now use the patched image
kubectl -n shop get deployment storefront -o jsonpath='{.spec.template.spec.containers[0].image}'
# Should show: nginx:1.27

# Pod running the new image
kubectl -n shop get pods
# Should show: Running

# Scan of the new image should have far fewer HIGH/CRITICAL CVEs
trivy image --severity HIGH,CRITICAL nginx:1.27 2>/dev/null | grep Total
```
