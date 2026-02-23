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

echo "Validating labs/lab_08_vpn_simulation"
echo "----------------------------------------"

check 'wireguard-tools installed' 'command -v wg >/dev/null 2>&1'
check 'Config file exists' 'test -f /tmp/lab08/wg0.conf'
check 'Config contains Interface section' 'grep -q "^\\[Interface\\]" /tmp/lab08/wg0.conf'
check 'Config contains AllowedIPs' 'grep -q "^AllowedIPs = " /tmp/lab08/wg0.conf'

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
