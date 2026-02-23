# Load Balancer Operations (L4/L7 Foundations)

## Objective

Understand basic load balancer behavior, health checks, and failure modes using HAProxy/Nginx-style examples in Ubuntu labs.

## Core Concepts

- Frontend listener receives client connections
- Backend pool contains one or more application servers
- Health checks determine backend eligibility
- Load balancing can be Layer 4 (TCP) or Layer 7 (HTTP-aware)

## Ubuntu Commands (HAProxy Example)

```bash
sudo apt install -y haproxy || true
sudo haproxy -c -f /etc/haproxy/haproxy.cfg || true
sudo systemctl status haproxy --no-pager || true
ss -tulpn | grep ':80\|:443'
```

## Internal Packet Perspective

The load balancer terminates or proxies client connections, creates backend connections, and forwards responses. A client-visible timeout can be frontend bind failure, backend health failure, firewall issue, or application issue.

## Troubleshooting Section

```bash
sudo haproxy -c -f /etc/haproxy/haproxy.cfg || true
ss -tulpn | grep haproxy || true
curl -sI http://127.0.0.1/
sudo tcpdump -ni any 'host <backend_ip> and port <backend_port>' -c 20
```

Validate config syntax, frontend listener, backend reachability, and health-check status separately.
