# Network Engineering & Security Reference Library

> A structured, course-wide reference library for the concepts,
> commands, troubleshooting patterns, and incident workflows used in
> this repository.
> Written for operational learning. Formatted for fast lookup.

---

## How to Use This Library

Each file groups related concepts and command patterns.
Use it as a companion during labs and incident tickets:

- Define the concept quickly
- Map it to Linux CLI commands
- Check common failure patterns
- Apply the verification sequence in the labs

---

## Contents

| # | Topic | Focus Areas |
|---|---|---|
| 01 | [Networking Fundamentals](./01_networking_fundamentals.md) | OSI/TCP-IP mapping, addressing, ARP, routes |
| 02 | [Linux Network CLI](./02_linux_network_cli.md) | `ip`, `ss`, `ping`, `traceroute`, `tcpdump` |
| 03 | [Routing and Subnetting](./03_routing_and_subnetting.md) | prefix logic, gateway selection, forwarding |
| 04 | [Firewall and NAT](./04_firewall_and_nat.md) | iptables/UFW, stateful rules, DNAT/SNAT |
| 05 | [DNS and Name Resolution](./05_dns_and_name_resolution.md) | resolver path, `dig`, `getent`, DNS failures |
| 06 | [Packet Analysis and Observability](./06_packet_analysis_and_observability.md) | packet capture, latency, loss, evidence collection |
| 07 | [VPN and Remote Connectivity](./07_vpn_and_remote_connectivity.md) | WireGuard concepts, route behavior, tunnel checks |
| 08 | [Troubleshooting and Incident Response](./08_troubleshooting_and_incident_response.md) | decision trees, ticket triage, blast radius |
| 09 | [Security Review and Exposure](./09_security_review_and_exposure.md) | ports, attack surface, rule intent vs behavior |
| 10 | [Operational Runbooks and Validation](./10_operational_runbooks_and_validation.md) | checklists, validation scripts, documentation hygiene |
| 00 | [Course Q&A Sheet](./00_full_course_q_and_a_sheet.md) | interview and review prompts |
| 00 | [CLI Demo Sheet](./00_full_course_cli_demo_sheet.md) | ordered command walkthroughs |

---

## Companion Repos Style Alignment

This `Library/` directory intentionally follows the same top-level reference pattern used in the existing `DevOps/Library` and `datascience/Library` repos, so the curriculum family stays consistent.

---

> **Author** — Codex CLI (repository generation session)
> **Format** — Operational reference + command mapping
> **Last Updated** — 2026-02-23
