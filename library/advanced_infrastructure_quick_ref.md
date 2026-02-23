# Advanced Infrastructure Quick Reference (OSPF / VRRP / Load Balancers)

## OSPF (FRR)

```bash
sudo vtysh -c 'show ip ospf neighbor'
sudo vtysh -c 'show ip route ospf'
sudo tcpdump -ni <iface> proto 89
```

## VRRP / Keepalived

```bash
sudo systemctl status keepalived --no-pager
ip addr show
sudo tcpdump -ni <iface> vrrp
ip neigh show
```

## HAProxy

```bash
sudo haproxy -c -f /etc/haproxy/haproxy.cfg
ss -tulpn | grep haproxy
curl -sI http://127.0.0.1:8088
```

Always distinguish control-plane health (neighbors/advertisements/health checks) from data-plane symptoms.
