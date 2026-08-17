# Scenario 11: Generate SPDX document (bom tool)

Deployment `multi-arch-app` (namespace `default`) has 2 containers, each using a different
alpine-based image. One of them bundles a vulnerable `libcrypto3`. Using `bom`, generate
an SPDX doc for each image, find which one contains `libcrypto3`, and remove that
container from the Deployment.
