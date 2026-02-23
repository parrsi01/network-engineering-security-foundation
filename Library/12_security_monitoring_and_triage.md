# 12 - Security Monitoring and Triage

## Scope

Operational use of Suricata-style alerts and Zeek-style metadata for evidence-driven alert triage.

## Why It Matters

High alert volume without correlation leads to noise and bad decisions. A small CLI-based pipeline can rapidly classify common scan/policy alerts.

## Practical Tools

- `jq` for EVE JSON parsing
- `awk`/`grep` for Zeek TSV logs
- `tcpdump` for packet corroboration
- Host/firewall logs for disposition context
