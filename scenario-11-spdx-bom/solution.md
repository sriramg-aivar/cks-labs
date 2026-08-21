# Solution: Scenario 11

## Generate SPDX documents
```bash
bom generate --image alpine:3.19.1 --output alpine-3191.spdx
bom generate --image alpine:3.18.4 --output alpine-3184.spdx
```

## Find libcrypto3
```bash
grep -i libcrypto3 alpine-3191.spdx alpine-3184.spdx
```
Alpine 3.19.x ships `libcrypto3` (OpenSSL 3.x); 3.18.x uses `libcrypto1.1`.

## Remove the vulnerable container
```bash
kubectl edit deployment multi-arch-app
# Delete the container using alpine:3.19.1 (or whichever has libcrypto3)
```

## Verify
```bash
# Only 1 container should remain
kubectl get deployment multi-arch-app -o jsonpath='{.spec.template.spec.containers[*].name}'

# Pod should be running
kubectl get pods -l app=multi-arch-app
```

## Exam tips
- `bom generate --image <image>` is the key command
- Just `grep` the SPDX output for the package name
- Remove the CONTAINER (not the whole deployment)
- The exam tests: can you use bom CLI + read SPDX output
