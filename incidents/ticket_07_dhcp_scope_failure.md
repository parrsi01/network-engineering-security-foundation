# Ticket 07: DHCP Scope Failure - Endpoints Not Receiving Leases

## Ticket Metadata

- Ticket ID: `NET-007`
- Severity: `SEV-2`
- Queue: `Infrastructure Operations`

## Summary

New endpoints on a lab segment fail to obtain IP addresses after DHCP configuration changes.

## Symptoms

- `dhclient` shows `No DHCPOFFERS received`
- DHCP server process appears to be running
- Ping to DHCP server interface may still work

## Expected Workflow

1. Validate DHCP server interface IP/subnet
2. Review `dhcp-range` scope and options
3. Capture UDP 67/68 traffic on the segment
4. Check local firewall rules on DHCP server host/namespace

## Root Cause Pattern (Instructor)

Scope configured for the wrong subnet or UDP/67 blocked locally.
