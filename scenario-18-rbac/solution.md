# Solution: Scenario 18

## Create the Role (pods read-only in project-x)
```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: project-x
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
YAML
```

## Bind it to the ServiceAccount
```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: app-reader-binding
  namespace: project-x
subjects:
  - kind: ServiceAccount
    name: app-reader
    namespace: project-x
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
YAML
```

Or the imperative shortcut:
```bash
kubectl -n project-x create role pod-reader --verb=get,list,watch --resource=pods
kubectl -n project-x create rolebinding app-reader-binding \
  --role=pod-reader --serviceaccount=project-x:app-reader
```

## Test AFTER fix
```bash
kubectl auth can-i list pods --as=system:serviceaccount:project-x:app-reader -n project-x   # yes
kubectl auth can-i delete pods --as=system:serviceaccount:project-x:app-reader -n project-x # no
kubectl auth can-i get secrets --as=system:serviceaccount:project-x:app-reader -n project-x # no
```

## Exam tips
- `Role` + `RoleBinding` = namespace-scoped. `ClusterRole` + `ClusterRoleBinding` = cluster-wide.
- Pods are in the **core API group** — use `apiGroups: [""]` (empty string).
- Least privilege = grant ONLY the verbs/resources needed, nothing more.
- `kubectl auth can-i <verb> <resource> --as=system:serviceaccount:<ns>:<sa>` is the fastest way to test RBAC.
- The subject `kind: ServiceAccount` must include its `namespace` in the binding.
- You can bind a ClusterRole with a RoleBinding to scope cluster-wide permissions to one namespace.
