# Lab 04: Firewall Configuration with iptables/UFW on a Lab Router - Troubleshooting Tree

## Decision Tree Logic

If service was reachable before firewall and now fails -> check `ss` on server to confirm listener is still running.
If listener exists -> inspect `fw-router` FORWARD chain with counters.
If counters not increasing -> confirm traffic is still routed through `fw-router` (route tables, forwarding enabled).
If DROP counter increases before allow rules -> fix rule order and retest.

## Command-Based Verification Sequence

1. Confirm lab objects exist (namespaces, interfaces, services) using `ip netns list`, `ip link show`, and `ss -tulpn`.
2. Validate Layer 3 addressing and route selection using `ip addr`, `ip route`, and `ip route get <target>`.
3. Validate policy controls (`iptables`, `ufw`) where applicable.
4. Capture traffic with `tcpdump` only after route/interface checks are complete.
5. Re-test the exact failing command and compare counters/packet traces.
