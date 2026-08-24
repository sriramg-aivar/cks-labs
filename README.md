# 🔐 CKS Practice Labs

Practice all **16 CKS exam scenarios** on a real **kubeadm cluster** (2 nodes: controlplane + worker).

Designed for **Killercoda** CKS playgrounds — or any kubeadm cluster with 2 nodes.

---

## Quick Start (Killercoda)

```bash
# 1. Open a Killercoda CKS/Kubernetes playground (2 nodes)
# 2. Clone this repo on the controlplane node:
git clone <this-repo>
cd cks-labs

# 3. One-time setup (verifies cluster, installs Cilium CRDs):
cd cluster && ./create-cluster.sh && cd ..

# 4. Start studying:
./cks.sh
```

---

## How it works

```
╔═══════════════════════════════════════════════════════════════╗
║            CKS Practice Labs - Study Mode                     ║
╚═══════════════════════════════════════════════════════════════╝

  Progress: 0/16 completed

  ▶ Scenario 01/16: Kubelet & etcd Security

  Options:
    [r] Run/Setup this scenario
    [t] Show Task (question)
    [s] Show Solution
    [c] Check my answer
    [x] Reset (cleanup) scenario
    [d] Mark done & next →
    [n] Next scenario →
    [p] Previous scenario ←
    [l] List all scenarios
    [q] Quit
```

### Workflow:
1. **`[r]`** — Setup scenario (breaks configs, creates resources)
2. **Task shows on screen** — solve it in another terminal tab
3. **`[c]`** — Check your answer (automated validation)
4. **`[s]`** — View solution if stuck
5. **`[d]`** — Mark done, move to next

Progress is saved. Quit with `[q]` (asks to save or reset progress).

---

## All 16 Scenarios

| # | Topic | What you do |
|---|-------|-------------|
| 01 | Kubelet & etcd Security | Fix kubelet config + etcd flags |
| 02 | TLS Secret Creation | Create kubernetes.io/tls secret |
| 03 | Dockerfile Security | Fix Dockerfile + Deployment securityContext |
| 04 | Falco Runtime Security | Write Falco rules + config |
| 05 | Container Security Context | Fix securityContext (immutability) |
| 06 | Audit Logging | Configure API server audit flags + volumes |
| 07 | NetworkPolicy | Write NetworkPolicy (ingress deny + allow) |
| 08 | Ingress TLS | Create Ingress with TLS termination |
| 09 | ServiceAccount Token | Disable automount + projected volume |
| 10 | kubeadm Node Upgrade | Drain / upgrade / uncordon worker |
| 11 | SPDX/BOM Analysis | Use bom tool to find vulnerable image |
| 12 | Restricted Pod Security | Fix pod spec for restricted PSS |
| 13 | Container Daemon Hardening | Fix daemon.json + socket permissions |
| 14 | Cilium Network Policy | Write CiliumNetworkPolicy |
| 15 | ImagePolicyWebhook | Configure admission (fail closed) |
| 16 | API Server Auth | Fix anonymous-auth + authorization-mode |

---

## Cluster Info

| Node | Role | Access |
|------|------|--------|
| controlplane | Control plane | You're on it |
| node01 | Worker | `ssh node01` |

**Key paths (on controlplane):**
```
/var/lib/kubelet/config.yaml              # kubelet config
/etc/kubernetes/manifests/kube-apiserver.yaml   # API server static pod
/etc/kubernetes/manifests/etcd.yaml        # etcd static pod
```

Saving a static pod manifest auto-restarts it (~30-60s).

---

## Tips for CKS Exam

- Practice each scenario until < 5 minutes
- kubernetes.io/docs is allowed — know where things are
- Do a timed full run — all 16 in < 90 minutes
- `kubectl explain` is your friend
- Know both CLI flags and config file formats
- Most answers are 5-10 lines of YAML or 2-3 commands

---

## File Structure

```
cks-labs/
├── cks.sh                    # ← Interactive runner
├── cluster/
│   ├── create-cluster.sh     # Verify cluster + install CRDs
│   └── cilium-crd.yaml       # Cilium CRD for scenario 14
├── scenario-01-kubelet-etcd/
│   ├── TASK.md               # Exam-style question
│   ├── solution.md           # Full solution
│   ├── setup.sh              # Breaks things
│   ├── cleanup.sh            # Resets
│   └── check.sh              # Validates answer
├── ...
└── scenario-16-apiserver-auth/
```

---

## Troubleshooting

### "connection refused" / kubectl not working

If you see `connection refused` or `Unable to connect to the server`, the API server is down.
This commonly happens after scenarios that edit `/etc/kubernetes/manifests/kube-apiserver.yaml`
(scenarios 1, 6, 15, 16).

```bash
# Check apiserver container
crictl ps -a | grep kube-apiserver

# Check logs for errors
crictl logs $(crictl ps -a --name kube-apiserver -q | head -1) 2>&1 | tail -20

# Common fixes:
# 1. Check for YAML syntax errors in the manifest
cat /etc/kubernetes/manifests/kube-apiserver.yaml

# 2. Check for trailing commas in --enable-admission-plugins
# 3. Check volume/volumeMount paths exist

# 4. Restart kubelet to force re-read
systemctl restart kubelet
sleep 30
kubectl get nodes
```

### Scenario won't set up (AlreadyExists errors)

Run reset first: press `[x]` in the menu, then `[r]` again.

### Pods stuck in ContainerCreating

```bash
kubectl describe pod <pod-name> -n <namespace>
# Check Events section for the actual error
```