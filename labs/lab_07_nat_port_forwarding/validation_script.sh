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

echo "Validating labs/lab_07_nat_port_forwarding"
echo "----------------------------------------"

check 'Namespaces exist' 'sudo ip netns list | grep -q "^nat-client\\b" && sudo ip netns list | grep -q "^nat-router\\b" && sudo ip netns list | grep -q "^nat-server\\b"'
check 'DNAT rule exists' 'sudo ip netns exec nat-router iptables -t nat -S PREROUTING | grep -q "--dport 8080.*DNAT.*10.20.70.10:80"'
check 'Router forwarding enabled' 'sudo ip netns exec nat-router sysctl -n net.ipv4.ip_forward | grep -q "^1$"'
check 'Port forward returns HTTP' 'sudo ip netns exec nat-client curl -sI --max-time 2 http://10.10.70.1:8080 | grep -q "HTTP/1"'

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
