#!/usr/bin/env bash
set -u

pass=0
fail=0

check() {
  local name="$1"
  local cmd="$2"
  if bash -lc "$cmd" >/dev/null 2>&1; then
    echo "PASS: $name"
    pass=$((pass+1))
  else
    echo "FAIL: $name"
    fail=$((fail+1))
  fi
}

echo "Validating labs/lab_14_ospf_vrrp_control_plane_review"
echo "----------------------------------------"

check 'FRR sample config exists' 'test -f configs/sample_frr_ospfd.conf'
check 'Keepalived sample config exists' 'test -f configs/sample_keepalived.conf'
check 'VIP reachable from client' 'sudo ip netns exec vrrp14-client ping -c 1 -W 1 10.14.0.254 >/dev/null 2>&1'
check 'Bridge br-l14 exists' 'ip link show br-l14 >/dev/null 2>&1'

echo "----------------------------------------"
echo "PASS checks: $pass"
echo "FAIL checks: $fail"
if [ "$fail" -eq 0 ]; then
  echo "RESULT: PASS"
  exit 0
else
  echo "RESULT: FAIL"
  exit 1
fi
