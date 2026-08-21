# Scenario 11: Generate SPDX document (bom tool)

## Before you start
```bash
# Check the deployment and its images
kubectl get deployment multi-arch-app -o yaml | grep image:

# Verify bom tool is available
which bom && bom version

# Check how many containers the deployment has
kubectl get deployment multi-arch-app -o jsonpath='{.spec.template.spec.containers[*].name}'
```

## Task

Deployment `multi-arch-app` (namespace `default`) has 2 containers, each using a
different alpine-based image. One of them bundles a vulnerable `libcrypto3`.

1. Use `bom generate --image <image>` to create SPDX docs for each image
2. Find which image contains `libcrypto3`
3. Remove that container from the Deployment

## Verify
```bash
# Deployment should now have only 1 container
kubectl get deployment multi-arch-app -o jsonpath='{.spec.template.spec.containers[*].name}'
# Should output only one container name

# The remaining image should NOT contain libcrypto3
# (you can re-run bom on it to confirm)

# Pod should be running with 1 container
kubectl get pods -l app=multi-arch-app
```
