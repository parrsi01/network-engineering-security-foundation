# Lab 13: Security Monitoring Alert Triage (Suricata + Zeek Style Logs) - Step-by-Step Guide

## Lab Path

- Working directory reference: `labs/lab_13_security_monitoring_alert_triage`
- Validation script: `labs/lab_13_security_monitoring_alert_triage/validation_script.sh`

## Prerequisites

- Ubuntu Server LTS terminal access
- `sudo` permissions
- Required tools/packages for this lab (see commands below)

## Setup Commands (Exact)

```bash
mkdir -p /tmp/lab13-triage
cp -r labs/lab_13_security_monitoring_alert_triage/samples /tmp/lab13-triage/
command -v jq >/dev/null
echo 'Optional package checks (safe if not installed):'
suricata --build-info >/dev/null 2>&1 || true
zeek --version >/dev/null 2>&1 || true
```

## Execution Steps

### Step 1: Extract alert timeline from EVE JSON

**Exact commands**

```bash
jq -r 'select(.event_type=="alert") | [.timestamp,.src_ip,.src_port,.dest_ip,.dest_port,.alert.signature] | @tsv'                       /tmp/lab13-triage/samples/eve_sample.jsonl
```

**Expected terminal output**

- Tab-separated alert timeline entries with timestamp, src/dst IPs/ports, and signature text.

**What is happening internally (network stack perspective)**

Suricata EVE logs are structured event records derived from packet/stream inspection. Parsing alert fields quickly gives a triage timeline before deep packet review.

### Step 2: Correlate with Zeek-style connection and DNS logs

**Exact commands**

```bash
awk -F'	' 'NR>1 {print $1"	"$2"	"$4"	"$6"	"$7}' /tmp/lab13-triage/samples/conn_sample.tsv
awk -F'	' 'NR>1 {print $1"	"$2"	"$4"	"$5}' /tmp/lab13-triage/samples/dns_sample.tsv
```

**Expected terminal output**

- Connection and DNS records align with alert source/destination and timestamps for correlation.

**What is happening internally (network stack perspective)**

Zeek-style metadata helps determine whether an alert is a scan, a successful connection, or a likely false positive without reading every packet.

### Step 3: Produce a triage summary report

**Exact commands**

```bash
python3 scripts/triage_eve_sample.py                       /tmp/lab13-triage/samples/eve_sample.jsonl                       /tmp/lab13-triage/samples/conn_sample.tsv                       /tmp/lab13-triage/samples/dns_sample.tsv                       > /tmp/lab13-triage/triage_summary.txt
cat /tmp/lab13-triage/triage_summary.txt
```

**Expected terminal output**

- Generated summary identifies alert counts, top source IPs, and correlated DNS/connection observations.

**What is happening internally (network stack perspective)**

A small pipeline converts raw events into analyst-friendly evidence, which mirrors the first stage of operational triage workflows.

## Intentional Misconfiguration Scenario (Required)

Use an incorrect `jq` filter (`event_type=="alerts"`) and observe missing output.

```bash
jq -r 'select(.event_type=="alerts") | .alert.signature' /tmp/lab13-triage/samples/eve_sample.jsonl
echo 'No output indicates a filter/schema mismatch. Use event_type=="alert".'
```

Expected outcome:

- No alerts are returned due to schema/filter mismatch, simulating a broken triage query.

## Real-World Operational Failure Simulation (Required)

Alert flood simulation: a noisy signature triggers repeated alerts, and analysts must confirm whether the pattern is repetitive scanning or production impact.

```bash
jq -r 'select(.event_type=="alert") | .alert.signature' /tmp/lab13-triage/samples/eve_sample.jsonl | sort | uniq -c
grep -F 'ET SCAN' /tmp/lab13-triage/samples/eve_sample.jsonl | wc -l || true
python3 scripts/triage_eve_sample.py /tmp/lab13-triage/samples/eve_sample.jsonl /tmp/lab13-triage/samples/conn_sample.tsv /tmp/lab13-triage/samples/dns_sample.tsv
```

## Debugging Walkthrough (Required)

1. Validate parsing queries against real sample schema (`event_type`, alert fields).
2. Correlate alerts with connection and DNS records before deciding severity.
3. Summarize repeated patterns, impacted hosts, and suggested next action in a short report.

## Permission / Safety Notes

- `sudo` is required for namespaces, packet capture, and firewall changes.
- Stop test services after the lab to avoid unexpected local port conflicts.
- If running remotely, do not apply host firewall changes outside namespaces without recovery access.
