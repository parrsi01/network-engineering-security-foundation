# DNS Resolution Flow

## Objective

Understand the host-side DNS lookup path so you can diagnose application failures caused by resolver configuration, upstream DNS outages, or firewall restrictions.

## Resolution Order (Typical Ubuntu)

1. Application requests name resolution (`getaddrinfo`).
2. System resolver checks `/etc/hosts`.
3. Resolver uses configured nameserver(s) (often managed by `systemd-resolved`).
4. DNS query sent over UDP/53 (or TCP/53 for retries/large responses).
5. Response cached and returned to the application.

## Verification Commands

```bash
cat /etc/resolv.conf
resolvectl status || true
dig +short openai.com
getent hosts openai.com
```

Expected output examples:

- `/etc/resolv.conf` contains valid `nameserver` entries
- `dig +short` returns A/AAAA records
- `getent hosts` proves OS resolver path used by many applications

## Internal Packet Perspective

DNS failures often look like application outages because the app never reaches the target service. At the network level, the critical checks are: query leaves host, response returns, resolver accepts it, and application receives the result.

## Common Failure Modes

- Bad `nameserver` IP in `/etc/resolv.conf`
- Local firewall blocking UDP/TCP 53
- DNS server reachable but returning `SERVFAIL`/`NXDOMAIN`
- Split-DNS/VPN resolver mismatch

## Troubleshooting Section

```bash
getent hosts example.com
sudo tcpdump -ni any port 53 -c 20
dig @1.1.1.1 example.com
```

Interpretation:

- No packets on port 53 => resolver not attempting query or app using cached result
- Queries sent, no replies => path/firewall/upstream outage
- Replies contain errors => DNS server/configuration issue rather than transport issue
