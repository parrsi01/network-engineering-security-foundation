# Network Attack Surfaces (Foundational Security Awareness)

## Objective

Identify common network exposure patterns that matter in day-to-day operations and basic hardening reviews.

## Common Attack Surfaces

- Unnecessary listening services (`ss -tulpn` reveals exposure)
- Wide-open firewall rules (`0.0.0.0/0` where not intended)
- Misconfigured DNS resolvers or split DNS leaks
- Exposed management ports (SSH, RDP, web admin)
- NAT/port forwards published without authentication or source restrictions

## Quick Assessment Commands

```bash
ss -tulpn
sudo iptables -L -n -v
sudo ufw status verbose
sudo iptables -t nat -S
```

Expected review output:

- Clear mapping from listening ports to intended services
- Explicit deny posture or tightly scoped allow rules
- NAT rules aligned with documented service exposure

## Operational Relevance

Many incidents begin as simple misconfiguration, not sophisticated exploitation. Accurate inventory of ports, routes, and rule intent is a foundational defense skill.

## Troubleshooting Section

### Symptom: Unexpected external exposure reported

1. Validate the process: `ss -tulpn`
2. Validate bind address (`0.0.0.0` vs `127.0.0.1`)
3. Validate firewall rules and counters
4. Validate NAT/port forwarding path
5. Test from expected and unexpected source networks
