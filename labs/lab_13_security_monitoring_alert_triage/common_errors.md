# Lab 13: Security Monitoring Alert Triage (Suricata + Zeek Style Logs) - Common Errors

## Real-World Errors and Resolutions

| Exact Error Message / Symptom | Root Cause | Step-by-Step Resolution |
|---|---|---|
| `No alert rows returned from `jq`` | Incorrect filter field/value or malformed JSON line | Validate schema with `head` and use `event_type=="alert"`. |
| `Correlation script fails on TSV parsing` | Unexpected delimiter/header change | Check TSV headers and delimiter (`	`) before parsing. |
| `High alert volume causes overreaction` | Noisy rule/signature not correlated with traffic context | Correlate with conn/dns logs and summarize scope before escalation/blocking. |

## Notes

- Capture evidence before changing multiple variables at once.
- When using namespaces, confirm the namespace prefix in every command.
- Re-run validation after remediation to prove final state.
