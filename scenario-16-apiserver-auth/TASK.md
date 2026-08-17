# Scenario 16: API server authentication

Reconfigure kube-apiserver on the control-plane node so that:
- Anonymous access is disabled
- Authorization mode is `Node,RBAC`
- The `NodeRestriction` admission controller is enabled
