# Lab 07: NAT and Port Forwarding on a Linux Router Namespace - Common Errors

## Real-World Error Scenarios

| Exact Error Message / Symptom | Root Cause | Step-by-Step Resolution |
|---|---|---|
| `NAT rule present but connection times out` | FORWARD chain policy drops translated packets | Inspect `iptables -L FORWARD -n -v` in the router namespace and add explicit allow + established rules. |
| ``curl` to router:8080 returns connection refused` | DNAT points to wrong IP/port or server listener down | Verify `PREROUTING` DNAT target and `ss -tulpn` on nat-server. |
| `Counters stay at zero` | Traffic not entering expected interface or client targeting wrong IP | Confirm client uses `10.10.70.1:8080` and check interface names in NAT rules. |

## Additional Notes

- Always capture command evidence (`ip`, `ss`, `tcpdump`, `iptables`) before changing multiple variables at once.
- When using namespaces, confirm the namespace context in every command to avoid editing the wrong network stack.
- If a command fails with permission errors, rerun with `sudo` and re-check the exact interface/namespace names.
