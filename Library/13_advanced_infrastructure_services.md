# 13 - Advanced Infrastructure Services (OSPF / VRRP / Load Balancing)

## Scope

Introductory operational checks for routing control-plane protocols, redundancy failover, and load-balancer health in lab environments.

## Key Distinction

- OSPF/VRRP: control-plane state and advertisements
- Load balancers: frontend/backends + health checks
- Data-plane symptoms often reflect hidden control-plane failures

## Baseline Checks

```bash
sudo vtysh -c 'show ip ospf neighbor' || true
ip addr show
ip neigh show
sudo haproxy -c -f /etc/haproxy/haproxy.cfg || true
```
