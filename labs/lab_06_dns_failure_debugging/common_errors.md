# Lab 06: DNS Failure Debugging Workflow - Common Errors

## Real-World Error Scenarios

| Exact Error Message / Symptom | Root Cause | Step-by-Step Resolution |
|---|---|---|
| ``connection timed out; no servers could be reached`` | Wrong nameserver IP or UDP/53 blocked | Check `/etc/netns/dns-client/resolv.conf`, test direct `dig @server`, then capture traffic and inspect firewall rules. |
| ``dnsmasq: failed to create listening socket`` | Interface/address not ready when dnsmasq starts | Ensure `dnss-ns` is up with `10.60.6.53/24`, then restart dnsmasq. |
| ``NXDOMAIN` for expected lab name` | dnsmasq config missing local record | Check `/tmp/dnsmasq-l06.conf` and confirm `address=/lab6.test/10.60.6.100` exists. |

## Additional Notes

- Always capture command evidence (`ip`, `ss`, `tcpdump`, `iptables`) before changing multiple variables at once.
- When using namespaces, confirm the namespace context in every command to avoid editing the wrong network stack.
- If a command fails with permission errors, rerun with `sudo` and re-check the exact interface/namespace names.
