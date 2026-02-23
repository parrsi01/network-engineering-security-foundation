# Lab 06: DNS Failure Debugging Workflow - Troubleshooting Tree

## Decision Tree Logic

If name lookup fails -> test IP connectivity to DNS server (`ping 10.60.6.53`).
If ping fails -> check bridge/veth/interface state.
If ping works -> compare `dig @10.60.6.53` vs `dig` default.
If direct works but default fails -> fix resolver config.
If neither works -> capture port 53 and inspect dns-server firewall / dnsmasq process.

## Command-Based Verification Sequence

1. Confirm lab objects exist (namespaces, interfaces, services) using `ip netns list`, `ip link show`, and `ss -tulpn`.
2. Validate Layer 3 addressing and route selection using `ip addr`, `ip route`, and `ip route get <target>`.
3. Validate policy controls (`iptables`, `ufw`) where applicable.
4. Capture traffic with `tcpdump` only after route/interface checks are complete.
5. Re-test the exact failing command and compare counters/packet traces.
