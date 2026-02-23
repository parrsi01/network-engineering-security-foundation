# Lab 03: Routing Simulation with Linux Namespaces - Troubleshooting Tree

## Decision Tree Logic

If client cannot reach server -> ping router client-side IP (`10.10.30.1`).
If that fails -> check client interface and address.
If it succeeds -> check router forwarding (`sysctl`) and server-side route.
If forwarding is enabled but still failing -> capture ICMP in router namespace to determine one-way loss vs full drop.

## Command-Based Verification Sequence

1. Confirm lab objects exist (namespaces, interfaces, services) using `ip netns list`, `ip link show`, and `ss -tulpn`.
2. Validate Layer 3 addressing and route selection using `ip addr`, `ip route`, and `ip route get <target>`.
3. Validate policy controls (`iptables`, `ufw`) where applicable.
4. Capture traffic with `tcpdump` only after route/interface checks are complete.
5. Re-test the exact failing command and compare counters/packet traces.
