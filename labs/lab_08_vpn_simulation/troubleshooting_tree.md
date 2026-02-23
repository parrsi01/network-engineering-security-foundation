# Lab 08: WireGuard VPN Simulation (Conceptual + Linux Configuration Validation) - Troubleshooting Tree

## Decision Tree Logic

If VPN app traffic fails -> check `wg show` for handshake.
If no handshake -> inspect endpoint reachability/UDP 51820/firewall.
If handshake exists -> inspect `AllowedIPs` and route selection (`ip route get <remote_ip>`).
If route is correct -> inspect host firewall/forwarding and remote peer config.

## Command-Based Verification Sequence

1. Confirm lab objects exist (namespaces, interfaces, services) using `ip netns list`, `ip link show`, and `ss -tulpn`.
2. Validate Layer 3 addressing and route selection using `ip addr`, `ip route`, and `ip route get <target>`.
3. Validate policy controls (`iptables`, `ufw`) where applicable.
4. Capture traffic with `tcpdump` only after route/interface checks are complete.
5. Re-test the exact failing command and compare counters/packet traces.
