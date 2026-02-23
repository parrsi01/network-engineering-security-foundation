# Lab 01: Linux Network Basics and Host Stack Visibility - Common Errors

## Real-World Error Scenarios

| Exact Error Message / Symptom | Root Cause | Step-by-Step Resolution |
|---|---|---|
| ``ping: connect: Network is unreachable`` | Interface or route missing/down | Check `ip link show veth-l01`, `ip addr show`, then restore interface state and IP assignment. |
| ``curl: (28) Connection timed out`` | Service not listening or TCP path blocked | Validate `ping`, then `ss -tulpn` inside peer namespace and restart the HTTP service. |
| ``RTNETLINK answers: File exists`` | Attempted to recreate an existing veth or namespace | Delete old lab objects (`ip link del`, `ip netns del`) before recreating them. |

## Additional Notes

- Always capture command evidence (`ip`, `ss`, `tcpdump`, `iptables`) before changing multiple variables at once.
- When using namespaces, confirm the namespace context in every command to avoid editing the wrong network stack.
- If a command fails with permission errors, rerun with `sudo` and re-check the exact interface/namespace names.
