# Lab 07: NAT and Port Forwarding on a Linux Router Namespace - Troubleshooting Tree

## Decision Tree Logic

If router:8080 fails -> check server listener on nat-server:80.
If listener exists -> inspect DNAT PREROUTING rule and counters.
If NAT counters increment but no response -> inspect FORWARD chain and conntrack/established rules.
If no NAT counter increments -> confirm client target IP/port and router interface name in rule.

## Command-Based Verification Sequence

1. Confirm lab objects exist (namespaces, interfaces, services) using `ip netns list`, `ip link show`, and `ss -tulpn`.
2. Validate Layer 3 addressing and route selection using `ip addr`, `ip route`, and `ip route get <target>`.
3. Validate policy controls (`iptables`, `ufw`) where applicable.
4. Capture traffic with `tcpdump` only after route/interface checks are complete.
5. Re-test the exact failing command and compare counters/packet traces.
