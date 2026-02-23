# Subnetting Mastery (Operations Focus)

## Objective

Build subnetting accuracy for host counts, broadcast domains, and route boundaries so you can diagnose addressing mistakes quickly.

## Operational Questions Subnetting Answers

- Are two hosts on the same subnet or does traffic require a router?
- Is the configured mask too broad (security/routing risk) or too narrow (reachability loss)?
- Which IPs are network, broadcast, and usable host addresses?

## CLI Verification Commands

```bash
ip addr show dev eth0
ip route show
python3 - <<'PY'
import ipaddress
net = ipaddress.ip_network('10.20.30.64/27')
print(net.network_address, net.broadcast_address, net.num_addresses)
PY
```

Expected result for `/27` example:

- Network: `10.20.30.64`
- Broadcast: `10.20.30.95`
- Total addresses: `32` (30 usable for hosts)

## Internal Mechanics

Subnet masks determine whether the kernel treats a destination as on-link (ARP directly) or off-link (send to gateway). A wrong mask changes forwarding behavior before any firewall or application logic is involved.

## Troubleshooting Section

### Symptom: Host cannot reach peer on the "same network"

```bash
ip addr show dev eth0
ip route get <peer_ip>
ping -c 2 <peer_ip>
```

Interpretation:

- If `ip route get` says `via <gateway>` but hosts should be on same VLAN, mask is likely too narrow.
- If host ARPs for a remote address directly, mask may be too broad and bypassing the gateway.

## Common Interview Trap

A host on `192.168.10.130/25` is *not* in the same subnet as `192.168.10.10/25`. The `/25` split is `0-127` and `128-255`.
