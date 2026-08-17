# Scenario 14: Cilium Network Policy

(Requires Cilium as CNI — see setup.sh output if not installed.)

In namespace `svc-ns`, Deployment `secure-svc` should:
- Be reachable by pods in namespace `client-ns` with mutual authentication (mTLS) required
- Also be reachable from the host itself, WITHOUT requiring mutual auth

Write a CiliumNetworkPolicy that expresses both rules.
