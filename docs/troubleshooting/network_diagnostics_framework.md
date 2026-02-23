# Network Diagnostics Framework

## Purpose

Provide a repeatable, evidence-first troubleshooting workflow for network incidents on Linux systems.

## Golden Rule

Do not jump to solutions. Prove the failing layer first.

## Command Sequence (Baseline)

```bash
ip link show
ip addr show
ip route show
ping -c 2 <gateway_ip>
getent hosts <hostname>
ss -tulpn
sudo tcpdump -ni any -c 20 host <target_ip>
```

## Decision Flow

1. Interface state and addressing valid?
2. Gateway reachable?
3. Route selection correct?
4. Name resolution working?
5. Service listening on expected port?
6. Packets seen leaving/arriving?
7. Firewall/NAT changing or dropping traffic?

## Internal Mechanics Explanation

This order aligns with kernel packet processing: interface/link readiness, address and route selection, local name resolution, socket binding, then packet filtering and transmission. Skipping order causes misdiagnosis and unnecessary config changes.

## Troubleshooting Section

### Common Anti-Patterns

- Restarting services before collecting packet or socket evidence
- Flushing firewall rules without documenting existing policy
- Testing DNS with `ping` only (ICMP != DNS)
- Assuming cloud/security group issues without checking host firewall first
