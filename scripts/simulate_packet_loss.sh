#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  simulate_packet_loss.sh --interface IFACE --loss-percent 10 [--correlation 25] [--namespace NS]
  simulate_packet_loss.sh --interface IFACE --clear [--namespace NS]

Examples:
  sudo ./scripts/simulate_packet_loss.sh --interface eth0 --loss-percent 5
  sudo ./scripts/simulate_packet_loss.sh --namespace r3-router --interface r3c-r --loss-percent 20 --correlation 30
  sudo ./scripts/simulate_packet_loss.sh --interface eth0 --clear

Notes:
  - Uses `tc netem loss`.
  - Loss simulation can break SSH if applied to the active management interface.
USAGE
}

ns=""
iface=""
loss_percent=""
correlation="0"
clear_mode=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --namespace) ns="$2"; shift 2 ;;
    --interface) iface="$2"; shift 2 ;;
    --loss-percent) loss_percent="$2"; shift 2 ;;
    --correlation) correlation="$2"; shift 2 ;;
    --clear) clear_mode=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

[[ -n "$iface" ]] || { echo "ERROR: --interface is required" >&2; usage; exit 1; }
command -v tc >/dev/null 2>&1 || { echo "ERROR: tc command not found (install iproute2)" >&2; exit 1; }

run_cmd() {
  if [[ -n "$ns" ]]; then
    sudo ip netns exec "$ns" "$@"
  else
    sudo "$@"
  fi
}

if [[ "$clear_mode" -eq 1 ]]; then
  echo "Removing netem qdisc from $iface${ns:+ in namespace $ns}"
  if run_cmd tc qdisc del dev "$iface" root 2>/dev/null; then
    echo "PASS: packet-loss simulation cleared"
  else
    echo "INFO: no root qdisc present on $iface"
  fi
  exit 0
fi

[[ -n "$loss_percent" ]] || { echo "ERROR: --loss-percent is required unless --clear is used" >&2; usage; exit 1; }
run_cmd tc qdisc replace dev "$iface" root netem loss "${loss_percent}%" "${correlation}%"

echo "Applied packet loss simulation on $iface${ns:+ in namespace $ns}: loss=${loss_percent}% correlation=${correlation}%"
run_cmd tc qdisc show dev "$iface"
