# Lab 11: DHCP Lease Debugging with dnsmasq and dhclient - Troubleshooting Tree

## Decision Tree Logic

If DHCP lease fails -> verify server listener/logs -> capture UDP 67/68 -> confirm scope matches subnet -> inspect firewall on DHCP server namespace -> retry lease.

## Command-Based Verification Sequence

1. Confirm interfaces/namespaces/processes exist (`ip netns list`, `ip link show`, `ss -tulpn`).
2. Validate addressing and route selection (`ip addr`, `ip route`, `ip route get`).
3. Validate policy controls (`iptables`, service config, control-plane config) as applicable.
4. Use `tcpdump` or log parsing to prove the failure point.
5. Apply one fix, re-test, and record the result.
