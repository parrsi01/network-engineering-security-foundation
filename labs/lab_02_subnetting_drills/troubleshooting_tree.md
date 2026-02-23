# Lab 02: Subnetting Drills with Reachability Consequences - Troubleshooting Tree

## Decision Tree Logic

If one same-VLAN host can ping some peers but not others -> check prefix with `ip addr` on both hosts.
If prefixes differ -> run `ip route get <failed_peer>` to see on-link vs gateway decision -> correct mask.
If prefixes match and ping still fails -> inspect bridge links (`ip link show br-l02`, veth states) -> then inspect ARP with `ip neigh`.

## Command-Based Verification Sequence

1. Confirm lab objects exist (namespaces, interfaces, services) using `ip netns list`, `ip link show`, and `ss -tulpn`.
2. Validate Layer 3 addressing and route selection using `ip addr`, `ip route`, and `ip route get <target>`.
3. Validate policy controls (`iptables`, `ufw`) where applicable.
4. Capture traffic with `tcpdump` only after route/interface checks are complete.
5. Re-test the exact failing command and compare counters/packet traces.
