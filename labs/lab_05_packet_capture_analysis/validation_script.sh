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

echo "Validating labs/lab_05_packet_capture_analysis"
echo "----------------------------------------"

check 'Bridge exists' 'ip link show br-l05 >/dev/null 2>&1'
check 'Client reaches server via ping' 'sudo ip netns exec cap-client ping -c 1 -W 1 10.50.5.20 >/dev/null 2>&1'
check 'Capture directory exists' 'test -d labs/lab_05_packet_capture_analysis/captures'
check 'HTTP service reachable' 'sudo ip netns exec cap-client curl -s --max-time 2 http://10.50.5.20:8080 >/dev/null'

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
