# Scenario 11: SPDX/BOM Analysis

## Test BEFORE fix
```bash
# Deployment has 2 containers
kubectl get deployment multi-arch-app -o jsonpath='{.spec.template.spec.containers[*].name}'
# Shows: side-a side-b

# Check the images
kubectl get deployment multi-arch-app -o jsonpath='{.spec.template.spec.containers[*].image}'
# Shows: alpine:3.19.1 alpine:3.18.4
```

## Task

1. Use `bom generate --image <image>` for each alpine image
2. `grep` the SPDX output for `libcrypto3`
3. Remove the container with the vulnerable image from the Deployment

## Test AFTER fix
```bash
# Only 1 container should remain
kubectl get deployment multi-arch-app -o jsonpath='{.spec.template.spec.containers[*].name}'
# Should show only ONE name (the safe one)

# Pod should be running
kubectl get pods -l app=multi-arch-app
# Should show: Running, 1/1
```
