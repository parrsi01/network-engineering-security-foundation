# Lab 02: Subnetting Drills with Reachability Consequences - Objective

## Clear Technical Goal

Practice subnet mask reasoning by proving how wrong prefix lengths change on-link vs gateway behavior using namespaces.

## Skills Trained

- prefix length calculation
- route interpretation
- mask mismatch debugging
- ARP vs routed path distinction

## Operational Relevance

Incorrect subnet masks are a common root cause for partial outages, especially during migrations or manual IP assignments.

## Lab Topology / Scope

Two namespaces connected to a bridge on the host; one phase with correct /24, one phase with intentional /25 mismatch.

## Ubuntu Compatibility Notes

- Designed for Ubuntu Server LTS using CLI-only workflows.
- Commands may require `sudo` for namespaces, firewall changes, packet capture, or privileged ports.
- Run this lab in a disposable VM or snapshot when experimenting with firewall/routing changes.

## Deliverables

- Complete `step_by_step_guide.md` workflow and capture key outputs
- Run the misconfiguration scenario and debugging walkthrough
- Reach the final validated state in `full_solution.md`
- Execute `labs/lab_02_subnetting_drills/validation_script.sh` and confirm PASS results
