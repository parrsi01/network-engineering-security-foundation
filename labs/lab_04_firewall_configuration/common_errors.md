# Lab 04: Firewall Configuration with iptables/UFW on a Lab Router - Common Errors

## Real-World Error Scenarios

| Exact Error Message / Symptom | Root Cause | Step-by-Step Resolution |
|---|---|---|
| ``curl: (28) Connection timed out` after firewall change` | Rule order or missing allow/established rule in FORWARD chain | Use `iptables -L FORWARD -n -v --line-numbers` and inspect counters/ordering. |
| `Ping works but HTTP fails` | ICMP allowed, TCP 8080 not allowed | Add explicit TCP allow rule for `--dport 8080` and retest. |
| `Rules appear correct but no effect` | Commands run in host namespace instead of `fw-router` namespace | Prefix firewall commands with `sudo ip netns exec fw-router` consistently. |

## Additional Notes

- Always capture command evidence (`ip`, `ss`, `tcpdump`, `iptables`) before changing multiple variables at once.
- When using namespaces, confirm the namespace context in every command to avoid editing the wrong network stack.
- If a command fails with permission errors, rerun with `sudo` and re-check the exact interface/namespace names.
