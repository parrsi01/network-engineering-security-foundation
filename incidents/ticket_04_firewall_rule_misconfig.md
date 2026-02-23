# Ticket 04: Firewall Rule Misconfiguration - Change Window Regression

## Ticket Metadata

- Ticket ID: `NET-004`
- Severity: `SEV-1` (lab simulation)
- Queue: `Network Security Operations`
- Reported By: `Change validation failed`
- Environment: `Linux router namespace with iptables`

## Summary

A firewall hardening change was applied, after which approved application traffic is blocked. Change notes claim the required allow rules were added.

## Symptoms Reported

- Approved service traffic is blocked immediately after change
- `iptables -L` output appears to include allow rules
- Rollback pressure is high due to service impact

## Change Context

- Goal: enforce `FORWARD DROP` by default
- Risk: rule order and conntrack state rules not validated before enforcement

## Expected Responder Workflow

1. Capture line-numbered `FORWARD` chain and counters
2. Identify any broad `DROP` rule ahead of allow rules
3. Validate `ESTABLISHED,RELATED` rule presence and placement
4. Apply minimal corrective change, not full flush, if possible
5. Re-run validation and document final rule order

## Root Cause Pattern (For Instructor Use)

A broad `DROP` rule was inserted at the top of the chain, shadowing later allow rules. In some variants, `ESTABLISHED,RELATED` was missing.

## Resolution Acceptance Criteria

- Approved traffic restored
- Rule order documented with line numbers
- Post-change validation includes counters and service test output
