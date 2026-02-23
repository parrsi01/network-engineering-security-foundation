# Ticket 06: VLAN Trunk Mismatch - Partial Service Segment Outage

## Ticket Metadata

- Ticket ID: `NET-006`
- Severity: `SEV-2`
- Queue: `Network Operations`

## Summary

One application subnet is unreachable after a virtualization host maintenance window, but another subnet using the same trunk remains healthy.

## Symptoms

- VLAN 10 traffic works
- VLAN 20 traffic fails
- Interface/link state appears normal on both hosts

## Expected Workflow

1. Compare VLAN IDs and subinterface configs on both trunk endpoints
2. Capture on parent trunk interface and verify tags (`tcpdump -e vlan`)
3. Correct VLAN ID mismatch and re-test affected subnet only

## Root Cause Pattern (Instructor)

Trunk endpoint configured with wrong VLAN tag on one subinterface (for example VLAN 30 instead of VLAN 20).
