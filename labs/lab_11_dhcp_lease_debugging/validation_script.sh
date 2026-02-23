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

echo "Validating labs/lab_11_dhcp_lease_debugging"
echo "----------------------------------------"

check 'Namespaces exist' 'sudo ip netns list | grep -q "^dhcp11-client\\b" && sudo ip netns list | grep -q "^dhcp11-server\\b"'
check 'Client has DHCP lease in 10.11.0.0/24' 'sudo ip netns exec dhcp11-client ip -o -4 addr show dev d11c-ns | grep -q "10.11.0."'
check 'dnsmasq listening on UDP/67' 'sudo ip netns exec dhcp11-server ss -lunp | grep -q ":67"'
check 'Bridge br-l11 exists' 'ip link show br-l11 >/dev/null 2>&1'

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
