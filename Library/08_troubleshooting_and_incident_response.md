# 08 - Troubleshooting and Incident Response

## Incident Triage Principles

1. Confirm scope and blast radius.
2. Collect evidence before changes.
3. Prove failing layer (interface, route, DNS, firewall, service).
4. Apply minimal corrective change.
5. Validate and document the final state.

## Ticket Evidence Starter Pack

```bash
ip -br addr
ip route show
ss -tulpn
sudo iptables -L -n -v --line-numbers
sudo tcpdump -ni any -c 20 host <target>
```

## Typical Root Cause Categories in This Repo

- Mask mismatch
- Missing default route
- IP forwarding disabled
- Firewall rule order issue
- NAT target IP/port mismatch
- DNS resolver misconfiguration
