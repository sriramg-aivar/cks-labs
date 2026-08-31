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

Deployment `multi-arch-app` (namespace `default`) has two containers using different
alpine images. One image bundles the vulnerable package `libcrypto3`.

Use the `bom` tool to generate an SPDX document for each image, identify which image
contains `libcrypto3`, and remove that container from the Deployment.

## Test AFTER fix
```bash
# Only 1 container should remain
kubectl get deployment multi-arch-app -o jsonpath='{.spec.template.spec.containers[*].name}'
# Should show only ONE name (the safe one)

# Pod should be running
kubectl get pods -l app=multi-arch-app
# Should show: Running, 1/1
```
