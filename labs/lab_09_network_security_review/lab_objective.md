# Lab 09: Network Security Review and Exposure Assessment - Objective

## Clear Technical Goal

Perform an operational security review of listening ports, firewall policy, and NAT exposure using a repeatable checklist and evidence capture workflow.

## Skills Trained

- port exposure assessment
- firewall audit
- service bind review
- risk documentation

## Operational Relevance

Security and operations teams routinely need quick exposure assessments after deployments or incident alerts.

## Lab Topology / Scope

Single host or namespace-based service host with optional NAT/firewall rules for demonstration.

## Ubuntu Compatibility Notes

- Designed for Ubuntu Server LTS using CLI-only workflows.
- Commands may require `sudo` for namespaces, firewall changes, packet capture, or privileged ports.
- Run this lab in a disposable VM or snapshot when experimenting with firewall/routing changes.

## Deliverables

- Complete `step_by_step_guide.md` workflow and capture key outputs
- Run the misconfiguration scenario and debugging walkthrough
- Reach the final validated state in `full_solution.md`
- Execute `labs/lab_09_network_security_review/validation_script.sh` and confirm PASS results
