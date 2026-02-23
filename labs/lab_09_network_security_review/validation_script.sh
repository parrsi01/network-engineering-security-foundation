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

echo "Validating labs/lab_09_network_security_review"
echo "----------------------------------------"

check '`ss` command available' 'command -v ss >/dev/null 2>&1'
check 'Review report created' 'test -f /tmp/lab09/exposure_review.txt'
check 'Report contains Action recommendation' 'grep -q "Action recommendation" /tmp/lab09/exposure_review.txt'
check 'iptables command available' 'command -v iptables >/dev/null 2>&1'

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
