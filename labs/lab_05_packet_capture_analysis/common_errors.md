# Lab 05: Packet Capture Analysis with tcpdump - Common Errors

## Real-World Error Scenarios

| Exact Error Message / Symptom | Root Cause | Step-by-Step Resolution |
|---|---|---|
| ``tcpdump: eth0: No such device exists` or no relevant packets` | Wrong interface selected for the lab topology | Identify correct interface with `ip link show` and capture on `br-l05` or the relevant `veth` interface. |
| `Capture file empty` | No traffic generated during capture window | Start capture first, then run `ping`/`curl`, and extend timeout if necessary. |
| ``Permission denied` running tcpdump` | Insufficient privileges/capabilities | Run with `sudo` or grant capture capability to tcpdump in a controlled lab environment. |

## Additional Notes

- Always capture command evidence (`ip`, `ss`, `tcpdump`, `iptables`) before changing multiple variables at once.
- When using namespaces, confirm the namespace context in every command to avoid editing the wrong network stack.
- If a command fails with permission errors, rerun with `sudo` and re-check the exact interface/namespace names.
