# Lab 11: DHCP Lease Debugging with dnsmasq and dhclient - Common Errors

## Real-World Errors and Resolutions

| Exact Error Message / Symptom | Root Cause | Step-by-Step Resolution |
|---|---|---|
| ``No DHCPOFFERS received` in dhclient output` | DHCP server down, wrong range, or UDP 67/68 blocked | Verify dnsmasq process/listener, inspect range subnet, and capture DHCP packets. |
| ``dnsmasq: no address range available`` | Configured range does not match interface subnet | Fix `dhcp-range` to the same subnet as the server interface IP. |
| `Client gets lease but no connectivity` | Gateway option missing/wrong or bridge/interface issue | Check lease options and client route table after DHCPACK. |

## Notes

- Capture evidence before changing multiple variables at once.
- When using namespaces, confirm the namespace prefix in every command.
- Re-run validation after remediation to prove final state.
