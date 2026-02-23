# Lab 14: OSPF (FRR) and VRRP (Keepalived) Control-Plane Review + VIP Failover Simulation - Common Errors

## Real-World Errors and Resolutions

| Exact Error Message / Symptom | Root Cause | Step-by-Step Resolution |
|---|---|---|
| `VIP ping fails after failover simulation` | VIP not present on backup node or stale ARP on client | Check `ip addr` on both nodes and send gratuitous ARP / retry ping. |
| `OSPF neighbor missing (optional FRR tests)` | Protocol 89 blocked or interface/network statement mismatch | Check `vtysh` neighbor output, interface IPs, and `tcpdump proto 89`. |
| `Keepalived config review shows wrong VIP` | Config drift from intended service IP | Align `virtual_ipaddress` in config with documented/implemented VIP. |

## Notes

- Capture evidence before changing multiple variables at once.
- When using namespaces, confirm the namespace prefix in every command.
- Re-run validation after remediation to prove final state.
