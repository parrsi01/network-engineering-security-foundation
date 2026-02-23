# Lab 01: Linux Network Basics and Host Stack Visibility - Troubleshooting Tree

## Decision Tree Logic

If ping to `10.1.1.2` fails -> check `ip link show veth-l01` -> if DOWN, bring interface UP -> retest.
If interface is UP -> check `ip addr show veth-l01` -> if missing `10.1.1.1/24`, reassign IP -> retest.
If ping works but `curl` fails -> check peer listener with `ip netns exec lab01-peer ss -tulpn` -> restart service.
If listener exists but `curl` still fails -> run `tcpdump` on `veth-l01` and verify SYN/SYN-ACK exchange.

## Command-Based Verification Sequence

1. Confirm lab objects exist (namespaces, interfaces, services) using `ip netns list`, `ip link show`, and `ss -tulpn`.
2. Validate Layer 3 addressing and route selection using `ip addr`, `ip route`, and `ip route get <target>`.
3. Validate policy controls (`iptables`, `ufw`) where applicable.
4. Capture traffic with `tcpdump` only after route/interface checks are complete.
5. Re-test the exact failing command and compare counters/packet traces.
