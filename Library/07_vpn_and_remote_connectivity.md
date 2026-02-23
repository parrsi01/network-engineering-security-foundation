# 07 - VPN and Remote Connectivity

## WireGuard Concepts (Operational)

- `wg0` is a virtual Layer 3 interface
- `AllowedIPs` controls route/policy behavior
- Handshake success does not prove remote subnet reachability

## Validation Commands

```bash
sudo wg show
ip addr show wg0
ip route show | grep wg0
sudo tcpdump -ni any udp port 51820
```

## Common Failure Pattern

Handshake exists, but remote subnet traffic fails because `AllowedIPs` excludes the remote subnet or local firewall/forwarding is missing.
