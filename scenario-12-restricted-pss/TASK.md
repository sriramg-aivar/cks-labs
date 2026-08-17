# Scenario 12: Restricted Pod Security Standard

Namespace `locked-down` enforces the `restricted` Pod Security Standard. Deployment
`noncompliant-app` in that namespace is failing to create pods. Fix the Deployment's pod
spec so it satisfies `restricted` (don't touch the namespace label).
