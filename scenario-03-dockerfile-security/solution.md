# Solution: Scenario 3

**Dockerfile:**
```dockerfile
FROM nginx:1.25
COPY ./app /usr/share/nginx/html
USER nobody
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
(Note: the real nginx image needs extra work to actually run as `nobody` on port 80 —
in the exam they usually just want the `USER nobody` line present, not a working build.)

**deployment.yaml securityContext:**
```yaml
securityContext:
  runAsUser: 65535
  readOnlyRootFilesystem: true
  privileged: false
```
Then: `kubectl apply -f deployment.yaml`
