# TCP/IP Deep Dive (Operational View)

## Objective

Understand how IP addressing, routing, and TCP/UDP transport interact in Linux so you can debug reachability and session failures with confidence.

## Core Flow

1. Application selects destination IP/port.
2. Kernel picks a source IP and route.
3. ARP (IPv4) resolves next-hop MAC when needed.
4. TCP performs handshake (`SYN` -> `SYN/ACK` -> `ACK`) or UDP sends immediately.
5. Firewall/NAT rules may modify or block traffic.
6. Remote host/service responds or times out.

## Useful Commands

```bash
ip route get 1.1.1.1
ss -tan state syn-sent
sudo tcpdump -ni any 'tcp[tcpflags] & (tcp-syn|tcp-ack) != 0'
```

Expected output examples:

- `ip route get` should show selected interface and source IP
- `ss` with many `SYN-SENT` entries often indicates remote filtering or path failure
- `tcpdump` should show handshake progression for healthy TCP connectivity

## TCP vs UDP Operational Differences

- TCP provides connection state, retransmissions, and sequencing
- UDP is stateless and can fail silently without application-level checks
- Firewalls often require explicit rules for UDP replies/state tracking validation

## Internal Mechanics (Network Stack Perspective)

Linux tracks TCP session state in kernel networking structures. When packets are dropped (firewall, route blackhole, wrong MTU), TCP retransmissions increase and applications experience latency before timeout. With UDP, packet loss is only visible if the application protocol provides acknowledgements or if you capture traffic.

## Troubleshooting Section

### Symptom: `curl` hangs before timeout

Check route, DNS, listener, and packet flow:

```bash
ip route get <server_ip>
ss -tan | grep SYN-SENT
sudo tcpdump -ni any host <server_ip> and port 443
```

Common root causes:

- Wrong default route
- Upstream firewall dropping SYN or SYN/ACK
- Local firewall blocking egress/ingress
- Service not listening on expected port

### Symptom: UDP app works intermittently

- Validate MTU and fragmentation behavior
- Confirm conntrack/firewall state handling for UDP
- Capture packets on both client and server sides when possible
