# Lab 09: Network Security Review and Exposure Assessment - Common Errors

## Real-World Error Scenarios

| Exact Error Message / Symptom | Root Cause | Step-by-Step Resolution |
|---|---|---|
| `Assuming a service is safe because it is "just for testing"` | Temporary listeners often bind to all interfaces by default | Always verify bind address and firewall restrictions with `ss` and firewall commands. |
| `Firewall policy reviewed but NAT ignored` | NAT may still publish a service externally | Check both filter and nat tables when performing exposure assessment. |
| `No written evidence for findings` | Operational review not documented | Capture a short report with commands, observed listeners, and remediation recommendations. |

## Additional Notes

- Always capture command evidence (`ip`, `ss`, `tcpdump`, `iptables`) before changing multiple variables at once.
- When using namespaces, confirm the namespace context in every command to avoid editing the wrong network stack.
- If a command fails with permission errors, rerun with `sudo` and re-check the exact interface/namespace names.
