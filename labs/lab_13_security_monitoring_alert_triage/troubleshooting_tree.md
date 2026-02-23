# Lab 13: Security Monitoring Alert Triage (Suricata + Zeek Style Logs) - Troubleshooting Tree

## Decision Tree Logic

If triage query returns no data -> validate JSON schema/filter -> test single-line parse -> correlate with conn/dns logs -> produce summary -> decide noise vs real incident.

## Command-Based Verification Sequence

1. Confirm interfaces/namespaces/processes exist (`ip netns list`, `ip link show`, `ss -tulpn`).
2. Validate addressing and route selection (`ip addr`, `ip route`, `ip route get`).
3. Validate policy controls (`iptables`, service config, control-plane config) as applicable.
4. Use `tcpdump` or log parsing to prove the failure point.
5. Apply one fix, re-test, and record the result.
