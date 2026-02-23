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

echo "Validating labs/lab_15_load_balancer_healthcheck_failover"
echo "----------------------------------------"

check 'HAProxy binary available' 'command -v haproxy >/dev/null 2>&1'
check 'Lab config file exists' 'test -f /tmp/lab15-haproxy/haproxy.cfg'
check 'Frontend listener up' 'ss -tulpn | grep -q ":8088"'
check 'Load balancer responds' 'curl -s --max-time 2 http://127.0.0.1:8088 | grep -Eq "backend-1|backend-2"'

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
