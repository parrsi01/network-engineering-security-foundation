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

echo "Validating labs/lab_01_linux_network_basics"
echo "----------------------------------------"

check 'Namespace exists' 'sudo ip netns list | grep -q "^lab01-peer\\b"'
check 'Host veth has expected IP' 'ip -o -4 addr show dev veth-l01 | grep -q "10.1.1.1/24"'
check 'Peer reachable' 'ping -c 1 -W 1 10.1.1.2 >/dev/null 2>&1'
check 'HTTP 8080 reachable' 'curl -sI --max-time 2 http://10.1.1.2:8080 | grep -q "HTTP/1"'

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
