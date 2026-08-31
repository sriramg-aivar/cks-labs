# Scenario 18: RBAC Least Privilege

## Test BEFORE fix
```bash
# The ServiceAccount exists
kubectl -n project-x get sa app-reader

# It currently has NO permissions — these should all say "no"
kubectl auth can-i get pods --as=system:serviceaccount:project-x:app-reader -n project-x
# no
kubectl auth can-i list pods --as=system:serviceaccount:project-x:app-reader -n project-x
# no

# And it must NOT be able to do anything cluster-wide or write
kubectl auth can-i delete pods --as=system:serviceaccount:project-x:app-reader -n project-x
# no
```

## Task

ServiceAccount `app-reader` in namespace `project-x` needs **least-privilege** read access.

Grant it permission to **only**:
- `get`, `list`, and `watch` **pods** in the `project-x` namespace

It must NOT be able to:
- read or write any other resource (secrets, deployments, etc.)
- create, update, or delete pods
- access any other namespace

Use a `Role` + `RoleBinding` (namespace-scoped, not cluster-wide).

## Test AFTER fix
```bash
# These should now say "yes"
kubectl auth can-i get pods --as=system:serviceaccount:project-x:app-reader -n project-x
# yes
kubectl auth can-i list pods --as=system:serviceaccount:project-x:app-reader -n project-x
# yes
kubectl auth can-i watch pods --as=system:serviceaccount:project-x:app-reader -n project-x
# yes

# These should still say "no" (least privilege)
kubectl auth can-i delete pods --as=system:serviceaccount:project-x:app-reader -n project-x
# no
kubectl auth can-i get secrets --as=system:serviceaccount:project-x:app-reader -n project-x
# no
kubectl auth can-i get pods --as=system:serviceaccount:project-x:app-reader -n default
# no (other namespace)
```
