# Lab 10: VLAN Subinterfaces and Linux Bridge Segmentation - Troubleshooting Tree

## Decision Tree Logic

If one VLAN works and another fails -> compare VLAN IDs on both sides -> capture tagged frames on parent trunk -> correct tag mismatch -> retest reachability.

## Command-Based Verification Sequence

1. Confirm interfaces/namespaces/processes exist (`ip netns list`, `ip link show`, `ss -tulpn`).
2. Validate addressing and route selection (`ip addr`, `ip route`, `ip route get`).
3. Validate policy controls (`iptables`, service config, control-plane config) as applicable.
4. Use `tcpdump` or log parsing to prove the failure point.
5. Apply one fix, re-test, and record the result.
