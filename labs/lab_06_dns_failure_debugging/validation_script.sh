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

echo "Validating labs/lab_06_dns_failure_debugging"
echo "----------------------------------------"

check 'Namespaces exist' 'sudo ip netns list | grep -q "^dns-client\\b" && sudo ip netns list | grep -q "^dns-server\\b"'
check 'Namespace resolv.conf points to lab DNS' 'test -f /etc/netns/dns-client/resolv.conf && grep -q "10.60.6.53" /etc/netns/dns-client/resolv.conf'
check 'dnsmasq process is running in dns-server namespace' 'sudo ip netns exec dns-server pgrep -x dnsmasq >/dev/null 2>&1'
check 'DNS resolution succeeds' 'sudo ip netns exec dns-client dig +time=1 +tries=1 +short lab6.test | grep -q "10.60.6.100"'

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
