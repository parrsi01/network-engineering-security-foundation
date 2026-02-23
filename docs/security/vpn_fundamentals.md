# VPN Fundamentals (WireGuard-Oriented)

## Goal

Introduce VPN concepts needed to understand encrypted tunnel interfaces, routing changes, and common failure points when using WireGuard on Linux.

## Core Concepts

- Tunnel interface (`wg0`) acts like a virtual Layer 3 interface
- Peers exchange encrypted UDP packets (default WireGuard transport UDP)
- `AllowedIPs` defines both traffic selectors and route injection behavior
- Handshake success does not guarantee application reachability (routing/firewall still matter)

## Commands

```bash
sudo wg show
ip addr show wg0
ip route show
sudo ss -lunp | grep 51820 || true
```

Expected output indicators:

- Peer configured with recent handshake timestamp (if active)
- `wg0` has tunnel IP (for example `10.99.0.1/24`)
- Route entries for peer subnets via `wg0`

## Internal Packet Perspective

Application packets are routed to `wg0`, encrypted into UDP datagrams, and sent to the peer endpoint. The receiving peer decrypts and forwards based on `AllowedIPs`, kernel routes, and firewall policy.

## Troubleshooting Section

### Symptom: `wg show` handshake exists, but no ping over tunnel

```bash
sudo wg show
ip route get <tunnel_peer_ip>
sudo iptables -L -n -v
sudo tcpdump -ni any udp port 51820
```

Likely causes:

- `AllowedIPs` mismatch (route not using `wg0`)
- Tunnel subnet overlap with local LAN
- Firewall dropping forwarded tunnel traffic
- Peer endpoint reachable but inner routes missing
