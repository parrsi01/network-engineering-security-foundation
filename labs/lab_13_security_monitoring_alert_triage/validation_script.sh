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

echo "Validating labs/lab_13_security_monitoring_alert_triage"
echo "----------------------------------------"

check 'Sample EVE file exists' 'test -f labs/lab_13_security_monitoring_alert_triage/samples/eve_sample.jsonl'
check 'Sample conn log exists' 'test -f labs/lab_13_security_monitoring_alert_triage/samples/conn_sample.tsv'
check 'Triage helper script exists' 'test -f scripts/triage_eve_sample.py'
check 'jq parses at least one alert' 'jq -r '\''select(.event_type=="alert") | .alert.signature'\'' labs/lab_13_security_monitoring_alert_triage/samples/eve_sample.jsonl | grep -q .'

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
