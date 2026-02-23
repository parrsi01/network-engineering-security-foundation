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

echo "Validating labs/lab_10_vlan_bridge_segmentation"
echo "----------------------------------------"

check 'Namespaces exist' 'sudo ip netns list | grep -q "^vlan10-a\\b" && sudo ip netns list | grep -q "^vlan10-b\\b"'
check 'VLAN 10 exists on side A' 'sudo ip netns exec vlan10-a ip -d link show tr10a.10 | grep -q "vlan id 10"'
check 'VLAN 20 ping works' 'sudo ip netns exec vlan10-a ping -c 1 -W 1 10.10.20.2 >/dev/null 2>&1'
check 'Bridge br-l10 exists' 'ip link show br-l10 >/dev/null 2>&1'

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
