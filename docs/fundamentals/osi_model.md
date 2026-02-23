# OSI Model Mapping to Real Packets

## Why This Matters

The OSI model is most useful when mapped to actual Linux tools and packet behavior. In operations, you do not troubleshoot "Layer 3" abstractly; you validate interfaces, MAC resolution, IP routing, and application listeners with evidence.

## Layer-to-Tool Mapping

| Layer | Practical Question | Ubuntu Commands |
|---|---|---|
| 1 Physical | Is the link up? | `ip link`, `ethtool <if>` |
| 2 Data Link | Is ARP/MAC resolution working? | `ip neigh`, `bridge fdb`, `tcpdump -e` |
| 3 Network | Is addressing/routing correct? | `ip addr`, `ip route`, `ping`, `traceroute` |
| 4 Transport | Is TCP/UDP reachable? | `ss -tulpn`, `nc`, `tcpdump` |
| 5-7 Session/Presentation/Application | Is the service answering correctly? | `curl`, `dig`, app logs, `journalctl` |

## CLI Example

```bash
ip link show
ip addr show
ip route show
ss -tulpn
```

Expected patterns:

- Interface state `UP` for the active interface
- Valid IP/mask assigned (for example `192.168.56.10/24`)
- Default route present (`default via 192.168.56.1`)
- Listening sockets for expected services (for example `:22`, `:53`, `:80`)

## Internal Packet Perspective

A TCP packet to a remote host is processed in layers:

1. Application creates payload (Layer 7).
2. Kernel adds TCP header (Layer 4) and IP header (Layer 3).
3. Kernel resolves next-hop MAC with ARP (Layer 2) if not already cached.
4. NIC transmits frames on the link (Layer 1).

Troubleshooting becomes faster when you identify the first layer where evidence breaks.

## Common Mistakes

- Treating ping success as proof the application works (ICMP is not TCP/UDP application traffic)
- Checking only `ifconfig`/`ip addr` but ignoring `ip route`
- Assuming DNS failure when the actual issue is firewall or service bind address

## Troubleshooting Section

Use this sequence when a service is unreachable:

```bash
ip link show dev eth0
ip addr show dev eth0
ip route get 8.8.8.8
ss -tulpn | grep ':80\|:443\|:53\|:22'
sudo tcpdump -ni eth0 -c 10 host 8.8.8.8
```

Interpretation:

- No link (`state DOWN`) => Layer 1/2 problem
- No route => Layer 3 problem
- No listener => Layer 4+/application issue
- Egress packets with no replies => upstream path/firewall issue
