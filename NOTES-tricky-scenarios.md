# Scenarios 4, 10, 13 — why kind doesn't fit, and what to do instead

## Scenario 4: Falco rule for /dev/mem access
Falco needs kernel-level syscall visibility (eBPF or a kernel module). kind's nodes are
just Docker containers sharing the host kernel, and running Falco reliably inside them is
finicky/unsupported in most setups. Options, easiest first:
1. **Killercoda's Falco/CKS playground** — this one scenario is genuinely a good fit for
   Killercoda, since it's a single guided lab, not something you need to reset repeatedly.
2. **Run Falco directly on your Linux host** (not in a container) against your kind
   cluster's containers — works if you're on native Linux, not WSL2/macOS.
3. Practice the **rule-writing part only**, locally: install Falco standalone (no k8s),
   and write/test a custom rule matching `open`/`openat` syscalls on `/dev/mem`. The exam
   really tests "can you write a Falco rule," and that part doesn't need Kubernetes at all.

## Scenario 10: kubeadm node upgrade
kind nodes don't run apt/kubeadm the way a real Ubuntu VM does — kind bakes fixed k8s
binaries into its node images, so `apt-get install kubeadm=X.Y.Z` doesn't work as expected.
Options:
1. **Two real VMs** (e.g. via VirtualBox + `kubeadm init`/`kubeadm join` by hand, or a
   tool like Multipass/Vagrant if you install one later) — this is the only way to
   practice the *actual* command sequence end-to-end.
2. In the meantime, **memorize and dry-run the command sequence** (you already have it
   copied from the exam recall above) — the drain/upgrade/uncordon flow is mostly
   muscle-memory, and you can rehearse it verbally/on paper against the exact syntax.
3. Killercoda has "Kubernetes the Hard Way"-style playgrounds with real multi-VM
   clusters where `kubeadm upgrade` genuinely works — worth using for this one.

## Scenario 13: Secure Docker daemon (docker group, socket ownership)
kind's nodes run **containerd**, not a Docker daemon, so there's no `/var/run/docker.sock`
or `docker` group inside them to fix.
Options:
1. Practice directly on **your host machine's Docker install** (the one you already have)
   — `sudo gpasswd -d <user> docker` and `sudo chown root:root /var/run/docker.sock` are
   real, testable commands regardless of Kubernetes.
2. Or use Killercoda's plain Ubuntu/Docker playgrounds for this one question.

**Bottom line:** these 3 are individually 5-10 minute scenarios in the real exam — you
don't need a repeatable cluster teardown loop for them, just to know the exact commands
cold. Treat them as a short manual checklist rather than lab infrastructure.
