# Ticket 02: DNS Outage - Name Resolution Failures Across Apps

## Ticket Metadata

- Ticket ID: `NET-002`
- Severity: `SEV-2`
- Queue: `Infrastructure Operations / Security Monitoring`
- Reported By: `Monitoring` (synthetic checks)
- Environment: `Ubuntu host + dns-client/dns-server namespaces`

## Summary

Multiple applications report connection failures, but direct IP tests appear healthy. Monitoring indicates elevated DNS query timeouts.

## Symptoms Reported

- `getent hosts` fails for internal names
- `dig +short` returns timeout or no servers reached
- Application logs show host lookup errors

## Initial Evidence (Example)

```bash
sudo ip netns exec dns-client dig +time=1 +tries=1 +short lab6.test
# ;; communications error to 10.60.6.53#53: timed out
# ;; no servers could be reached

sudo ip netns exec dns-client ping -c 2 10.60.6.53
# 2 packets transmitted, 2 received
```

## Suspected Failure Domains

- Wrong resolver IP in `/etc/netns/dns-client/resolv.conf`
- DNS service stopped or misbound in `dns-server` namespace
- UDP/53 blocked by firewall rule

## Expected Responder Workflow

1. Verify resolver config path and nameserver IP
2. Compare direct query `dig @10.60.6.53` vs default `dig`
3. Capture `tcpdump` on port 53 to confirm query/response behavior
4. Inspect DNS namespace firewall rules and `dnsmasq` process

## Root Cause Pattern (For Instructor Use)

Namespace resolver config was changed to the wrong nameserver or UDP/53 was dropped, creating an app-wide outage appearance.

## Resolution Acceptance Criteria

- `dig +short lab6.test` returns expected A record
- `getent hosts lab6.test` succeeds
- Resolver configuration and DNS service status documented
