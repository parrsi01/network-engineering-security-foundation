# Lab 13: Security Monitoring Alert Triage (Suricata + Zeek Style Logs) - Objective

## Clear Technical Goal

Perform alert triage by correlating Suricata-style EVE alerts with Zeek-style connection/DNS logs and host firewall evidence using CLI tools.

## Skills Trained

- jq alert parsing
- log correlation
- triage workflow
- false-positive/noise handling

## Operational Relevance

SOC and infrastructure teams need fast evidence correlation when alerts fire, especially for scans and suspicious DNS patterns.

## Lab Topology / Scope

CLI-only log triage workflow using sample Suricata EVE JSON and Zeek-style TSV logs included in the lab directory (optional Suricata/Zeek package checks).

## Ubuntu Compatibility Notes

- Designed for Ubuntu Server LTS and CLI execution only.
- Many commands require `sudo` (namespaces, firewall, tcpdump, service binds).
- Use a disposable VM/snapshot before experimenting with firewall or control-plane changes.

## Deliverables

- Complete `labs/lab_13_security_monitoring_alert_triage/step_by_step_guide.md`
- Run `labs/lab_13_security_monitoring_alert_triage/validation_script.sh` and confirm `PASS`
- Document misconfiguration symptoms and recovery steps
