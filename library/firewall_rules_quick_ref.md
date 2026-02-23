# Firewall Rules Quick Reference (iptables/UFW)

## Safe iptables Baseline Pattern (Router Namespace)

```bash
iptables -P FORWARD DROP
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -s <src_cidr> -d <dst_ip> -p tcp --dport <port> -j ACCEPT
```

## Host INPUT Pattern (Example)

```bash
iptables -P INPUT DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -s <mgmt_cidr> -j ACCEPT
```

## NAT Essentials

```bash
iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 10.20.70.10:80
iptables -A FORWARD -d 10.20.70.10/32 -p tcp --dport 80 -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.10.70.0/24 -j MASQUERADE
```

## UFW Quick Commands

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from 10.10.10.0/24 to any port 22 proto tcp
sudo ufw status verbose
```

## Troubleshooting Reminders

- Rule order matters (`iptables` first match)
- NAT does not replace filter rules
- Check counters (`-v`) to confirm matches
- Confirm service is listening before blaming firewall
