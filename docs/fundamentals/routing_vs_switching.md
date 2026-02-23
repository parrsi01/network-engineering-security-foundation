# Routing vs Switching (Linux-Centric Explanation)

## Overview

Switching forwards frames within Layer 2 domains using MAC addresses. Routing forwards packets between Layer 3 networks using IP routes. On Linux, you observe routing directly with `ip route`; switching is often represented by bridges, VLAN interfaces, or external switches.

## Practical Mapping

- Switching evidence: MAC tables, ARP, bridge forwarding, VLAN membership
- Routing evidence: route table, next hop, TTL decrement, traceroute hops

## Commands

```bash
ip route show
ip route get 10.0.2.15
ip neigh show
traceroute -n 8.8.8.8
```

Expected output indicators:

- `ip route` includes connected routes and `default via ...`
- `traceroute` showing multiple hops confirms routing path (ICMP/TCP/UDP dependent)
- `ip neigh` showing local next-hop MAC confirms local L2 adjacency only

## Internal Packet Perspective

When a host sends to another subnet, it does **not** resolve the remote host MAC. It resolves the gateway MAC, then the router forwards the IP packet toward the next network. This distinction is central to troubleshooting wrong gateway vs wrong ARP assumptions.

## Troubleshooting Section

### Symptom: Same-subnet hosts communicate, but remote subnet fails

```bash
ip route show
ip route get <remote_ip>
ping -c 2 <gateway_ip>
traceroute -n <remote_ip>
```

Likely causes:

- Missing default route or specific route
- Wrong gateway IP
- Router/firewall blocking forwarding
- IP forwarding disabled on Linux router (`sysctl net.ipv4.ip_forward`)
