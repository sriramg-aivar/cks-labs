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
NC='\033[0m' # No Color

# All 16 scenarios in order
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
)

# Load/save progress
load_progress() {
  CURRENT=0
  COMPLETED=()
  if [ -f "$PROGRESS_FILE" ]; then
    source "$PROGRESS_FILE"
  fi
}

save_progress() {
  echo "CURRENT=$CURRENT" > "$PROGRESS_FILE"
  if [ ${#COMPLETED[@]} -gt 0 ]; then
    echo "COMPLETED=(${COMPLETED[*]})" >> "$PROGRESS_FILE"
  else
    echo "COMPLETED=()" >> "$PROGRESS_FILE"
  fi
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

# Display functions
clear_screen() {
  printf '\033[2J\033[H'
}

show_header() {
  local idx=$CURRENT
  local num=$((idx + 1))
  local numstr=$(printf "%02d" $num)
  
  echo -e "${BOLD}${CYAN}"
  echo "╔═══════════════════════════════════════════════════════════════╗"
  echo "║            CKS Practice Labs - Study Mode                     ║"
  echo "╚═══════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"
  
  # Progress bar
  local done=${#COMPLETED[@]}
  local total=${#SCENARIOS[@]}
  echo -e "  Progress: ${GREEN}${done}${NC}/${total} completed"
  echo ""
  
  # Current scenario
  if is_completed "$idx"; then
    echo -e "  ${GREEN}▶ Scenario ${numstr}/16: ${SCENARIO_TITLES[$idx]} ✓${NC}"
  else
    echo -e "  ${YELLOW}▶ Scenario ${numstr}/16: ${SCENARIO_TITLES[$idx]}${NC}"
  fi
  echo -e "  ${DIM}Directory: ${SCENARIOS[$idx]}${NC}"
  echo ""
}

show_menu() {
  echo -e "  ${BOLD}Options:${NC}"
  echo -e "    ${CYAN}[t]${NC} Show Task (question)"
  echo -e "    ${CYAN}[s]${NC} Show Solution"
  echo -e "    ${CYAN}[r]${NC} Run/Setup this scenario"
  echo -e "    ${CYAN}[c]${NC} Check my answer"
  echo -e "    ${CYAN}[x]${NC} Reset (cleanup) scenario"
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
    echo -e "${RED}No TASK.md found for this scenario.${NC}"
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
    echo -e "${RED}No solution.md found for this scenario.${NC}"
  fi
  echo ""
  echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

run_setup() {
  local dir="$SCRIPT_DIR/${SCENARIOS[$CURRENT]}"
  echo ""
  if [ -f "$dir/setup.sh" ]; then
    echo -e "${YELLOW}Setting up scenario...${NC}"
    echo ""
    bash "$dir/setup.sh"
    echo ""
    echo -e "${GREEN}✓ Scenario is set up!${NC}"
    echo ""
    # Immediately show the task so user can work on it
    show_task
    echo -e "  ${BOLD}${YELLOW}>>> Work in another terminal to solve this. <<<${NC}"
    echo -e "  ${DIM}Use: kubectl, docker exec, etc. Come back here when done.${NC}"
    echo ""
    echo -e "  ${CYAN}[c]${NC} Check answer  ${CYAN}[s]${NC} Show solution  ${CYAN}[Enter]${NC} Back to menu"
    echo ""
    echo -ne "  ${BOLD}Choice: ${NC}"
    read -r -n1 subchoice
    echo ""
    case "$subchoice" in
      c|C) run_check ;;
      s|S) show_solution ;;
      *) return ;;
    esac
  else
    echo -e "${RED}No setup.sh found for this scenario.${NC}"
  fi
  echo ""
}

run_check() {
  local dir="$SCRIPT_DIR/${SCENARIOS[$CURRENT]}"
  echo ""
  if [ -f "$dir/check.sh" ]; then
    echo -e "${YELLOW}Checking your answer...${NC}"
    echo ""
    if bash "$dir/check.sh"; then
      echo ""
      echo -e "${GREEN}${BOLD}✓ All checks passed! Well done!${NC}"
      echo -e "  Press ${CYAN}[d]${NC} to mark complete and move to next."
    else
      echo ""
      echo -e "${RED}Some checks failed. Keep trying or view solution [s].${NC}"
    fi
  else
    echo -e "${DIM}No automated check for this scenario.${NC}"
    echo -e "Compare your work against the solution ${CYAN}[s]${NC}"
  fi
  echo ""
}

run_reset() {
  local dir="$SCRIPT_DIR/${SCENARIOS[$CURRENT]}"
  echo ""
  if [ -f "$dir/cleanup.sh" ]; then
    echo -e "${YELLOW}Resetting scenario...${NC}"
    bash "$dir/cleanup.sh"
    echo -e "${GREEN}Done. Scenario cleaned up.${NC}"
  else
    echo -e "${RED}No cleanup.sh found for this scenario.${NC}"
  fi
  echo ""
}

list_scenarios() {
  echo ""
  echo -e "${BOLD}  All 16 CKS Scenarios:${NC}"
  echo ""
  for i in "${!SCENARIOS[@]}"; do
    local num=$((i + 1))
    local numstr=$(printf "%02d" $num)
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
}

next_scenario() {
  if [ $CURRENT -lt 15 ]; then
    CURRENT=$((CURRENT + 1))
    save_progress
  else
    echo ""
    echo -e "${GREEN}${BOLD}🎉 You've reached the last scenario! All 16 done!${NC}"
    echo ""
  fi
}

prev_scenario() {
  if [ $CURRENT -gt 0 ]; then
    CURRENT=$((CURRENT - 1))
    save_progress
  else
    echo -e "${DIM}Already at the first scenario.${NC}"
  fi
}

# Main loop
main() {
  load_progress
  
  # Allow jumping to a specific scenario
  if [ ${1:-} ] && [[ "$1" =~ ^[0-9]+$ ]]; then
    local target=$((10#$1 - 1))
    if [ $target -ge 0 ] && [ $target -le 15 ]; then
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
      t|T) show_task; echo -ne "  ${DIM}Press Enter to continue...${NC}"; read -r ;;
      s|S) show_solution; echo -ne "  ${DIM}Press Enter to continue...${NC}"; read -r ;;
      r|R) run_setup ;;
      c|C) run_check; echo -ne "  ${DIM}Press Enter to continue...${NC}"; read -r ;;
      x|X) run_reset; echo -ne "  ${DIM}Press Enter to continue...${NC}"; read -r ;;
      d|D) mark_completed "$CURRENT"; next_scenario ;;
      n|N) next_scenario ;;
      p|P) prev_scenario ;;
      l|L) list_scenarios; echo -ne "  ${DIM}Press Enter to continue...${NC}"; read -r ;;
      q|Q)
        # Cleanup current scenario before quitting
        local dir="$SCRIPT_DIR/${SCENARIOS[$CURRENT]}"
        if [ -f "$dir/cleanup.sh" ]; then
          echo ""
          echo -e "  ${YELLOW}Cleaning up current scenario...${NC}"
          bash "$dir/cleanup.sh" 2>/dev/null || true
        fi
        echo -e "\n  ${DIM}Progress saved. Happy studying! 🔒${NC}"
        echo ""
        exit 0
        ;;
      *) ;;
    esac
  done
}

main "$@"
