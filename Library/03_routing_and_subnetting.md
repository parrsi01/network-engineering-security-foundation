# 03 - Routing and Subnetting

## Routing Decisions in Linux

Linux decides whether a destination is on-link or off-link using the interface prefix length and route table. Wrong subnet masks create misleading symptoms that look like switch or firewall issues.

## Practical Checks

```bash
ip addr show dev <iface>
ip route get <peer_ip>
traceroute -n <peer_ip>
```

## Fast Subnetting Notes

- `/24`: 254 usable hosts
- `/25`: two subnets of 126 usable hosts each
- `/27`: block size 32 (increments of 32)
- `/30`: point-to-point (2 usable hosts)
