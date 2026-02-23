# VLAN, DHCP, and Segmentation Quick Reference

## VLAN / Bridge Checks

```bash
ip -d link show type vlan
bridge link show
bridge vlan show
sudo tcpdump -eni <trunk_iface> vlan
```

## DHCP Checks

```bash
sudo ss -lunp | grep ':67\|:68'
sudo tcpdump -ni <iface> 'udp port 67 or udp port 68'
sudo dhclient -v <iface>
```

## Segmentation Policy Checks

```bash
sudo iptables -L FORWARD -n -v --line-numbers
ss -tulpn
ip route get <target_ip>
```

Rule of thumb: prove route path and listener first, then prove policy allow/deny intent with counters.
