# Ticket 09: VRRP/Keepalived Failover Drift - VIP Ownership Unclear

## Ticket Metadata

- Ticket ID: `NET-009`
- Severity: `SEV-2`
- Queue: `Advanced Infrastructure`

## Summary

During failover testing, clients intermittently lose reachability to the virtual IP. Teams disagree on which node currently owns the VIP.

## Expected Workflow

1. Verify VIP ownership on each node (`ip addr`)
2. Inspect Keepalived state/service logs
3. Capture VRRP advertisements (`tcpdump vrrp`) if available
4. Confirm client ARP table updates / gratuitous ARP behavior

## Root Cause Pattern (Instructor)

Config drift or stale ARP obscures VIP ownership after failover events.
