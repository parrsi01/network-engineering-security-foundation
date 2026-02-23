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

echo "Validating labs/lab_02_subnetting_drills"
echo "----------------------------------------"

check 'Namespaces l2a/l2b exist' 'sudo ip netns list | grep -q "^l2a\\b" && sudo ip netns list | grep -q "^l2b\\b"'
check 'Bridge br-l02 exists' 'ip link show br-l02 >/dev/null 2>&1'
check 'l2a has /24 address' 'sudo ip netns exec l2a ip -o -4 addr show dev veth-l02a-ns | grep -q "192.168.50.10/24"'
check 'l2b reachable from l2a' 'sudo ip netns exec l2a ping -c 1 -W 1 192.168.50.20 >/dev/null 2>&1'

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
