# Scenario 3: Dockerfile security best practices

A Dockerfile at `Dockerfile` in this folder currently runs as root. Fix it to run as user
`nobody`. Then fix the accompanying Deployment (`deployment.yaml`, already applied to the
cluster as `hardened-app` in namespace `default`) so its pod spec sets:
```
runAsUser: 65535
readOnlyRootFilesystem: true
privileged: false
```
(You don't need to actually build the image — focus on getting the Deployment's
securityContext correct and re-applying it.)
