#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  simulate_latency.sh --interface IFACE --delay-ms 100 [--jitter-ms 10] [--distribution normal] [--namespace NS]
  simulate_latency.sh --interface IFACE --clear [--namespace NS]

Examples:
  sudo ./scripts/simulate_latency.sh --interface eth0 --delay-ms 120 --jitter-ms 20
  sudo ./scripts/simulate_latency.sh --namespace fw-router --interface fwc-r --delay-ms 50
  sudo ./scripts/simulate_latency.sh --interface eth0 --clear

Notes:
  - Uses `tc netem` (part of iproute2).
  - Run in a lab VM or namespace. Applying to a production interface impacts live traffic.
USAGE
}

ns=""
iface=""
delay_ms=""
jitter_ms="0"
distribution="normal"
clear_mode=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --namespace) ns="$2"; shift 2 ;;
    --interface) iface="$2"; shift 2 ;;
    --delay-ms) delay_ms="$2"; shift 2 ;;
    --jitter-ms) jitter_ms="$2"; shift 2 ;;
    --distribution) distribution="$2"; shift 2 ;;
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
    echo "PASS: netem rules cleared"
  else
    echo "INFO: no root qdisc present on $iface"
  fi
  exit 0
fi

[[ -n "$delay_ms" ]] || { echo "ERROR: --delay-ms is required unless --clear is used" >&2; usage; exit 1; }

# Replace root qdisc to make repeated runs idempotent for lab usage.
run_cmd tc qdisc replace dev "$iface" root netem delay "${delay_ms}ms" "${jitter_ms}ms" distribution "$distribution"

echo "Applied latency simulation on $iface${ns:+ in namespace $ns}: delay=${delay_ms}ms jitter=${jitter_ms}ms distribution=${distribution}"
run_cmd tc qdisc show dev "$iface"
