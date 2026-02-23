# Lab 03: Routing Simulation with Linux Namespaces - Common Errors

## Real-World Error Scenarios

| Exact Error Message / Symptom | Root Cause | Step-by-Step Resolution |
|---|---|---|
| ``Destination Host Unreachable` from router IP` | IP forwarding disabled or missing route | Check `sysctl net.ipv4.ip_forward` in router namespace and route tables in client/server namespaces. |
| `Ping works one direction only` | Missing return route/default route on remote host | Inspect `ip route show` on both ends and restore default routes. |
| ``Cannot open network namespace`` | Namespace not created or command typo | Confirm names with `sudo ip netns list` and rerun setup commands. |

## Additional Notes

- Always capture command evidence (`ip`, `ss`, `tcpdump`, `iptables`) before changing multiple variables at once.
- When using namespaces, confirm the namespace context in every command to avoid editing the wrong network stack.
- If a command fails with permission errors, rerun with `sudo` and re-check the exact interface/namespace names.
