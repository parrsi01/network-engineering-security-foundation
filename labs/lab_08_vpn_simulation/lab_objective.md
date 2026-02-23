# Lab 08: WireGuard VPN Simulation (Conceptual + Linux Configuration Validation) - Objective

## Clear Technical Goal

Practice WireGuard configuration structure, route reasoning, and basic troubleshooting checks without requiring an external VPN peer.

## Skills Trained

- WireGuard config anatomy
- AllowedIPs route logic
- interface and route validation
- handshake troubleshooting checklist

## Operational Relevance

Operations teams frequently review or troubleshoot VPN configs even when they are not the original implementers.

## Lab Topology / Scope

Single Ubuntu host or VM with local WireGuard config files and optional loopback/namespace-based simulation.

## Ubuntu Compatibility Notes

- Designed for Ubuntu Server LTS using CLI-only workflows.
- Commands may require `sudo` for namespaces, firewall changes, packet capture, or privileged ports.
- Run this lab in a disposable VM or snapshot when experimenting with firewall/routing changes.

## Deliverables

- Complete `step_by_step_guide.md` workflow and capture key outputs
- Run the misconfiguration scenario and debugging walkthrough
- Reach the final validated state in `full_solution.md`
- Execute `labs/lab_08_vpn_simulation/validation_script.sh` and confirm PASS results
