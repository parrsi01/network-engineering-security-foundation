# Lab 03: Routing Simulation with Linux Namespaces - Objective

## Clear Technical Goal

Build a client-router-server topology, enable IP forwarding, and prove routed connectivity with `ping`, `ip route`, and `traceroute`.

## Skills Trained

- multi-namespace topology setup
- static routing
- IP forwarding
- route-path troubleshooting

## Operational Relevance

Routing errors are frequent during host migrations, firewall deployments, and VLAN segmentation changes.

## Lab Topology / Scope

Three namespaces: `r3-client`, `r3-router`, `r3-server` connected via two veth pairs.

## Ubuntu Compatibility Notes

- Designed for Ubuntu Server LTS using CLI-only workflows.
- Commands may require `sudo` for namespaces, firewall changes, packet capture, or privileged ports.
- Run this lab in a disposable VM or snapshot when experimenting with firewall/routing changes.

## Deliverables

- Complete `step_by_step_guide.md` workflow and capture key outputs
- Run the misconfiguration scenario and debugging walkthrough
- Reach the final validated state in `full_solution.md`
- Execute `labs/lab_03_routing_simulation/validation_script.sh` and confirm PASS results
