# OSPF Foundations with FRR (Lab Scope)

## Objective

Introduce OSPF neighbor relationships and route exchange using FRR in Linux namespaces as an advanced progression topic after static routing fluency.

## Scope Boundaries

- Focus on OSPF basics only (adjacency, network statements, route learning)
- No BGP, route maps, or enterprise-scale design in this repository
- Use namespaces for safe experiments

## Ubuntu Lab Commands (FRR)

```bash
sudo apt install -y frr frr-pythontools || true
sudo vtysh -c 'show version' || true
sudo vtysh -c 'show ip ospf neighbor' || true
sudo vtysh -c 'show ip route ospf' || true
```

## Internal Packet Perspective

OSPF uses IP protocol 89 (not TCP/UDP). Neighbors exchange hello packets, form adjacencies, and then exchange LSAs to compute routes. Firewall policies that ignore protocol 89 can silently break OSPF.

## Troubleshooting Section

```bash
ip addr show
ip route show
sudo vtysh -c 'show ip ospf interface' || true
sudo vtysh -c 'show ip ospf neighbor' || true
sudo tcpdump -ni <iface> proto 89 -c 20
```

Check interface addressing, OSPF area/network statements, and protocol 89 visibility before assuming FRR is broken.
