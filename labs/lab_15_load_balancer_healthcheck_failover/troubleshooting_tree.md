# Lab 15: HAProxy Load Balancer Health Check and Backend Failover - Troubleshooting Tree

## Decision Tree Logic

If LB frontend fails -> validate haproxy config syntax and listener -> check backend ports/listeners -> restart failed backend(s) -> retest through frontend and direct backend ports.

## Command-Based Verification Sequence

1. Confirm interfaces/namespaces/processes exist (`ip netns list`, `ip link show`, `ss -tulpn`).
2. Validate addressing and route selection (`ip addr`, `ip route`, `ip route get`).
3. Validate policy controls (`iptables`, service config, control-plane config) as applicable.
4. Use `tcpdump` or log parsing to prove the failure point.
5. Apply one fix, re-test, and record the result.
