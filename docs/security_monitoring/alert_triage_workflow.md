# Alert Triage Workflow (Suricata/Zeek + Host Evidence)

## Objective

Provide a repeatable triage process for network alerts that avoids overreacting to single signatures and focuses on evidence correlation.

## Triage Sequence

1. Identify alert type, severity, and timestamp
2. Confirm asset role (client, server, DNS, admin host)
3. Check surrounding network activity (pcap / conn.log / dns.log)
4. Check firewall and host logs
5. Determine benign, suspicious, or malicious pattern
6. Document disposition and next action

## CLI Starter Commands

```bash
jq -r 'select(.event_type=="alert") | [.timestamp,.src_ip,.src_port,.dest_ip,.dest_port,.alert.signature] | @tsv' /var/log/suricata/eve.json | tail -20
sudo tcpdump -ni any host <src_ip> and host <dst_ip> -c 30
grep '<src_ip>' conn.log 2>/dev/null | tail -20
```

## Internal Packet Perspective

Alerts are summaries derived from packet and stream inspection. Triage should verify whether the packet sequence supports the alert narrative (scan, exploit attempt, policy violation, false positive, etc.).

## Troubleshooting Section

### Symptom: High alert volume with low confidence

- Validate HOME_NET / EXTERNAL_NET scoping
- Disable noisy rules only after capturing evidence and documenting rationale
- Correlate with Zeek logs and service exposure inventory before blocking traffic
