# DHCP Foundations and Relay Patterns (Lab-Oriented)

## Objective

Understand DHCP lease flow, basic server configuration, and common segmentation/relay issues using Ubuntu tooling and `dnsmasq`/ISC client examples.

## DHCP Flow (DORA)

1. Discover (broadcast from client)
2. Offer (server proposal)
3. Request (client selects offer)
4. Acknowledge (lease committed)

## Why Segmentation Matters

DHCP Discover is a broadcast and does not cross routers by default. In routed environments, you need a DHCP relay (`ip helper` on network gear, relay daemon on Linux) or a local DHCP service per subnet.

## Ubuntu/Lab Commands

```bash
sudo dnsmasq --no-daemon --interface=<if> --bind-interfaces --dhcp-range=10.30.10.100,10.30.10.150,255.255.255.0,1h
sudo dhclient -v <if>
sudo tcpdump -ni <if> 'port 67 or port 68'
```

Expected output indicators:

- `dhclient` shows `DHCPDISCOVER`, `DHCPOFFER`, `DHCPREQUEST`, `DHCPACK`
- `tcpdump` shows UDP 67/68 traffic during lease negotiation

## Internal Packet Perspective

DHCP starts as Layer 2 broadcast traffic because the client has no IP address and may not know the DHCP server. Once the client receives a lease, it configures Layer 3 settings and can communicate normally.

## Common Failure Modes

- DHCP server bound to wrong interface
- DHCP range not in the subnet of the serving interface
- Firewall blocks UDP 67/68
- DHCP server reachable only across a routed boundary without relay

## Troubleshooting Section

```bash
ip link show <if>
ip addr show <if>
sudo ss -lunp | grep ':67\|:68'
sudo tcpdump -ni <if> 'udp port 67 or udp port 68' -c 20
journalctl -u dnsmasq --since '10 min ago' || true
```

Confirm client broadcasts leave the interface, server replies return, and the lease range matches the intended subnet.
