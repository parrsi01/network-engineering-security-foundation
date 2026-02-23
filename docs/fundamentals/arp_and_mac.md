# ARP and MAC Addressing

## Technical Goal

Learn how IPv4 hosts resolve next-hop MAC addresses and how ARP failure presents in terminal output and packet captures.

## Key Concepts

- ARP maps IPv4 addresses to MAC addresses on the local segment
- Hosts ARP for the next hop (gateway) when sending off-subnet traffic
- Stale or incorrect ARP entries can break connectivity even when IP config looks correct

## CLI Examples

```bash
ip neigh show
ping -c 2 192.168.56.1
ip neigh show dev eth0
sudo tcpdump -ni eth0 -e arp
```

Expected output patterns:

- Neighbor states like `REACHABLE`, `STALE`, `DELAY`, `FAILED`
- ARP requests: `Who has 192.168.56.1? Tell 192.168.56.10`
- ARP replies containing the gateway MAC address

## Internal Packet Perspective

Before an IP packet can be encapsulated in an Ethernet frame, Linux needs the destination MAC of the next hop. If the ARP table lacks a valid entry, the kernel queues traffic and emits ARP requests. If no ARP reply arrives, traffic never leaves as valid Layer 2 frames and higher-layer tools report generic timeouts.

## Common Failure Modes

- Interface in wrong VLAN / isolated segment (no ARP replies)
- Duplicate IP causing ARP flux / MAC changes
- Stale static ARP entry pointing to wrong MAC
- Bridge or virtual switch filtering ARP unexpectedly

## Troubleshooting Section

```bash
ip neigh flush dev eth0
ping -c 1 192.168.56.1
ip neigh show dev eth0
sudo tcpdump -ni eth0 -e arp -c 10
```

What to check:

- `FAILED` neighbor entry => no ARP response
- MAC changes repeatedly => possible duplicate IP or HA failover event
- ARP visible but no IP reply => Layer 2 works, investigate Layer 3/4 next
