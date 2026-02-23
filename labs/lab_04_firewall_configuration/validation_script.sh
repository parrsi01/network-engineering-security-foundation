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

echo "Validating labs/lab_04_firewall_configuration"
echo "----------------------------------------"

check 'Namespaces exist' 'sudo ip netns list | grep -q "^fw-client\\b" && sudo ip netns list | grep -q "^fw-router\\b" && sudo ip netns list | grep -q "^fw-server\\b"'
check 'Router forwarding enabled' 'sudo ip netns exec fw-router sysctl -n net.ipv4.ip_forward | grep -q "^1$"'
check 'FORWARD policy is DROP' 'sudo ip netns exec fw-router iptables -S FORWARD | head -1 | grep -q "-P FORWARD DROP"'
check 'HTTP allowed through firewall' 'sudo ip netns exec fw-client curl -sI --max-time 2 http://10.20.40.10:8080 | grep -q "HTTP/1"'

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
