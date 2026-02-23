#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  firewall_reset.sh [--namespace NS] [--include-ufw] [--yes]

Examples:
  sudo ./scripts/firewall_reset.sh --namespace fw-router --yes
  sudo ./scripts/firewall_reset.sh --include-ufw --yes

Behavior:
  - Flushes iptables filter/nat/mangle chains and sets default filter policies to ACCEPT.
  - Optional UFW reset/disable on the target host namespace only.

Safety:
  Running on a real host can expose services and/or disrupt remote access. Prefer namespace usage.
USAGE
}

ns=""
include_ufw=0
yes=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --namespace) ns="$2"; shift 2 ;;
    --include-ufw) include_ufw=1; shift ;;
    --yes) yes=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ "$yes" -ne 1 ]]; then
  echo "ERROR: confirmation required. Re-run with --yes after reviewing impact." >&2
  usage
  exit 1
fi

run_ipt() {
  if [[ -n "$ns" ]]; then
    sudo ip netns exec "$ns" iptables "$@"
  else
    sudo iptables "$@"
  fi
}

for table in filter nat mangle; do
  run_ipt -t "$table" -F || true
  run_ipt -t "$table" -X || true
done

# Safe baseline for lab recovery: allow all while rebuilding rules.
run_ipt -P INPUT ACCEPT || true
run_ipt -P FORWARD ACCEPT || true
run_ipt -P OUTPUT ACCEPT || true

if [[ "$include_ufw" -eq 1 ]]; then
  if [[ -n "$ns" ]]; then
    echo "INFO: UFW is host-namespace scoped; --include-ufw ignored when --namespace is used."
  else
    if command -v ufw >/dev/null 2>&1; then
      sudo ufw --force disable || true
      sudo ufw --force reset || true
    else
      echo "INFO: ufw not installed; skipping UFW reset"
    fi
  fi
fi

echo "PASS: iptables reset completed${ns:+ in namespace $ns}"
if [[ -n "$ns" ]]; then
  sudo ip netns exec "$ns" iptables -L -n -v
else
  sudo iptables -L -n -v
fi
