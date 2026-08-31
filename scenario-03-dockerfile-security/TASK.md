# Scenario 3: Dockerfile security

The scenario files are in `~/cks-work/scenario-03/` — `cd` there first:
```bash
cd ~/cks-work/scenario-03
```

## Test BEFORE fix
```bash
# Dockerfile runs as root (no USER line)
cat ~/cks-work/scenario-03/Dockerfile | grep -i USER
# Shows nothing — runs as root!

# Deployment has insecure securityContext
kubectl get deployment hardened-app -o jsonpath='{.spec.template.spec.containers[0].securityContext}'
# Shows: runAsUser:0, privileged:true, readOnlyRootFilesystem:false
```

## Task

A `Dockerfile` in `~/cks-work/scenario-03/` runs as root. Harden it and the running workload:

1. Edit `~/cks-work/scenario-03/Dockerfile` so the container runs as the `nobody` user.
2. Edit Deployment `hardened-app` (namespace `default`) so its container runs as
   non-root UID `65535`, uses a read-only root filesystem, and is not privileged.
3. Apply your changes: `kubectl apply -f ~/cks-work/scenario-03/deployment.yaml`

## Test AFTER fix
```bash
# Dockerfile should have USER nobody
grep 'USER nobody' ~/cks-work/scenario-03/Dockerfile
# Should match

# Deployment securityContext should be secure
kubectl get deployment hardened-app -o jsonpath='{.spec.template.spec.containers[0].securityContext.runAsUser}'
# Should show: 65535

kubectl get deployment hardened-app -o jsonpath='{.spec.template.spec.containers[0].securityContext.readOnlyRootFilesystem}'
# Should show: true

kubectl get deployment hardened-app -o jsonpath='{.spec.template.spec.containers[0].securityContext.privileged}'
# Should show: false
```
