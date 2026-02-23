# Lab 09: Network Security Review and Exposure Assessment - Troubleshooting Tree

## Decision Tree Logic

If an exposure alert is raised -> inventory listeners with `ss -tulpn`.
If no listener exists -> inspect NAT/port forwarding and upstream mapping.
If listener exists -> check bind address and firewall scope.
If exposure is unintended -> stop service or restrict firewall, then verify from command outputs again.

## Command-Based Verification Sequence

1. Confirm lab objects exist (namespaces, interfaces, services) using `ip netns list`, `ip link show`, and `ss -tulpn`.
2. Validate Layer 3 addressing and route selection using `ip addr`, `ip route`, and `ip route get <target>`.
3. Validate policy controls (`iptables`, `ufw`) where applicable.
4. Capture traffic with `tcpdump` only after route/interface checks are complete.
5. Re-test the exact failing command and compare counters/packet traces.
