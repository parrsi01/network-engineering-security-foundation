# 06 - Packet Analysis and Observability

## What Packet Capture Proves

- Whether packets leave the host
- Whether replies return
- Whether TCP handshake completes
- Whether application data is exchanged after the handshake

## Useful Filters

```bash
sudo tcpdump -ni <iface> arp or icmp
sudo tcpdump -ni <iface> host <target> and port 53
sudo tcpdump -ni <iface> tcp port 80
```

## Latency / Loss Context

Combine capture evidence with `ping`, `traceroute`, and `tc qdisc show` when lab simulations intentionally add delay or loss.
