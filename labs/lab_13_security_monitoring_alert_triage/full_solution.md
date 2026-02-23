# Lab 13: Security Monitoring Alert Triage (Suricata + Zeek Style Logs) - Full Solution

## Final Working Configuration

```bash
python3 scripts/triage_eve_sample.py               labs/lab_13_security_monitoring_alert_triage/samples/eve_sample.jsonl               labs/lab_13_security_monitoring_alert_triage/samples/conn_sample.tsv               labs/lab_13_security_monitoring_alert_triage/samples/dns_sample.tsv
```

## Verification Commands

```bash
test -f labs/lab_13_security_monitoring_alert_triage/samples/eve_sample.jsonl
test -f labs/lab_13_security_monitoring_alert_triage/samples/conn_sample.tsv
test -f scripts/triage_eve_sample.py
jq -r 'select(.event_type=="alert") | .alert.signature' labs/lab_13_security_monitoring_alert_triage/samples/eve_sample.jsonl | grep -q .
```

## Validation Checklist

- [ ] Sample EVE file exists
- [ ] Sample conn log exists
- [ ] Triage helper script exists
- [ ] jq parses at least one alert
- [ ] `labs/lab_13_security_monitoring_alert_triage/validation_script.sh` returns `RESULT: PASS`
- [ ] Misconfiguration scenario reproduced and remediated
- [ ] Operational failure simulation triaged using evidence

## Cleanup (Optional)

```bash
# Optional cleanup: rm -rf /tmp/lab13-triage
```
