# Firewall Concepts for Linux Operations

## Scope

This document explains packet filtering concepts using `iptables` and `ufw` on Ubuntu, with emphasis on preventing self-inflicted outages during troubleshooting.

## Core Concepts

- Default policy (`ACCEPT` vs `DROP`)
- Stateful filtering (`ESTABLISHED,RELATED`)
- Inbound vs outbound vs forwarded traffic
- Rule order and first-match behavior (iptables chains)

## CLI Examples

```bash
sudo iptables -S
sudo iptables -L -n -v
sudo ufw status verbose
```

Expected output:

- Packet/byte counters increment on matching rules
- Default chain policy is visible (`policy DROP` or `policy ACCEPT`)
- UFW shows explicit allow/deny rules and routed settings

## Operational Safety Pattern

When modifying firewall rules remotely:

1. Add allow rule for current management session first (for example SSH).
2. Add `ESTABLISHED,RELATED` rule.
3. Validate from a second terminal.
4. Apply stricter defaults only after verification.

## Troubleshooting Section

### Symptom: Service is listening but unreachable

```bash
ss -tulpn | grep ':22\|:80\|:443'
sudo iptables -L INPUT -n -v --line-numbers
sudo ufw status numbered
```

Likely causes:

- Port denied before allow rule (ordering)
- Wrong interface/source CIDR in rule
- UFW enabled while manual iptables rules assumed active
- Service bound only to `127.0.0.1`
