# Lab 02: Subnetting Drills with Reachability Consequences - Common Errors

## Real-World Error Scenarios

| Exact Error Message / Symptom | Root Cause | Step-by-Step Resolution |
|---|---|---|
| ``ping: connect: Network is unreachable` after changing mask` | Destination moved outside connected subnet and no gateway exists | Use `ip route get` to confirm route decision, then correct prefix or add a valid gateway. |
| ``RTNETLINK answers: File exists` when adding bridge` | Bridge already exists from a previous run | Delete with `sudo ip link del br-l02` and rerun setup. |
| `Intermittent reachability only to some peers` | Mask mismatch creates partial on-link visibility | Compare `ip addr` outputs across hosts and standardize the prefix length. |

## Additional Notes

- Always capture command evidence (`ip`, `ss`, `tcpdump`, `iptables`) before changing multiple variables at once.
- When using namespaces, confirm the namespace context in every command to avoid editing the wrong network stack.
- If a command fails with permission errors, rerun with `sudo` and re-check the exact interface/namespace names.
