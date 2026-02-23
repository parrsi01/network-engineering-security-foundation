# Suricata Lab Deployment (Ubuntu, Lab-Only)

## Objective

Deploy Suricata in a safe lab context to understand interface selection, rule loading, alert output, and common tuning issues.

## Installation (Ubuntu LTS)

```bash
sudo apt update
sudo apt install -y suricata
sudo suricata --build-info | head -20
```

## Basic Validation Commands

```bash
sudo suricata -T -c /etc/suricata/suricata.yaml
sudo systemctl status suricata --no-pager
sudo tail -n 20 /var/log/suricata/fast.log
```

Expected output indicators:

- `suricata -T` reports configuration parsed successfully
- Service starts without interface errors
- `fast.log` receives alerts when test traffic matches enabled rules

## Lab Scope and Safety

- Use mirrored lab traffic or a test interface only
- Avoid inline IPS mode in beginner labs until detection-only triage is understood
- Rule updates can generate noise; triage quality matters more than alert count

## Internal Packet Perspective

Suricata inspects packets/streams, applies signatures/protocol parsers, and writes alerts/logs when traffic matches detection logic. Missing alerts can result from wrong interface, wrong HOME_NET, rule disabled, or traffic never reaching the monitored interface.

## Troubleshooting Section

```bash
sudo suricata -T -c /etc/suricata/suricata.yaml
ip -br link
sudo tcpdump -ni <monitored_iface> -c 20
sudo journalctl -u suricata --since '10 min ago'
ls -lh /var/log/suricata/
```

Validate packet visibility first, then Suricata config/rules, then alert output files.
