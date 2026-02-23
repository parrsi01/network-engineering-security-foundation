# Network Log Pipeline Basics (Lab to Ops)

## Objective

Build a simple local log pipeline mindset for network/security data: collect, normalize, store, query, and triage.

## Pipeline Stages

1. Collection: Suricata, Zeek, system logs, firewall logs
2. Normalization: parse fields (timestamp, src/dst IPs, ports, action)
3. Storage: local files, JSONL, SQLite, or centralized stack (beyond this repo scope)
4. Query/Triage: `jq`, `awk`, `grep`, Python scripts
5. Response: ticket updates, blocking changes, or escalation

## Ubuntu CLI Examples

```bash
sudo tail -n 50 /var/log/suricata/eve.json
jq -r 'select(.event_type=="alert") | [.timestamp,.src_ip,.dest_ip,.alert.signature] | @tsv' /var/log/suricata/eve.json | head
grep -i 'DROP' /var/log/ufw.log | tail -20 || true
```

## Operational Relevance

A usable pipeline is not only about tooling. It is about preserving enough structure and timestamps to reconstruct what happened quickly during incidents.

## Troubleshooting Section

- If logs are empty: verify the generating service is running and receiving traffic
- If JSON parsing fails: validate line format and rotate/compression state
- If timestamps look wrong: verify system time and timezone (`timedatectl`)
