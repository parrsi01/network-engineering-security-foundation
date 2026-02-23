# Lab 06: DNS Failure Debugging Workflow - Objective

## Clear Technical Goal

Diagnose DNS failures by separating resolver configuration issues, transport issues, and upstream response problems using `dig`, `getent`, and packet capture.

## Skills Trained

- resolver path validation
- dig/getent comparison
- DNS traffic capture
- namespace-specific resolver config

## Operational Relevance

DNS failures often look like full application outages; fast isolation prevents unnecessary service restarts and escalations.

## Lab Topology / Scope

Client namespace queries a dnsmasq server in a DNS namespace; resolver path is controlled via `/etc/netns/<ns>/resolv.conf`.

## Ubuntu Compatibility Notes

- Designed for Ubuntu Server LTS using CLI-only workflows.
- Commands may require `sudo` for namespaces, firewall changes, packet capture, or privileged ports.
- Run this lab in a disposable VM or snapshot when experimenting with firewall/routing changes.

## Deliverables

- Complete `step_by_step_guide.md` workflow and capture key outputs
- Run the misconfiguration scenario and debugging walkthrough
- Reach the final validated state in `full_solution.md`
- Execute `labs/lab_06_dns_failure_debugging/validation_script.sh` and confirm PASS results
