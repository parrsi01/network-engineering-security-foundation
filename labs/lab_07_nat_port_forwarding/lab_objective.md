# Lab 07: NAT and Port Forwarding on a Linux Router Namespace - Objective

## Clear Technical Goal

Configure SNAT/MASQUERADE and DNAT port forwarding, then validate translated traffic with packet capture and service tests.

## Skills Trained

- iptables nat table
- IP forwarding
- DNAT + FORWARD dependencies
- port forwarding troubleshooting

## Operational Relevance

NAT and port forwarding mistakes frequently cause exposure failures and asymmetric traffic issues in branch, lab, and home-office environments.

## Lab Topology / Scope

Three namespaces: client, nat-router, server; router namespace performs DNAT from 8080 -> server:80 and optional SNAT.

## Ubuntu Compatibility Notes

- Designed for Ubuntu Server LTS using CLI-only workflows.
- Commands may require `sudo` for namespaces, firewall changes, packet capture, or privileged ports.
- Run this lab in a disposable VM or snapshot when experimenting with firewall/routing changes.

## Deliverables

- Complete `step_by_step_guide.md` workflow and capture key outputs
- Run the misconfiguration scenario and debugging walkthrough
- Reach the final validated state in `full_solution.md`
- Execute `labs/lab_07_nat_port_forwarding/validation_script.sh` and confirm PASS results
