# Lab 04: Firewall Configuration with iptables/UFW on a Lab Router - Objective

## Clear Technical Goal

Apply, validate, and troubleshoot stateful firewall rules that allow only intended traffic between simulated client and server networks.

## Skills Trained

- iptables filter chains
- stateful rules
- UFW policy verification
- rule-order troubleshooting

## Operational Relevance

Firewall misconfiguration is a common outage source and a frequent interview scenario for both network and security roles.

## Lab Topology / Scope

Reuse a client-router-server namespace topology; router namespace enforces `FORWARD` rules.

## Ubuntu Compatibility Notes

- Designed for Ubuntu Server LTS using CLI-only workflows.
- Commands may require `sudo` for namespaces, firewall changes, packet capture, or privileged ports.
- Run this lab in a disposable VM or snapshot when experimenting with firewall/routing changes.

## Deliverables

- Complete `step_by_step_guide.md` workflow and capture key outputs
- Run the misconfiguration scenario and debugging walkthrough
- Reach the final validated state in `full_solution.md`
- Execute `labs/lab_04_firewall_configuration/validation_script.sh` and confirm PASS results
