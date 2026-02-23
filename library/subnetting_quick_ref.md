# Subnetting Quick Reference

## Common Prefixes

| Prefix | Mask | Total IPs | Usable Hosts | Notes |
|---|---|---:|---:|---|
| /30 | 255.255.255.252 | 4 | 2 | Point-to-point links |
| /29 | 255.255.255.248 | 8 | 6 | Small infrastructure segment |
| /28 | 255.255.255.240 | 16 | 14 | Small server subnet |
| /27 | 255.255.255.224 | 32 | 30 | Medium segment |
| /26 | 255.255.255.192 | 64 | 62 | Department / service block |
| /25 | 255.255.255.128 | 128 | 126 | Split a /24 into two |
| /24 | 255.255.255.0 | 256 | 254 | Common LAN |
| /23 | 255.255.254.0 | 512 | 510 | Expanded LAN |
| /22 | 255.255.252.0 | 1024 | 1022 | Large internal segment |

## Fast Mental Checks

- `/25` splits a `/24` into `0-127` and `128-255`
- `/26` increments by `64`
- `/27` increments by `32`
- `/28` increments by `16`
- `/29` increments by `8`

## Route Decision Reminder

The subnet mask controls whether Linux ARPs directly or forwards to a gateway. Wrong prefix length changes behavior before any firewall rule is evaluated.

## CLI Validation

```bash
ip addr show dev <iface>
ip route get <peer_ip>
python3 - <<'PY'
import ipaddress
print(ipaddress.ip_interface('10.20.30.65/27').network)
PY
```
