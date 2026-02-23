# Segmented Multi-Subnet Services

## Objective

Design and troubleshoot simple client/app/database subnet segmentation patterns in Linux namespace labs without introducing enterprise routing complexity.

## Example Segmentation Pattern

- VLAN/Subnet 10: clients (`10.10.10.0/24`)
- VLAN/Subnet 20: app tier (`10.20.20.0/24`)
- VLAN/Subnet 30: database tier (`10.30.30.0/24`)

Policy goals:

- Clients -> app tier allowed on app port only
- App tier -> DB tier allowed on DB port only
- Clients -> DB tier denied

## Ubuntu CLI Validation

```bash
ip route show
sudo iptables -L FORWARD -n -v --line-numbers
ss -tulpn
sudo tcpdump -ni any 'host <app_ip> or host <db_ip>'
```

## Internal Packet Perspective

Segmentation only works if routing, firewall policy, and service binding align. Packets may route correctly but still fail due to filter rules or services binding to loopback only.

## Troubleshooting Section

### Symptom: App tier can reach DB, but clients also reach DB unexpectedly

1. Verify DB bind address (`ss -tulpn`)
2. Inspect `FORWARD` rules and counters
3. Confirm no bypass route/NAT path exists
4. Validate from client and app subnets separately

### Symptom: Clients cannot reach app tier after segmentation rollout

- Check inter-subnet route path
- Check `ESTABLISHED,RELATED` rule placement
- Confirm app service still listening on expected IP/port
