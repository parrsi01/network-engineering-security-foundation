#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  network_diagnostics.sh [--namespace NS] [--target IP_OR_HOST] [--service-port PORT] [--capture-iface IFACE] [--capture-count N]

Examples:
  ./scripts/network_diagnostics.sh --target 8.8.8.8
  ./scripts/network_diagnostics.sh --namespace r3-client --target 10.20.30.10
  ./scripts/network_diagnostics.sh --target example.com --service-port 443 --capture-iface eth0 --capture-count 10

Notes:
  - Runs a structured evidence-first workflow.
  - Packet capture is optional and requires sudo.
USAGE
}

ns=""
target=""
service_port=""
capture_iface=""
capture_count="0"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --namespace) ns="$2"; shift 2 ;;
    --target) target="$2"; shift 2 ;;
    --service-port) service_port="$2"; shift 2 ;;
    --capture-iface) capture_iface="$2"; shift 2 ;;
    --capture-count) capture_count="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

run_cmd() {
  if [[ -n "$ns" ]]; then
    sudo ip netns exec "$ns" "$@"
  else
    "$@"
  fi
}

run_root_cmd() {
  if [[ -n "$ns" ]]; then
    sudo ip netns exec "$ns" "$@"
  else
    sudo "$@"
  fi
}

section() {
  printf '\n==== %s ====\n' "$1"
}

section "Context"
echo "Timestamp: $(date -Iseconds)"
echo "Namespace: ${ns:-host}"
echo "Target: ${target:-<none>}"
[[ -n "$service_port" ]] && echo "Service port: $service_port"

section "Interfaces"
run_cmd ip -br link || true
run_cmd ip -br addr || true

section "Routes"
run_cmd ip route show || true

if [[ -n "$target" ]]; then
  section "Route Decision"
  run_cmd ip route get "$target" || true
fi

section "Neighbors"
run_cmd ip neigh show || true

section "Sockets"
run_cmd ss -tulpn || true

section "DNS"
if [[ -n "$ns" ]]; then
  echo "Namespace resolv.conf path (if present): /etc/netns/$ns/resolv.conf"
  sudo test -f "/etc/netns/$ns/resolv.conf" && sudo cat "/etc/netns/$ns/resolv.conf" || echo "No namespace-specific resolv.conf"
else
  cat /etc/resolv.conf || true
  command -v resolvectl >/dev/null 2>&1 && resolvectl status || true
fi

if [[ -n "$target" ]]; then
  section "Connectivity Tests"
  if [[ "$target" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    run_cmd ping -c 2 -W 1 "$target" || true
  else
    run_cmd getent hosts "$target" || true
    command -v dig >/dev/null 2>&1 && run_cmd dig +time=1 +tries=1 +short "$target" || true
    # If name resolution works, also test basic ICMP to the first resolved IP when possible.
    resolved_ip="$(run_cmd getent ahostsv4 "$target" 2>/dev/null | awk 'NR==1 {print $1}')"
    [[ -n "$resolved_ip" ]] && run_cmd ping -c 2 -W 1 "$resolved_ip" || true
  fi
fi

if [[ -n "$capture_iface" && "$capture_count" != "0" ]]; then
  section "Packet Capture (Sample)"
  command -v tcpdump >/dev/null 2>&1 || { echo "tcpdump not installed"; exit 0; }
  if [[ -n "$target" && -n "$service_port" ]]; then
    run_root_cmd tcpdump -ni "$capture_iface" -c "$capture_count" "host $target and port $service_port" || true
  elif [[ -n "$target" ]]; then
    run_root_cmd tcpdump -ni "$capture_iface" -c "$capture_count" "host $target" || true
  else
    run_root_cmd tcpdump -ni "$capture_iface" -c "$capture_count" || true
  fi
fi

section "Summary"
echo "Diagnostics collection complete. Review evidence before making changes."
