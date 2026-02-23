# 11 - Segmentation and DHCP

## Scope

This section extends the foundation curriculum into VLAN tagging, Linux bridges, DHCP lease flow, and segmented service policy validation.

## Core Ideas

- VLAN tags identify Layer 2 segments on trunk links
- DHCP DORA relies on broadcast traffic and correct local scope/relay behavior
- Segmentation requires routing + policy + service binding alignment

## Commands to Memorize

```bash
ip -d link show type vlan
bridge vlan show
sudo tcpdump -ni <iface> 'udp port 67 or udp port 68'
sudo iptables -L FORWARD -n -v --line-numbers
```
