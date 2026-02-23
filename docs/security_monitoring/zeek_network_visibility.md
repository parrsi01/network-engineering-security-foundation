# Zeek Network Visibility (Lab-Oriented)

## Objective

Understand what Zeek provides (metadata-rich network logs) and how to use it for protocol visibility and triage in a lab environment.

## What Zeek Logs Well

- Connection summaries (`conn.log`)
- DNS transactions (`dns.log`)
- HTTP metadata (`http.log`)
- SSL/TLS metadata (`ssl.log`)
- Notice events (`notice.log`)

## Ubuntu / Lab Commands

```bash
sudo apt install -y zeek || true
zeek --version || true
ls -1 /opt/zeek/logs/current 2>/dev/null || true
```

## Practical Use in This Repo

- Run Zeek on a lab capture interface or offline PCAPs
- Correlate Zeek logs with `tcpdump` captures and firewall events
- Use log-driven triage to identify suspicious connections, DNS spikes, or repeated retries

## Internal Packet Perspective

Unlike packet capture tools that show packet-by-packet detail, Zeek reconstructs higher-level transaction metadata. It complements `tcpdump` by making pattern detection and timeline analysis faster.

## Troubleshooting Section

```bash
ip -br link
sudo tcpdump -ni <iface> -c 20
zeek -Cr <capture.pcap> local || true
ls -1 *.log
head -5 conn.log dns.log 2>/dev/null || true
```

If Zeek logs are empty, confirm the PCAP contains traffic and that the expected protocol parsers are active.
