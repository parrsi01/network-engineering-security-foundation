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

echo "Validating labs/lab_03_routing_simulation"
echo "----------------------------------------"

check 'Namespaces exist' 'sudo ip netns list | grep -q "^r3-client\\b" && sudo ip netns list | grep -q "^r3-router\\b" && sudo ip netns list | grep -q "^r3-server\\b"'
check 'Router IP forwarding enabled' 'sudo ip netns exec r3-router sysctl -n net.ipv4.ip_forward | grep -q "^1$"'
check 'Client reaches server' 'sudo ip netns exec r3-client ping -c 1 -W 1 10.20.30.10 >/dev/null 2>&1'
check 'Server has default route' 'sudo ip netns exec r3-server ip route show | grep -q "default via 10.20.30.1"'

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
