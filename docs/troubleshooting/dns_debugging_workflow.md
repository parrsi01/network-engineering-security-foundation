# DNS Debugging Workflow

## Purpose

Define a decision-driven workflow for isolating DNS problems from general connectivity problems.

## Verification Order

1. Confirm general IP reachability (`ping` gateway / public IP)
2. Check resolver configuration (`/etc/resolv.conf`, `resolvectl status`)
3. Query default resolver (`dig`, `getent hosts`)
4. Query known-good resolver directly (`dig @1.1.1.1`)
5. Capture DNS traffic (`tcpdump port 53`)
6. Validate firewall rules for UDP/TCP 53

## CLI Sequence

```bash
ping -c 2 1.1.1.1
cat /etc/resolv.conf
getent hosts example.com
 dig +short example.com
 dig @1.1.1.1 +short example.com
sudo tcpdump -ni any port 53 -c 20
```

Expected outcomes:

- Public IP reachable but DNS fails => likely resolver/firewall/config issue
- Direct query works but default resolver fails => local resolver path misconfigured
- No replies from any resolver => upstream path or filtering issue

## Internal Mechanics

The resolver library and DNS server interaction occur before the application opens a TCP session to the destination service. Fixing DNS is often the fastest restoration path for app failures that appear unrelated.

## Troubleshooting Section

### Common Root Causes

- Typo in nameserver IP
- VPN overwrote resolver unexpectedly
- Local firewall drops UDP/53 but allows TCP/53 (or vice versa)
- DNS service reachable but returning stale or wrong records due to cache/split horizon
