# 01 - Networking Fundamentals

## Core Definitions

- Interface: Linux network device used to send/receive packets.
- Subnet: IP address range treated as directly connected by a host.
- Gateway: Next-hop router for off-subnet traffic.
- ARP: IPv4 mechanism to resolve next-hop MAC addresses on a local link.

## Why It Matters Operationally

Most outages are not caused by advanced routing protocols. They are caused by wrong IPs, wrong masks, missing routes, or service/listener assumptions.

## Command Mapping

```bash
ip -br link
ip -br addr
ip route show
ip neigh show
```

## Common Failure Signatures

- `Network is unreachable` -> no route/default route
- `Destination Host Unreachable` -> path/gateway/ARP issue near source
- Ping works, app fails -> likely service/firewall/DNS problem
