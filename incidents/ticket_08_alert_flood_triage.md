# Ticket 08: Alert Flood - Suricata Signature Noise vs Real Incident

## Ticket Metadata

- Ticket ID: `NET-008`
- Severity: `SEV-3` (can escalate)
- Queue: `Security Operations`

## Summary

Monitoring reports a spike in IDS alerts on internal web traffic. The team must determine whether this is malicious scanning, a noisy rule, or expected testing activity.

## Expected Workflow

1. Parse Suricata EVE alert timeline (`jq`)
2. Correlate with Zeek conn/dns logs and firewall events
3. Identify repeated source(s), signatures, and affected assets
4. Classify as noise / suspicious / malicious and document action

## Root Cause Pattern (Instructor)

Repeated low-confidence scan-like signatures from a known internal test host; no service compromise indicators in correlated logs.
