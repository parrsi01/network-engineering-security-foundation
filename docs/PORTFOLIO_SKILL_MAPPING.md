# Portfolio Skill Mapping

Author: Simon Parris  
Date: 2026-02-26

This document maps repository components to job-relevant skills and CV-ready evidence for network engineering and network security roles.

## Networking Fundamentals

Mapped components:

- `docs/fundamentals/`
- `labs/lab_01_linux_network_basics/`
- `labs/lab_02_subnetting_and_routing/`
- `labs/lab_03_dns_and_name_resolution/`

Skills demonstrated:

- IP addressing and subnetting reasoning
- Linux interface and route inspection
- DNS resolution troubleshooting
- packet path explanation from endpoint to gateway/service

## Troubleshooting Operations

Mapped components:

- `docs/troubleshooting/`
- `labs/lab_04_*` through `labs/lab_08_*` (pattern-based progression)
- `incidents/`

Skills demonstrated:

- symptom-to-evidence troubleshooting workflow
- command selection under pressure
- root cause isolation across network layers
- rollback-aware remediation and verification

## Security Foundations

Mapped components:

- `docs/security/`
- `docs/segmentation/`
- `labs/` firewall/NAT/VPN-related labs

Skills demonstrated:

- firewall policy interpretation and validation
- NAT/port-forwarding behavior verification
- segmentation and VLAN concepts
- VPN concept grounding and operational caveats

## Security Monitoring & Triage

Mapped components:

- `docs/security_monitoring/`
- `scripts/triage_eve_sample.py`
- `tests/test_triage_eve_sample.py`

Skills demonstrated:

- alert/log triage workflow design
- network telemetry interpretation
- repeatable triage tooling validation
- basic Python scripting for analyst support workflows

## Advanced Infrastructure

Mapped components:

- `docs/advanced_infrastructure/`
- related advanced labs/configs (OSPF/VRRP/load-balancing progression)

Skills demonstrated:

- HA and routing protocol conceptual understanding
- load balancer operations fundamentals
- structured progression from theory to reproducible lab execution

## CV-Ready Bullet Statements

- Built a version-controlled network engineering and security lab repository with reproducible exercises, validation scripts, and incident-style troubleshooting drills.
- Applied evidence-first debugging across Linux networking, DNS, routing, NAT, and firewall scenarios using packet capture and command-line diagnostics.
- Practiced segmentation, security monitoring, and advanced infrastructure concepts (Suricata/Zeek, OSPF/VRRP/LB) through documented, repeatable learning workflows.
- Added repository quality controls including validation automation, unit tests, CI workflows, and portfolio-ready documentation for interview and onboarding use.
