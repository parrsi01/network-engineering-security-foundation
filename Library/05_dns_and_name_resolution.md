# 05 - DNS and Name Resolution

## Resolver Path vs Direct DNS Queries

- `getent hosts <name>` tests the OS resolver path used by many applications.
- `dig +short <name>` tests DNS query behavior via configured resolver.
- `dig @<server> +short <name>` bypasses resolver config ambiguity.

## Failure Isolation Sequence

```bash
ping -c 2 <dns_server_ip>
cat /etc/resolv.conf
getent hosts <name>
dig @<dns_server_ip> +short <name>
sudo tcpdump -ni any port 53
```

## Common Root Causes

- Wrong nameserver IP
- UDP/53 blocked
- DNS service down or misbound
- Split-DNS mismatch (VPN/local resolver conflict)
