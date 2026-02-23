# Network Command Reference (Ubuntu)

## Interface and Addressing

```bash
ip -br link
ip -br addr
ip addr show dev <iface>
ip -s link show dev <iface>
```

Use for link state, IP assignment, and interface error counters.

## Routing and Neighbor Tables

```bash
ip route show
ip route get <target_ip>
ip neigh show
traceroute -n <target_ip>
```

Use to prove route selection and next-hop resolution before changing firewall or application config.

## DNS and Resolution

```bash
cat /etc/resolv.conf
resolvectl status
getent hosts <hostname>
dig +short <hostname>
dig @<dns_server_ip> +short <hostname>
```

Use `getent` to test the OS resolver path and `dig @server` to isolate resolver config issues.

## Sockets and Services

```bash
ss -tulpn
ss -tan state syn-sent
systemctl status <service>
journalctl -u <service> --since '15 min ago'
```

Use to confirm listener state and identify transport failures (`SYN-SENT`) vs application errors.

## Packet Capture

```bash
sudo tcpdump -ni <iface> -c 20 host <target_ip>
sudo tcpdump -ni <iface> port 53
sudo tcpdump -ni <iface> 'tcp port 80 or tcp port 443'
```

Capture after interface/address/route checks to avoid collecting noise without context.

## Firewall / NAT

```bash
sudo iptables -S
sudo iptables -L -n -v --line-numbers
sudo iptables -t nat -S
sudo ufw status verbose
```

Always inspect counters and rule order when troubleshooting blocked traffic.
