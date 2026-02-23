# Lab 05: Packet Capture Analysis with tcpdump - Objective

## Clear Technical Goal

Capture and interpret ARP, ICMP, and TCP traffic to prove where communication succeeds or fails in the packet path.

## Skills Trained

- tcpdump filters
- packet timing interpretation
- handshake validation
- evidence collection for tickets

## Operational Relevance

Packet captures are a core escalation tool when logs and CLI outputs do not explain a connectivity issue clearly.

## Lab Topology / Scope

Client and server namespaces on a bridge; local HTTP service generates repeatable TCP traffic for capture.

## Ubuntu Compatibility Notes

- Designed for Ubuntu Server LTS using CLI-only workflows.
- Commands may require `sudo` for namespaces, firewall changes, packet capture, or privileged ports.
- Run this lab in a disposable VM or snapshot when experimenting with firewall/routing changes.

## Deliverables

- Complete `step_by_step_guide.md` workflow and capture key outputs
- Run the misconfiguration scenario and debugging walkthrough
- Reach the final validated state in `full_solution.md`
- Execute `labs/lab_05_packet_capture_analysis/validation_script.sh` and confirm PASS results
