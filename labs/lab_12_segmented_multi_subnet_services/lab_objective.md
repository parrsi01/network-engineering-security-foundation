# Lab 12: Segmented Multi-Subnet Services and Policy Enforcement - Objective

## Clear Technical Goal

Build client/app/db subnets behind a Linux router and enforce least-privilege inter-subnet connectivity with iptables.

## Skills Trained

- multi-subnet routing
- policy segmentation
- service path validation
- counter-based firewall debugging

## Operational Relevance

This mirrors common enterprise segmentation work where application tiers must communicate selectively across subnets.

## Lab Topology / Scope

Namespaces: `s12-client`, `s12-router`, `s12-app`, `s12-db` with routed subnets 10.12.10.0/24, 10.12.20.0/24, 10.12.30.0/24.

## Ubuntu Compatibility Notes

- Designed for Ubuntu Server LTS and CLI execution only.
- Many commands require `sudo` (namespaces, firewall, tcpdump, service binds).
- Use a disposable VM/snapshot before experimenting with firewall or control-plane changes.

## Deliverables

- Complete `labs/lab_12_segmented_multi_subnet_services/step_by_step_guide.md`
- Run `labs/lab_12_segmented_multi_subnet_services/validation_script.sh` and confirm `PASS`
- Document misconfiguration symptoms and recovery steps
