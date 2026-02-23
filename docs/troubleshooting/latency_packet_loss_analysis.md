# Latency and Packet Loss Analysis

## Objective

Teach practical measurement and isolation of latency spikes, jitter, and packet loss using Ubuntu CLI tools and controlled simulation scripts.

## Measurement Tools

- `ping` for RTT and packet loss percentages
- `mtr` (if installed) for hop-by-hop loss trends
- `traceroute` for path visibility
- `tcpdump` for retransmissions / duplicate ACK analysis
- `ss -ti` for TCP socket retransmission counters (advanced but useful)

## Example Commands

```bash
ping -c 20 8.8.8.8
traceroute -n 8.8.8.8
sudo tcpdump -ni any host 8.8.8.8 -c 50
```

Expected output considerations:

- Consistent RTT spread indicates stable path
- Increasing RTT or intermittent timeouts indicates congestion/policing/path issue
- Packet capture may show retransmissions when TCP is affected but ICMP looks acceptable

## Internal Packet Perspective

Latency can be introduced at queueing points (host, NIC, router, WAN link). Packet loss can occur before or after the local host transmits. Capturing locally answers whether packets leave on time and whether replies return.

## Troubleshooting Section

### Symptom: Users report slowness, but service stays up

1. Measure RTT/loss to gateway and remote target separately.
2. Compare app-level latency to network RTT.
3. Capture traffic and check retransmissions.
4. Inspect interface errors/counters (`ip -s link`).
5. Validate no local traffic shaping or firewall logging overhead change.
