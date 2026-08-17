# Solution: Scenario 11

```bash
bom generate --image alpine:3.19.1 --output alpine-3191.spdx
bom generate --image alpine:3.18.4 --output alpine-3184.spdx
grep -i libcrypto3 alpine-3191.spdx alpine-3184.spdx
```

Alpine 3.19.x ships `libcrypto3` (OpenSSL 3.x) by default; 3.18.x historically used
`libcrypto1.1`. Whichever grep matches — remove that container from the Deployment:

```bash
kubectl edit deployment multi-arch-app -n default
# delete the matching container block (e.g. 'side-a' if alpine:3.19.1 is the hit)
```

Exam tip: this is really testing "can you operate the `bom` CLI and read SPDX output",
not deep SBOM knowledge — `bom generate --image <image>` is the core command to remember.
