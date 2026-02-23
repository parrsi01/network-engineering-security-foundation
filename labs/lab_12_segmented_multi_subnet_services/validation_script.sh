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

echo "Validating labs/lab_12_segmented_multi_subnet_services"
echo "----------------------------------------"

check 'Router forwarding enabled' 'sudo ip netns exec s12-router sysctl -n net.ipv4.ip_forward | grep -q "^1$"'
check 'Client reaches app HTTP' 'sudo ip netns exec s12-client curl -sI --max-time 2 http://10.12.20.10:8080 | grep -q "HTTP/1"'
check 'App reaches DB 5432' 'sudo ip netns exec s12-app nc -z -w 2 10.12.30.10 5432'
check 'Client blocked from DB 5432' '! sudo ip netns exec s12-client nc -z -w 2 10.12.30.10 5432'

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
