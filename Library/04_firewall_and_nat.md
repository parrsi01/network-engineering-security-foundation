# 04 - Firewall and NAT

## Stateful Filtering Pattern

```bash
iptables -P FORWARD DROP
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -s <src> -d <dst> -p tcp --dport <port> -j ACCEPT
```

## NAT Reminder

DNAT changes destination before routing, but packets still must pass `FORWARD` chain rules. NAT and filtering must be validated together.

## Key Debug Commands

```bash
sudo iptables -L -n -v --line-numbers
sudo iptables -t nat -L -n -v --line-numbers
sudo tcpdump -ni any 'port 80 or port 8080'
```
