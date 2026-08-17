# 🔐 CKS Practice Labs

Practice all **16 CKS (Certified Kubernetes Security Specialist) exam scenarios** locally on your machine using a `kind` cluster with **Calico CNI** (real NetworkPolicy enforcement).

One interactive script. Sequential flow. See the question, solve it, check your answer, see the solution if stuck.

---

## Prerequisites

| Tool | Install |
|------|---------|
| Docker | [docker.com](https://docs.docker.com/get-docker/) |
| kind | `brew install kind` |
| kubectl | `brew install kubectl` |

Make sure Docker is running before you start.

---

## Setup (one time)

```bash
git clone <this-repo>
cd cks-labs

# Create the cluster (takes ~2 min)
cd cluster
./create-cluster.sh
cd ..
```

This creates:
- 2-node kind cluster (`cks-lab-control-plane` + `cks-lab-worker`)
- **Calico CNI** installed (NetworkPolicies are actually enforced)
- **Cilium CRDs** installed (for scenario 14 — CiliumNetworkPolicy YAML validation)

---

## Usage

```bash
./cks.sh
```

That's it. You'll see:

```
╔═══════════════════════════════════════════════════════════════╗
║            CKS Practice Labs - Study Mode                     ║
╚═══════════════════════════════════════════════════════════════╝

  Progress: 0/16 completed

  ▶ Scenario 01/16: Kubelet & etcd Security

  Options:
    [t] Show Task (question)
    [s] Show Solution
    [r] Run/Setup this scenario
    [c] Check my answer
    [x] Reset (cleanup) scenario
    [d] Mark done & next →
    [n] Next scenario →
    [p] Previous scenario ←
    [l] List all scenarios
    [q] Quit
```

### How to study each scenario:

1. **`[r]`** — Setup the scenario (creates pods, breaks configs, etc.)
2. **`[t]`** — Read the task (exam-style question stays on screen while you work)
3. **Solve it** — Open another terminal, use `kubectl`, edit files, fix things
4. **`[c]`** — Check your answer (automated validation)
5. **`[s]`** — View solution (if stuck)
6. **`[d]`** — Mark done, move to next

### Jump to a specific scenario:

```bash
./cks.sh 07    # jump directly to scenario 7
```

### Progress is saved

Quit anytime with `[q]`. When you come back, `./cks.sh` resumes where you left off.

---

## All 16 Scenarios

| # | Topic | What you do |
|---|-------|-------------|
| 01 | Kubelet & etcd Security | Fix kubelet config + etcd flags on node |
| 02 | TLS Secret Creation | Create kubernetes.io/tls secret |
| 03 | Dockerfile Security | Fix Dockerfile USER + Deployment securityContext |
| 04 | Falco Runtime Security | Write Falco rules + config |
| 05 | Container Security Context | Fix securityContext (immutability) |
| 06 | Audit Logging | Configure API server audit flags + volumes |
| 07 | NetworkPolicy | Write NetworkPolicy (ingress deny + allow) |
| 08 | Ingress TLS | Create Ingress with TLS termination |
| 09 | ServiceAccount Token | Disable automount + projected volume |
| 10 | kubeadm Node Upgrade | Drain / upgrade / uncordon worker node |
| 11 | SPDX/BOM Analysis | Use bom tool to find vulnerable image |
| 12 | Restricted Pod Security | Fix pod spec for restricted PSS |
| 13 | Container Daemon Hardening | Fix daemon.json + socket permissions |
| 14 | Cilium Network Policy | Write CiliumNetworkPolicy with mTLS |
| 15 | ImagePolicyWebhook | Configure admission plugin (fail closed) |
| 16 | API Server Auth | Fix anonymous-auth + authorization-mode |

---

## Working with the cluster

Most scenarios use `kubectl` normally. For scenarios that edit node-level files (kubelet, API server, etcd):

```bash
# SSH into the control-plane node
docker exec -it cks-lab-control-plane bash

# Common paths inside:
/var/lib/kubelet/config.yaml              # kubelet config
/etc/kubernetes/manifests/kube-apiserver.yaml   # API server static pod
/etc/kubernetes/manifests/etcd.yaml        # etcd static pod
```

Saving a static pod manifest auto-restarts it (kubelet watches the directory).

---

## Manual mode (optional)

You can also run individual scripts directly:

```bash
./run.sh 07        # setup scenario 7
./check.sh 07      # check your answer
./reset.sh 07      # cleanup/reset
```

---

## Tear down

```bash
cd cluster
./destroy-cluster.sh
```

---

## Tips for the real CKS exam

- **Practice each scenario until < 5 minutes** — speed matters
- **kubernetes.io/docs is allowed** — know where things are
- **Do a timed full run** — all 16 in < 90 minutes is the goal
- **Know both forms** — CLI flags vs config files (kubelet, apiserver)
- **`kubectl explain`** is your friend for YAML fields
- **Don't overthink** — most answers are 5-10 lines of YAML or 2-3 commands

---

## File Structure

```
cks-labs/
├── cks.sh                    # ← Main entry point (interactive runner)
├── cluster/
│   ├── create-cluster.sh     # One-time cluster setup
│   ├── destroy-cluster.sh    # Tear down
│   ├── kind-config.yaml      # Kind cluster config (Calico)
│   └── cilium-crd.yaml       # Cilium CRD for scenario 14
├── scenario-01-kubelet-etcd/
│   ├── TASK.md               # Question (exam-style)
│   ├── solution.md           # Full solution with explanation
│   ├── setup.sh              # Sets up the broken state
│   ├── cleanup.sh            # Resets everything
│   └── check.sh              # Validates your answer (if available)
├── scenario-02-tls-secret/
│   └── ...
├── ...
└── scenario-16-apiserver-auth/
    └── ...
```

Each scenario folder has the same structure. `check.sh` exists for most scenarios — it validates your work automatically.
