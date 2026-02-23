# Troubleshooting Checklist (Evidence-First)

## Universal Sequence

1. Confirm scope: one host, one subnet, many users, or all traffic.
2. Validate interface/link state (`ip -br link`).
3. Validate addressing and mask (`ip -br addr`).
4. Validate route selection (`ip route get <target>`).
5. Validate name resolution (`getent hosts`, `dig`).
6. Validate listener/service (`ss -tulpn`, `systemctl status`).
7. Validate firewall/NAT (`iptables`, `ufw`).
8. Capture packets (`tcpdump`) to prove where flow stops.
9. Re-test after each single change.
10. Document evidence and final state.

## High-Risk Change Safety

- Use console access or snapshots before firewall/routing changes.
- Add management allow rules before tightening defaults.
- Avoid flushes during active incidents unless rollback is impossible.
- Record pre-change rule sets and route tables.

## Escalation Triggers

- Intermittent packet loss with no host-level explanation
- Suspected upstream route asymmetry
- Multiple services impacted across subnets
- Security exposure or unexpected port publication
