# Lab 14: OSPF (FRR) and VRRP (Keepalived) Control-Plane Review + VIP Failover Simulation - Troubleshooting Tree

## Decision Tree Logic

If VIP unreachable -> check current VIP owner (`ip addr`) -> check client ARP cache -> simulate gratuitous ARP and retest. If OSPF neighbor issue (optional) -> inspect interface IPs, protocol 89 visibility, and FRR neighbor state.

## Command-Based Verification Sequence

1. Confirm interfaces/namespaces/processes exist (`ip netns list`, `ip link show`, `ss -tulpn`).
2. Validate addressing and route selection (`ip addr`, `ip route`, `ip route get`).
3. Validate policy controls (`iptables`, service config, control-plane config) as applicable.
4. Use `tcpdump` or log parsing to prove the failure point.
5. Apply one fix, re-test, and record the result.
