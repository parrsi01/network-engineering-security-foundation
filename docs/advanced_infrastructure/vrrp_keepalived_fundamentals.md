# VRRP and Keepalived Fundamentals (Lab Scope)

## Objective

Understand VRRP virtual IP failover behavior using Keepalived concepts and Linux host checks.

## Key Concepts

- VRRP provides a shared virtual IP (VIP) across redundant routers/hosts
- One node is `MASTER`, another `BACKUP`
- Keepalived commonly implements VRRP on Linux
- Health checks can trigger failover to the backup node

## Ubuntu Commands

```bash
sudo apt install -y keepalived || true
sudo systemctl status keepalived --no-pager || true
ip addr show | grep -A2 'inet '
sudo tcpdump -ni <iface> vrrp -c 20
```

## Internal Packet Perspective

VRRP advertisements are multicast control traffic. If advertisements stop (service down/interface issue), the backup may claim the VIP. ARP updates (gratuitous ARP) help downstream hosts learn the VIP's new MAC mapping.

## Troubleshooting Section

- Check Keepalived config syntax and service status
- Confirm VIP is present on exactly one node at a time
- Verify VRRP advertisements are visible on the correct interface
- Confirm gratuitous ARP updates after failover
