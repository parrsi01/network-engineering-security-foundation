# Security Monitoring Triage Quick Reference

## Suricata EVE (JSON)

```bash
jq -r 'select(.event_type=="alert") | [.timestamp,.src_ip,.dest_ip,.alert.signature] | @tsv' eve.json
```

## Zeek-Style Correlation (TSV)

```bash
awk -F'\t' 'NR==1 || /10\.12\.10\.44/' conn.tsv
awk -F'\t' 'NR==1 || /10\.12\.10\.44/' dns.tsv
```

## Triage Sequence

1. Parse alerts
2. Count repeated signatures/sources
3. Correlate conn/dns metadata
4. Check host/firewall logs
5. Classify and document disposition
