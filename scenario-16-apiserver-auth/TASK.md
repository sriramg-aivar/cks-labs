# Scenario 16: API server authentication

Reconfigure kube-apiserver on the controlplane node so that:
- Anonymous access is disabled (`--anonymous-auth=false`)
- Authorization mode is `Node,RBAC`
- The `NodeRestriction` admission controller is enabled

Edit: `/etc/kubernetes/manifests/kube-apiserver.yaml`
