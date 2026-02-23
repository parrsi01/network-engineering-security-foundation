# IDS/IPS Overview (Conceptual + Lab Simulation Context)

## Objective

Provide a practical operations-level understanding of intrusion detection vs intrusion prevention without requiring enterprise appliances.

## Definitions

- IDS (Intrusion Detection System): observes and alerts on suspicious traffic/events
- IPS (Intrusion Prevention System): inline enforcement that blocks/mutates traffic based on policy/signatures

## What This Repo Simulates

- Suspicious port scans / repeated connection attempts via logs and packet capture
- Firewall counters as a basic prevention signal
- Packet evidence collection for analyst triage

## Key Evidence Sources on Ubuntu

```bash
sudo journalctl -u ufw --since '10 min ago' || true
sudo dmesg | grep -i 'DROP\|REJECT' || true
sudo tcpdump -ni any port 22 or port 80
ss -tulpen
```

## Internal Packet Perspective

An IDS typically observes mirrored or local traffic and generates alerts. An IPS sits in path (or host firewall acts as a host-based IPS) and can block packets before applications receive them. In labs, `iptables`/`ufw` plus packet capture gives a simplified but accurate mental model.

## Troubleshooting Section

### Symptom: Traffic missing from application logs

Confirm whether traffic is blocked earlier:

1. `tcpdump` on ingress interface (packet seen?)
2. Firewall counters/logs (packet dropped?)
3. `ss -tulpn` (listener exists?)
4. Application logs (request processed?)

If packets hit the interface but never reach the app, firewall/filtering is the first suspect.
