#!/usr/bin/env bash
set -euo pipefail

# CKS Practice Labs - Interactive Sequential Study Mode
# Usage: ./cks.sh [scenario_number]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROGRESS_FILE="$SCRIPT_DIR/.cks-progress"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# All scenarios in order
SCENARIOS=(
  "scenario-01-kubelet-etcd"
  "scenario-02-tls-secret"
  "scenario-03-dockerfile-security"
  "scenario-04-falco"
  "scenario-05-security-context"
  "scenario-06-audit-logging"
  "scenario-07-networkpolicy"
  "scenario-08-ingress-tls"
  "scenario-09-sa-automount"
  "scenario-10-kubeadm-upgrade"
  "scenario-11-spdx-bom"
  "scenario-12-restricted-pss"
  "scenario-13-container-hardening"
  "scenario-14-cilium-policy"
  "scenario-15-imagepolicywebhook"
  "scenario-16-apiserver-auth"
  "scenario-17-istio"
  "scenario-18-rbac"
  "scenario-19-kube-bench"
  "scenario-20-trivy"
)

SCENARIO_TITLES=(
  "Kubelet & etcd Security"
  "TLS Secret Creation"
  "Dockerfile Security"
  "Falco Runtime Security"
  "Container Security Context"
  "Audit Logging"
  "NetworkPolicy"
  "Ingress TLS"
  "ServiceAccount Token"
  "kubeadm Node Upgrade"
  "SPDX/BOM Analysis"
  "Restricted Pod Security"
  "Container Daemon Hardening"
  "Cilium Network Policy"
  "ImagePolicyWebhook"
  "API Server Auth"
  "Istio Injection & mTLS"
  "RBAC Least Privilege"
  "kube-bench CIS Benchmark"
  "Trivy Image Scanning"
)

CURRENT=0
COMPLETED=()
SCENARIO_ACTIVE=false  # tracks if a scenario is currently set up
TOTAL=${#SCENARIOS[@]}  # total number of scenarios (auto-counted)
LAST_INDEX=$((TOTAL - 1))

# ─── Progress management ───────────────────────────────────────────

load_progress() {
  CURRENT=0
  COMPLETED=()
  if [ -f "$PROGRESS_FILE" ]; then
    source "$PROGRESS_FILE"
  fi
}

save_progress() {
  {
    echo "CURRENT=$CURRENT"
    if [ ${#COMPLETED[@]} -gt 0 ]; then
      echo "COMPLETED=(${COMPLETED[*]})"
    else
      echo "COMPLETED=()"
    fi
  } > "$PROGRESS_FILE"
}

is_completed() {
  local num=$1
  if [ ${#COMPLETED[@]} -eq 0 ]; then
    return 1
  fi
  for c in "${COMPLETED[@]}"; do
    [ "$c" = "$num" ] && return 0
  done
  return 1
}

mark_completed() {
  local num=$1
  if ! is_completed "$num"; then
    COMPLETED+=("$num")
    save_progress
  fi
}

reset_all_progress() {
  CURRENT=0
  COMPLETED=()
  rm -f "$PROGRESS_FILE"
}

# ─── Display functions ─────────────────────────────────────────────

clear_screen() {
  printf '\033[2J\033[H'
}

show_header() {
  local idx=$CURRENT
  local num=$((idx + 1))
  local numstr
  numstr=$(printf "%02d" $num)

  echo -e "${BOLD}${CYAN}"
  echo "╔═══════════════════════════════════════════════════════════════╗"
  echo "║            CKS Practice Labs - Study Mode                     ║"
  echo "╚═══════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"

  # Progress
  local done=${#COMPLETED[@]}
  echo -e "  Progress: ${GREEN}${done}${NC}/${TOTAL} completed"
  echo ""

  # Current scenario
  if is_completed "$idx"; then
    echo -e "  ${GREEN}▶ Scenario ${numstr}/${TOTAL}: ${SCENARIO_TITLES[$idx]} ✓${NC}"
  else
    echo -e "  ${YELLOW}▶ Scenario ${numstr}/${TOTAL}: ${SCENARIO_TITLES[$idx]}${NC}"
  fi
  echo ""
}

show_menu() {
  echo -e "  ${BOLD}Options:${NC}"
  echo -e "    ${CYAN}[r]${NC} Run/Setup this scenario"
  echo -e "    ${CYAN}[t]${NC} Show Task (question)"
  echo -e "    ${CYAN}[s]${NC} Show Solution"
  echo -e "    ${CYAN}[c]${NC} Check my answer"
  echo -e "    ${CYAN}[x]${NC} Reset (cleanup) this scenario"
  echo -e "    ${CYAN}[f]${NC} Full reset (fresh cluster — cleans ALL scenarios)"
  echo -e "    ${CYAN}[d]${NC} Mark done & next →"
  echo -e "    ${CYAN}[n]${NC} Next scenario →"
  echo -e "    ${CYAN}[p]${NC} Previous scenario ←"
  echo -e "    ${CYAN}[l]${NC} List all scenarios"
  echo -e "    ${CYAN}[q]${NC} Quit"
  echo ""
}

show_task() {
  local dir="$SCRIPT_DIR/${SCENARIOS[$CURRENT]}"
  echo ""
  echo -e "${BOLD}${BLUE}━━━ TASK ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  if [ -f "$dir/TASK.md" ]; then
    echo ""
    cat "$dir/TASK.md"
  else
    echo -e "${RED}  No TASK.md found for this scenario.${NC}"
  fi
  echo ""
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

show_solution() {
  local dir="$SCRIPT_DIR/${SCENARIOS[$CURRENT]}"
  echo ""
  echo -e "${BOLD}${GREEN}━━━ SOLUTION ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  if [ -f "$dir/solution.md" ]; then
    echo ""
    cat "$dir/solution.md"
  else
    echo -e "${RED}  No solution.md found for this scenario.${NC}"
  fi
  echo ""
  echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

# ─── Actions ───────────────────────────────────────────────────────

do_setup() {
  local dir="$SCRIPT_DIR/${SCENARIOS[$CURRENT]}"
  if [ ! -f "$dir/setup.sh" ]; then
    echo -e "  ${RED}No setup.sh found for this scenario.${NC}"
    wait_enter
    return
  fi

  # Health check: can we reach the cluster?
  if ! kubectl get nodes --request-timeout=5s &>/dev/null; then
    echo ""
    echo -e "  ${RED}${BOLD}ERROR: Cannot connect to the cluster!${NC}"
    echo ""
    echo -e "  ${YELLOW}The API server might be down (common after scenarios 1, 6, 15, 16).${NC}"
    echo -e "  ${YELLOW}Debug steps:${NC}"
    echo ""
    echo -e "  ${DIM}# Check if apiserver container is running:${NC}"
    echo -e "  ${CYAN}crictl ps | grep kube-apiserver${NC}"
    echo ""
    echo -e "  ${DIM}# Check apiserver logs:${NC}"
    echo -e "  ${CYAN}crictl logs \$(crictl ps -a --name kube-apiserver -q | head -1) 2>&1 | tail -20${NC}"
    echo ""
    echo -e "  ${DIM}# Check manifest for syntax errors:${NC}"
    echo -e "  ${CYAN}cat /etc/kubernetes/manifests/kube-apiserver.yaml | head -50${NC}"
    echo ""
    echo -e "  ${DIM}# Restart kubelet to force re-read manifests:${NC}"
    echo -e "  ${CYAN}systemctl restart kubelet${NC}"
    echo ""
    echo -e "  ${DIM}# Wait and check again:${NC}"
    echo -e "  ${CYAN}sleep 30 && kubectl get nodes${NC}"
    echo ""
    wait_enter
    return
  fi

  echo ""
  echo -e "  ${YELLOW}Setting up scenario...${NC}"
  echo ""
  bash "$dir/setup.sh"
  SCENARIO_ACTIVE=true
  echo ""
  echo -e "  ${GREEN}✓ Scenario is ready!${NC}"
  echo ""

  # Show task immediately
  show_task

  # Now enter a working loop — user stays here until they go back
  while true; do
    echo -e "  ${BOLD}${YELLOW}>>> Solve this in another terminal <<<${NC}"
    echo ""
    echo -e "  ${CYAN}[t]${NC} Show task again  ${CYAN}[s]${NC} Solution  ${CYAN}[c]${NC} Check  ${CYAN}[b]${NC} Back to menu"
    echo ""
    echo -ne "  ${BOLD}Choice: ${NC}"
    read -r -n1 subchoice
    echo ""

    case "$subchoice" in
      t|T) show_task ;;
      s|S) show_solution ;;
      c|C) do_check_inline ;;
      b|B|"") return ;;
      *) ;;
    esac
  done
}

do_check_inline() {
  local dir="$SCRIPT_DIR/${SCENARIOS[$CURRENT]}"
  echo ""
  if [ -f "$dir/check.sh" ]; then
    echo -e "  ${YELLOW}Checking your answer...${NC}"
    echo ""
    if bash "$dir/check.sh"; then
      echo ""
      echo -e "  ${GREEN}${BOLD}✓ All checks passed! Well done!${NC}"
    else
      echo ""
      echo -e "  ${RED}✗ Some checks failed. Keep trying or view solution [s].${NC}"
    fi
  else
    echo -e "  ${DIM}No automated check. Compare with solution [s].${NC}"
  fi
  echo ""
}

do_check() {
  local dir="$SCRIPT_DIR/${SCENARIOS[$CURRENT]}"
  echo ""
  if [ -f "$dir/check.sh" ]; then
    echo -e "  ${YELLOW}Checking your answer...${NC}"
    echo ""
    if bash "$dir/check.sh"; then
      echo ""
      echo -e "  ${GREEN}${BOLD}✓ All checks passed!${NC}"
    else
      echo ""
      echo -e "  ${RED}✗ Some checks failed. Keep trying or view solution [s].${NC}"
    fi
  else
    echo -e "  ${DIM}No automated check. Compare with solution [s].${NC}"
  fi
  echo ""
  wait_enter
}

do_reset() {
  local dir="$SCRIPT_DIR/${SCENARIOS[$CURRENT]}"
  echo ""
  if [ -f "$dir/cleanup.sh" ]; then
    echo -e "  ${YELLOW}Cleaning up scenario...${NC}"
    bash "$dir/cleanup.sh" 2>/dev/null || true
    SCENARIO_ACTIVE=false
    echo -e "  ${GREEN}✓ Scenario reset.${NC}"
  else
    echo -e "  ${RED}No cleanup.sh found.${NC}"
  fi
  echo ""
  wait_enter
}

do_full_reset() {
  echo ""
  echo -e "  ${YELLOW}${BOLD}FULL CLUSTER RESET${NC}"
  echo -e "  ${DIM}This runs cleanup for ALL scenarios and restores the cluster to a fresh state.${NC}"
  echo ""
  echo -ne "  ${BOLD}Are you sure? [y/N]: ${NC}"
  read -r confirm
  echo ""
  case "$confirm" in
    y|Y)
      echo -e "  ${YELLOW}Running cleanup for every scenario...${NC}"
      echo ""
      for s in "${SCENARIOS[@]}"; do
        local cdir="$SCRIPT_DIR/$s"
        if [ -f "$cdir/cleanup.sh" ]; then
          echo -e "  ${DIM}→ cleaning $s${NC}"
          bash "$cdir/cleanup.sh" >/dev/null 2>&1 || true
        fi
      done
      SCENARIO_ACTIVE=false

      echo ""
      echo -e "  ${YELLOW}Deleting any leftover scenario namespaces...${NC}"
      kubectl delete namespace \
        secure monitoring team-a team-b web-ns locked-down \
        svc-ns client-ns payments project-x shop \
        --ignore-not-found --grace-period=0 --force >/dev/null 2>&1 || true

      echo -e "  ${YELLOW}Cleaning leftover default-namespace workloads...${NC}"
      kubectl delete deployment hardened-app immutable-app token-app multi-arch-app drain-test \
        -n default --ignore-not-found --grace-period=0 --force >/dev/null 2>&1 || true
      kubectl delete serviceaccount restricted-sa -n default --ignore-not-found >/dev/null 2>&1 || true

      echo -e "  ${YELLOW}Restoring node cordon state...${NC}"
      kubectl uncordon node01 >/dev/null 2>&1 || true

      echo ""
      echo -e "  ${YELLOW}Checking cluster health...${NC}"
      if kubectl get nodes --request-timeout=5s >/dev/null 2>&1; then
        echo -e "  ${GREEN}✓ API server reachable${NC}"
        kubectl get nodes 2>/dev/null | sed 's/^/    /'
      else
        echo -e "  ${RED}✗ API server not reachable — a manifest may still be broken.${NC}"
        echo -e "  ${DIM}Try: systemctl restart kubelet ; sleep 30 ; kubectl get nodes${NC}"
      fi

      echo ""
      echo -e "  ${GREEN}${BOLD}✓ Cluster reset to fresh state.${NC}"
      ;;
    *)
      echo -e "  ${DIM}Cancelled.${NC}"
      ;;
  esac
  echo ""
  wait_enter
}

do_quit() {
  echo ""
  # Cleanup active scenario
  if [ "$SCENARIO_ACTIVE" = true ]; then
    local dir="$SCRIPT_DIR/${SCENARIOS[$CURRENT]}"
    if [ -f "$dir/cleanup.sh" ]; then
      echo -e "  ${YELLOW}Cleaning up active scenario...${NC}"
      bash "$dir/cleanup.sh" 2>/dev/null || true
    fi
  fi

  echo ""
  echo -e "  ${BOLD}Before quitting:${NC}"
  echo -e "    ${CYAN}[s]${NC} Save progress and quit"
  echo -e "    ${CYAN}[r]${NC} Reset ALL progress (start fresh next time) and quit"
  echo -e "    ${CYAN}[c]${NC} Cancel (go back)"
  echo ""
  echo -ne "  ${BOLD}Choice: ${NC}"
  read -r -n1 qchoice
  echo ""

  case "$qchoice" in
    s|S)
      save_progress
      echo -e "\n  ${GREEN}Progress saved (${#COMPLETED[@]}/${TOTAL} done). See you next time! 🔒${NC}\n"
      exit 0
      ;;
    r|R)
      reset_all_progress
      echo -e "\n  ${YELLOW}All progress reset. Fresh start next time! 🔒${NC}\n"
      exit 0
      ;;
    *)
      # Cancel — go back to menu
      return
      ;;
  esac
}

list_scenarios() {
  echo ""
  echo -e "  ${BOLD}All ${TOTAL} CKS Scenarios:${NC}"
  echo ""
  for i in "${!SCENARIOS[@]}"; do
    local num=$((i + 1))
    local numstr
    numstr=$(printf "%02d" $num)
    local marker="  "
    local color="$NC"

    if [ $i -eq $CURRENT ]; then
      marker="▶ "
      color="$YELLOW"
    fi

    if is_completed "$i"; then
      echo -e "    ${GREEN}${marker}${numstr}. ${SCENARIO_TITLES[$i]} ✓${NC}"
    else
      echo -e "    ${color}${marker}${numstr}. ${SCENARIO_TITLES[$i]}${NC}"
    fi
  done
  echo ""
  wait_enter
}

next_scenario() {
  if [ $CURRENT -lt $LAST_INDEX ]; then
    CURRENT=$((CURRENT + 1))
    save_progress
  else
    echo -e "\n  ${GREEN}${BOLD}🎉 You're on the last scenario already!${NC}\n"
    sleep 1
  fi
}

prev_scenario() {
  if [ $CURRENT -gt 0 ]; then
    CURRENT=$((CURRENT - 1))
    save_progress
  fi
}

wait_enter() {
  echo -ne "  ${DIM}Press Enter to continue...${NC}"
  read -r
}

# ─── Main loop ─────────────────────────────────────────────────────

main() {
  load_progress

  # Allow jumping to a specific scenario via argument
  if [ "${1:-}" ] && [[ "${1:-}" =~ ^[0-9]+$ ]]; then
    local target=$((10#$1 - 1))
    if [ $target -ge 0 ] && [ $target -le $LAST_INDEX ]; then
      CURRENT=$target
      save_progress
    fi
  fi

  while true; do
    clear_screen
    show_header
    show_menu

    echo -ne "  ${BOLD}Choice: ${NC}"
    read -r -n1 choice
    echo ""

    case "$choice" in
      r|R) do_setup ;;
      t|T) show_task; wait_enter ;;
      s|S) show_solution; wait_enter ;;
      c|C) do_check ;;
      x|X) do_reset ;;
      f|F) do_full_reset ;;
      d|D) mark_completed "$CURRENT"; next_scenario ;;
      n|N) next_scenario ;;
      p|P) prev_scenario ;;
      l|L) list_scenarios ;;
      q|Q) do_quit ;;
      *) ;;
    esac
  done
}

main "$@"
