# Full Course Q&A Sheet (Network Engineering & Security Foundation)

## Foundations

### Q: Why can ping succeed while an application still fails?
A: ICMP success only proves some Layer 3 reachability. The application may still fail due to DNS, TCP port filtering, service bind address, service process state, or application-layer errors.

### Q: What command best proves Linux route selection to a destination?
A: `ip route get <destination>` because it shows the chosen interface, source IP, and next hop.

### Q: When does ARP happen for off-subnet traffic?
A: The host ARPs for the gateway MAC (next hop), not the remote destination host.

## Operations

### Q: Why is `ESTABLISHED,RELATED` important in firewall rules?
A: It allows return traffic for sessions you explicitly permitted, reducing rule count and preventing broken responses.

### Q: NAT rule exists but service still times out. What next?
A: Check `FORWARD` chain rules, `ip_forward`, service listener state, and packet counters/captures.

### Q: How do you prove DNS is the issue and not the network path?
A: Compare `dig @<server>` with default `dig`, inspect resolver config, and capture port 53 traffic.

## Security Awareness

### Q: What is the fastest way to inventory host exposure?
A: `ss -tulpn` plus firewall/NAT review (`iptables`, `ufw`) to compare listeners against policy intent.

### Q: Why is rule order critical in iptables?
A: `iptables` uses first-match behavior; an early `DROP` can shadow later allow rules.
