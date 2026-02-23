# Lab 12: Segmented Multi-Subnet Services and Policy Enforcement - Troubleshooting Tree

## Decision Tree Logic

If allowed flow fails -> verify listener -> verify route/default gateways -> inspect FORWARD chain counters/order -> capture on router -> retest single flow. If denied flow succeeds -> remove overbroad allow and re-validate segmentation.

## Command-Based Verification Sequence

1. Confirm interfaces/namespaces/processes exist (`ip netns list`, `ip link show`, `ss -tulpn`).
2. Validate addressing and route selection (`ip addr`, `ip route`, `ip route get`).
3. Validate policy controls (`iptables`, service config, control-plane config) as applicable.
4. Use `tcpdump` or log parsing to prove the failure point.
5. Apply one fix, re-test, and record the result.
