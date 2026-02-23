# NAT and Port Forwarding Fundamentals

## Technical Goal

Understand source NAT (SNAT/MASQUERADE) and destination NAT (DNAT/port forwarding) behavior on Linux so you can validate traffic translation and troubleshoot broken exposure rules.

## Linux NAT Concepts

- SNAT/MASQUERADE rewrites source IP (typically for outbound internet access)
- DNAT rewrites destination IP/port (port forwarding to internal service)
- Packet filter rules may still block traffic even when NAT rules are correct
- Connection tracking (`conntrack`) maintains translation state for return traffic

## Commands

```bash
sudo iptables -t nat -S
sudo iptables -S FORWARD
sudo sysctl net.ipv4.ip_forward
```

Expected output indicators:

- `-A POSTROUTING ... -j MASQUERADE` for outbound NAT
- `-A PREROUTING ... -j DNAT --to-destination ...` for port forwarding
- `net.ipv4.ip_forward = 1` on Linux acting as a router/NAT gateway

## Internal Packet Perspective

A packet destined for the public IP/port hits `PREROUTING` first. DNAT may change the destination to an internal host before routing. The forwarded packet then traverses `FORWARD` filter rules. Return traffic uses conntrack state and may be SNATed in `POSTROUTING`.

## Troubleshooting Section

### Port forward exists but connection still times out

```bash
sudo iptables -t nat -S
sudo iptables -S FORWARD
sudo tcpdump -ni any 'host <internal_host_ip> and port <service_port>'
```

Check for:

- DNAT rule present but `FORWARD` chain drops packets
- Missing `ESTABLISHED,RELATED` return rule
- Service on internal host not listening
- IP forwarding disabled
