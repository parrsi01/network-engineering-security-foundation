# Lab 08: WireGuard VPN Simulation (Conceptual + Linux Configuration Validation) - Common Errors

## Real-World Error Scenarios

| Exact Error Message / Symptom | Root Cause | Step-by-Step Resolution |
|---|---|---|
| `Handshake present but remote subnet unreachable` | `AllowedIPs` missing remote LAN prefix | Add the remote subnet to `AllowedIPs`, then confirm route selection to that subnet uses `wg0`. |
| `All traffic unexpectedly routed to VPN` | Accidental `AllowedIPs = 0.0.0.0/0` full-tunnel configuration | Scope `AllowedIPs` to only required subnets unless full tunnel is intentional. |
| ``wg-quick up` fails on example key markers` | Config contains non-real keys used for documentation | Generate keys with `wg genkey`/`wg pubkey` and replace example key markers before interface startup. |

## Additional Notes

- Always capture command evidence (`ip`, `ss`, `tcpdump`, `iptables`) before changing multiple variables at once.
- When using namespaces, confirm the namespace context in every command to avoid editing the wrong network stack.
- If a command fails with permission errors, rerun with `sudo` and re-check the exact interface/namespace names.
