# Lab 01: Linux Network Basics and Host Stack Visibility - Objective

## Clear Technical Goal

Inspect interface state, addressing, routes, ARP cache, and listening sockets on Ubuntu and connect symptoms to the correct OSI/TCP-IP layer.

## Skills Trained

- iproute2 inspection
- socket inspection with ss
- ARP neighbor cache validation
- evidence-first troubleshooting sequence

## Operational Relevance

This is the baseline workflow used during nearly every production network incident before deeper packet capture or firewall changes.

## Lab Topology / Scope

Single Ubuntu host (or VM) with optional namespace pair for safe reachability tests.

## Ubuntu Compatibility Notes

- Designed for Ubuntu Server LTS using CLI-only workflows.
- Commands may require `sudo` for namespaces, firewall changes, packet capture, or privileged ports.
- Run this lab in a disposable VM or snapshot when experimenting with firewall/routing changes.

## Deliverables

- Complete `step_by_step_guide.md` workflow and capture key outputs
- Run the misconfiguration scenario and debugging walkthrough
- Reach the final validated state in `full_solution.md`
- Execute `labs/lab_01_linux_network_basics/validation_script.sh` and confirm PASS results
